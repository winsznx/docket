import 'dart:async';

import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/shared/live_stream.dart';
import 'package:docket_flutter/surfaces/board/announcer.dart';
import 'package:docket_flutter/surfaces/board/board_controller.dart';
import 'package:docket_flutter/surfaces/board/board_layout.dart';
import 'package:docket_flutter/surfaces/board/local_board_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final _t0 = DateTime.utc(2026, 10, 14, 9);

class _RecordingAnnouncer implements Announcer {
  final spoken = <String>[];
  int chimes = 0;

  final _voice = ValueNotifier(VoiceSupport.available);

  @override
  ValueListenable<VoiceSupport> get voice => _voice;

  @override
  bool get unlocked => true;

  @override
  Future<void> unlock() async {}

  @override
  void announce(String speech, {required bool chime, required bool speak}) {
    if (chime) chimes++;
    if (speak) spoken.add(speech);
  }

  @override
  void dispose() => _voice.dispose();
}

class _FakeDesk implements LocalBoardSource {
  BoardView? view;
  final asked = <String?>[];

  @override
  Future<BoardView?> read({String? clinicSlug}) async {
    asked.add(clinicSlug);
    return view;
  }
}

BoardView _view({
  List<BoardCall> calls = const [],
  List<BoardRoom>? rooms,
  Map<String, int> waiting = const {'Consultation': 3},
}) => BoardView(
  clinicName: 'Ikeja Family Clinic',
  rooms:
      rooms ??
      [
        BoardRoom(roomName: 'Room 1', state: RoomState.open),
        BoardRoom(roomName: 'Room 2', state: RoomState.paused),
      ],
  recentCalls: calls,
  waitingByLine: waiting,
  joinUrl: 'https://docket.example/j/ikeja-family',
  serverTime: _t0,
);

BoardCall _call(String label, String room, Duration after) => BoardCall(
  label: label,
  roomName: room,
  calledAt: _t0.add(after),
  callVersion: 1,
);

