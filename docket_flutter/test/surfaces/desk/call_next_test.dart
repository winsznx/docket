import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:docket_flutter/shared/strings.dart';
import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/surfaces/desk/desk_board.dart';
import 'package:docket_flutter/surfaces/desk/widgets/call_next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _clinic = UuidValue.fromString('01900000-0000-7000-8000-000000000100');
final _line = UuidValue.fromString('01900000-0000-7000-8000-000000000101');
final _room = UuidValue.fromString('01900000-0000-7000-8000-000000000102');
final _device = UuidValue.fromString('01900000-0000-7000-8000-000000000103');
final _now = DateTime.utc(2026, 10, 14, 10);

DeskView _view({
  DayState? day = DayState.open,
  RoomState room = RoomState.open,
  List<TicketView> tickets = const [],
}) => DeskView(
  reslotOffset: 3,
  maxReslots: 1,
  clinicId: _clinic,
  clinicName: 'Sandbox Clinic ABCD',
  clinicSlug: 'sandbox-abcd',
  isSandbox: true,
  day: day,
  lines: [
    LineView(
      id: _line,
      name: 'Consultation',
      code: 'C',
      version: 3,
      acceptingJoins: true,
      tickets: tickets,
      medianServiceSeconds: 480,
      sampleCount: 0,
      servedToday: 0,
    ),
  ],
  rooms: [
    RoomView(
      id: _room,
      name: 'Room 1',
      lineId: _line,
      state: room,
      deskOnline: true,
    ),
  ],
  joinUrl: 'http://localhost:8082/j/sandbox-abcd',
  serverTime: _now,
);

LocalTicket _waiting(String id) => LocalTicket(
  id: UuidValue.fromString('01900000-0000-7000-8000-000000000$id'),
  lineId: _line,
  label: 'C-$id',
  displayName: 'Demo $id',
  state: TicketState.waiting,
  priorityRank: 1,
  sortKey: 1024,
  isDemo: true,
  updatedAt: _now,
);

DeskBoard _board({
  DayState? day = DayState.open,
  RoomState room = RoomState.open,
  List<LocalTicket> tickets = const [],
  List<DeskAction> pending = const [],
}) => DeskBoard.compose(
  view: _view(day: day, room: room),
  tickets: tickets,
  pending: pending,
  roomId: _room,
);

void main() {
  group('callNextBlockFor', () {
    test('runs when the room is open and someone waits', () {
      expect(
        callNextBlockFor(
          day: DayState.open,
          roomState: RoomState.open,
          waiting: 2,
        ),
        isNull,
      );
    });

    test('a day that has not started yet opens with the first call', () {
      expect(
        callNextBlockFor(day: null, roomState: RoomState.open, waiting: 1),
        isNull,
      );
    });

    test('names the first reason in order: day, break, closed, empty', () {
      expect(
        callNextBlockFor(
          day: DayState.closed,
          roomState: RoomState.paused,
          waiting: 0,
        ),
        CallNextBlock.dayClosed,
      );
      expect(
        callNextBlockFor(
          day: DayState.open,
          roomState: RoomState.paused,
          waiting: 0,
        ),
        CallNextBlock.roomPaused,
      );
      expect(
        callNextBlockFor(
          day: DayState.open,
          roomState: RoomState.closed,
          waiting: 3,
        ),
        CallNextBlock.roomClosed,
      );
      expect(
        callNextBlockFor(
          day: DayState.open,
          roomState: RoomState.open,
          waiting: 0,
        ),
        CallNextBlock.noOneWaiting,
      );
    });
  });

  group('the desk board', () {
    test('counts the local mirror, not the server view', () {
      final board = _board(tickets: [_waiting('001'), _waiting('002')]);
      expect(board.roomLine!.waiting, hasLength(2));
      expect(board.callNextBlock, isNull);
    });

    test('a room break waiting to sync already blocks Call next', () {
      final board = _board(
        tickets: [_waiting('001')],
        pending: [
          SetRoomStateAction(
            actionId: _device,
            deviceId: _device,
            seq: 4,
            issuedAtLocal: _now,
            roomId: _room,
            state: RoomState.paused,
          ),
        ],
      );
      expect(board.room!.state, RoomState.paused);
      expect(board.callNextBlock, CallNextBlock.roomPaused);
    });

    test('a close day waiting to sync already reads as closed', () {
      final board = _board(
        tickets: [_waiting('001')],
        pending: [
          CloseDayAction(
            actionId: _device,
            deviceId: _device,
            seq: 5,
            issuedAtLocal: _now,
            clinicId: _clinic,
          ),
        ],
      );
      expect(board.day, DayState.closed);
      expect(board.callNextBlock, CallNextBlock.dayClosed);
    });

    test('an empty line blocks with No one is waiting', () {
      expect(_board().callNextBlock, CallNextBlock.noOneWaiting);
    });
  });

  group('CallNextButton', () {
    Future<void> pump(
      WidgetTester tester,
      CallNextBlock? block,
      VoidCallback onPressed,
    ) => tester.pumpWidget(
      MaterialApp(
        theme: docketTheme(Brightness.light),
        home: Scaffold(
          body: CallNextButton(block: block, onPressed: onPressed),
        ),
      ),
    );

    testWidgets('says Call next and calls when it can run', (tester) async {
      var calls = 0;
      await pump(tester, null, () => calls++);
      expect(find.text(DeskStrings.callNext), findsOneWidget);
      await tester.tap(find.byType(FilledButton));
      expect(calls, 1);
    });

    for (final (block, label) in [
      (CallNextBlock.roomPaused, 'Room on a break'),
      (CallNextBlock.noOneWaiting, 'No one is waiting'),
      (CallNextBlock.dayClosed, 'Day closed'),
      (CallNextBlock.roomClosed, 'Room closed'),
    ]) {
      testWidgets('is disabled and says "$label" for $block', (tester) async {
        var calls = 0;
        await pump(tester, block, () => calls++);
        expect(find.text(label), findsOneWidget);
        expect(find.text(DeskStrings.callNext), findsNothing);
        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
        await tester.tap(find.byType(FilledButton));
        expect(calls, 0);
      });
    }

    testWidgets('is the tallest control, at least 96 px', (tester) async {
      await pump(tester, null, () {});
      expect(
        tester.getSize(find.byType(FilledButton)).height,
        greaterThanOrEqualTo(CallNextButton.minHeight),
      );
    });
  });
}