void main() {
  late StreamController<BoardView> stream;
  late _RecordingAnnouncer announcer;
  late _FakeDesk desk;
  late BoardController board;
  var now = _t0;

  setUp(() {
    now = _t0;
    stream = StreamController<BoardView>();
    announcer = _RecordingAnnouncer();
    desk = _FakeDesk();
  });

  BoardController make({Future<BoardView> Function()? snapshot}) =>
      board = BoardController(
        snapshot: snapshot ?? () async => _view(),
        watch: () => stream.stream,
        local: desk,
        announcer: announcer,
        serverNow: () => now,
        deviceNow: () => now,
      );

  testWidgets('announces a new call from the server once', (tester) async {
    make().start();
    stream.add(_view());
    await tester.pump();
    expect(announcer.spoken, isEmpty);

    now = _t0.add(const Duration(seconds: 3));
    stream.add(
      _view(calls: [_call('C-031', 'Room 2', const Duration(seconds: 2))]),
    );
    await tester.pump();
    expect(announcer.spoken, ['C 31, please go to Room 2']);
    expect(announcer.chimes, 1);
    expect(board.flashes, {'Room 2': 1});

    stream.add(
      _view(calls: [_call('C-031', 'Room 2', const Duration(seconds: 2))]),
    );
    await tester.pump();
    expect(announcer.spoken, hasLength(1));

    board.dispose();
    unawaited(stream.close());
  });

  testWidgets('switches to the desk database while the stream is down, '
      'and back when it returns', (tester) async {
    var snapshotView = _view();
    make(snapshot: () async => snapshotView).start();
    stream.add(_view());
    await tester.pump();
    expect(board.isLocal, isFalse);

    desk.view = _view(
      calls: [_call('C-040', 'Room 1', const Duration(seconds: 30))],
      rooms: [
        BoardRoom(
          roomName: 'Room 1',
          state: RoomState.open,
          nowServingLabel: 'C-040',
        ),
      ],
    );
    now = _t0.add(const Duration(seconds: 31));
    stream.addError(Exception('The connection dropped.'));
    await tester.pump();
    expect(board.liveState, LiveState.stale);
    expect(board.isLocal, isTrue);
    expect(desk.asked.first, 'ikeja-family');
    expect(announcer.spoken, ['C 40, please go to Room 1']);

    stream = StreamController<BoardView>();
    snapshotView = _view(
      calls: [_call('C-040', 'Room 1', const Duration(seconds: 50))],
    );
    now = _t0.add(const Duration(seconds: 52));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(board.isLocal, isFalse);
    expect(
      announcer.spoken,
      ['C 40, please go to Room 1'],
      reason: 'The synced call was already said from the desk database.',
    );

    final pollsBefore = desk.asked.length;
    stream.add(snapshotView);
    await tester.pump(const Duration(seconds: 5));
    expect(board.liveState, LiveState.live);
    expect(desk.asked.length, pollsBefore, reason: 'Polling stops when live.');

    board.dispose();
    unawaited(stream.close());
  });

  testWidgets('the browser going offline switches to the desk database '
      'at once, even while the stream still looks open', (tester) async {
    make().start();
    stream.add(_view());
    await tester.pump();

    desk.view = _view(
      calls: [_call('C-050', 'Room 1', const Duration(seconds: 10))],
    );
    now = _t0.add(const Duration(seconds: 11));
    board.browserOffline();
    await tester.pump();
    expect(board.isLocal, isTrue);
    expect(board.isStale, isTrue);
    expect(announcer.spoken, ['C 50, please go to Room 1']);

    board.browserOnline();
    await tester.pump();
    expect(board.isLocal, isFalse, reason: 'The last server view is back.');

    stream.add(
      _view(calls: [_call('C-050', 'Room 1', const Duration(seconds: 20))]),
    );
    now = _t0.add(const Duration(seconds: 21));
    await tester.pump();
    expect(announcer.spoken, hasLength(1));

    board.dispose();
    unawaited(stream.close());
  });

  testWidgets('a revoked board link shows the server message', (tester) async {
    make().start();
    stream.addError(
      DocketException(
        code: DocketErrorCode.clinicNotFound,
        message:
            "This board link doesn't work any more. Get the new one from the owner page.",
      ),
    );
    await tester.pump();
    expect(board.fatalMessage, startsWith("This board link doesn't work"));
    expect(desk.asked, isEmpty);
    board.dispose();
    unawaited(stream.close());
  });

  group('BoardLayout', () {
    setUpAll(() async {
      final loader = FontLoader('AtkinsonHyperlegibleNext');
      for (final weight in ['Regular', 'Medium', 'Bold', 'ExtraBold']) {
        loader.addFont(
          rootBundle.load('assets/fonts/AtkinsonHyperlegibleNext-$weight.ttf'),
        );
      }
      await loader.load();
    });

    Future<void> pumpBoard(
      WidgetTester tester,
      BoardView view, {
      bool local = false,
      Map<String, int> flashes = const {},
    }) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: BoardLayout(view: view, flashes: flashes, isLocal: local),
        ),
      );
    }

    final busy = _view(
      calls: [
        _call('C-031', 'Room 1', const Duration(minutes: 2)),
        _call('C-030', 'Room 1', const Duration(minutes: 1)),
      ],
      rooms: [
        BoardRoom(
          roomName: 'Room 1',
          state: RoomState.open,
          nowServingLabel: 'C-031',
        ),
        BoardRoom(roomName: 'Room 2', state: RoomState.paused),
        BoardRoom(roomName: 'Lab Bench', state: RoomState.open),
      ],
      waiting: {'Consultation': 12, 'Lab': 3},
    );

    testWidgets('shows rooms, calls, waiting counts and the join QR', (
      tester,
    ) async {
      await pumpBoard(tester, busy);
      expect(find.text('C-031'), findsNWidgets(2));
      expect(find.text('On a short break'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Consultation'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Scan to join. No app needed.'), findsOneWidget);
      expect(find.text('Local mode'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the room label is at least 18% of the screen height', (
      tester,
    ) async {
      await pumpBoard(tester, busy);
      final label = tester.widget<Text>(
        find.descendant(
          of: find.byType(RoomColumn),
          matching: find.text('C-031'),
        ),
      );
      expect(label.style!.fontSize, greaterThanOrEqualTo(1080 * 0.18));
    });

    testWidgets('local mode shows its badge', (tester) async {
      await pumpBoard(tester, busy, local: true);
      expect(find.text('Local mode'), findsOneWidget);
    });

    testWidgets('a new call floods its room, then it settles', (tester) async {
      await pumpBoard(tester, busy);
      await pumpBoard(tester, busy, flashes: {'Room 1': 1});
      await tester.pump(const Duration(milliseconds: 100));
      ColoredBox field() => tester.widget<ColoredBox>(
        find
            .descendant(
              of: find.byType(RoomColumn).first,
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(field().color, const Color(0xFFFFC928));
      await tester.pump(boardFlashLength);
      expect(field().color, const Color(0xFF0B1440));
    });
  });
}
