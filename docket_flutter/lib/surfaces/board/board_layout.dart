import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'board_logic.dart';

/// How long a called room stays flooded before it settles back to night.
const boardFlashLength = Duration(seconds: 4);

/// The board itself: rooms as columns, then recent calls, waiting counts
/// and the join QR along the bottom.
class BoardLayout extends StatelessWidget {
  const BoardLayout({
    super.key,
    required this.view,
    required this.flashes,
    this.isLocal = false,
    this.status,
    this.notice,
    this.onOpenSettings,
  });

  final BoardView view;

  /// A band along the bottom of the rooms, such as the first-load request
  /// for a tap. It sits in the room area so it never hides the join QR.
  final String? notice;

  /// Calls per room name since the board opened. A change floods the room.
  final Map<String, int> flashes;
  final bool isLocal;

  /// A quiet line under the clinic name, such as "Reconnecting".
  final String? status;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DocketColors.night,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final labels = [
            'C-000',
            for (final r in view.rooms) ?r.nowServingLabel,
          ];
          final metrics = BoardMetrics.of(
            constraints.biggest,
            view.rooms.length,
            (size) => _widest(labels, _labelStyle(size)),
          );
          return Center(
            child: SizedBox.fromSize(
              size: metrics.frame,
              child: _Board(
                view: view,
                metrics: metrics,
                flashes: flashes,
                isLocal: isLocal,
                status: status,
                notice: notice,
                onOpenSettings: onOpenSettings,
              ),
            ),
          );
        },
      ),
    );
  }

  static double _widest(List<String> labels, TextStyle style) {
    var widest = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    return widest;
  }
}

TextStyle _labelStyle(double size) => TextStyle(
  fontFamily: DocketType.sans,
  fontSize: size,
  fontWeight: DocketType.displayWeight,
  height: DocketType.displayLeading,
  letterSpacing: size * DocketType.displayTrackingEm,
  fontFeatures: tabularFigures,
  color: DocketColors.daylight,
);

TextStyle _text(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = DocketColors.daylight,
  double height = 1.2,
}) => TextStyle(
  fontFamily: DocketType.sans,
  fontSize: size,
  fontWeight: weight,
  height: height,
  color: color,
  fontFeatures: tabularFigures,
);

class _Board extends StatelessWidget {
  const _Board({
    required this.view,
    required this.metrics,
    required this.flashes,
    required this.isLocal,
    required this.status,
    required this.notice,
    required this.onOpenSettings,
  });

  final BoardView view;
  final BoardMetrics metrics;
  final Map<String, int> flashes;
  final bool isLocal;
  final String? status;
  final String? notice;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final u = metrics.unit;
    final notice = this.notice;
    return Padding(
      padding: EdgeInsets.only(top: metrics.top, bottom: metrics.footerGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: metrics.gutter),
            child: _Header(
              clinicName: view.clinicName,
              unit: u,
              isLocal: isLocal,
              status: status,
              onOpenSettings: onOpenSettings,
            ),
          ),
          SizedBox(height: metrics.headerGap),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: metrics.gutter - metrics.columnPadding,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _Rooms(rooms: view.rooms, metrics: metrics, flashes: flashes),
                  if (notice != null)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: metrics.columnPadding,
                        ),
                        child: ExcludeSemantics(
                          child: _Notice(text: notice, unit: u),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: metrics.footerGap),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: metrics.gutter),
            child: SizedBox(
              height: metrics.footerHeight,
              child: _Footer(view: view, unit: u, gap: metrics.columnGap * 2),
            ),
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.unit});

  final String text;
  final double unit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DocketColors.registerLift,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: unit * 3,
            vertical: unit * 2.2,
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.volume2,
                size: unit * 3.2,
                color: DocketColors.daylight,
              ),
              SizedBox(width: unit * 1.2),
              Expanded(
                child: Text(
                  text,
                  style: _text(unit * 3.2, weight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.clinicName,
    required this.unit,
    required this.isLocal,
    required this.status,
    required this.onOpenSettings,
  });

  final String clinicName;
  final double unit;
  final bool isLocal;
  final String? status;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final u = unit;
    final status = this.status;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: u * 3,
            runSpacing: u,
            children: [
              Semantics(
                header: true,
                child: Text(
                  clinicName,
                  style: _text(u * 3.4, weight: FontWeight.w700),
                ),
              ),
              if (isLocal)
                Semantics(
                  container: true,
                  label: BoardStrings.localMode,
                  hint: BoardStrings.localModeHint,
                  excludeSemantics: true,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: DocketColors.danfo,
                      shape: StadiumBorder(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: u * 1.6,
                        vertical: u * 0.6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.hardDrive,
                            size: u * 2.2,
                            color: DocketColors.register,
                          ),
                          SizedBox(width: u * 0.8),
                          Text(
                            BoardStrings.localMode,
                            style: _text(
                              u * 2.2,
                              weight: FontWeight.w700,
                              color: DocketColors.register,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (status != null)
                Semantics(
                  container: true,
                  liveRegion: true,
                  child: Text(
                    status,
                    style: _text(u * 2.2, color: DocketColors.nightSoft),
                  ),
                ),
            ],
          ),
        ),
        if (onOpenSettings != null)
          TextButton.icon(
            onPressed: onOpenSettings,
            style: TextButton.styleFrom(
              foregroundColor: DocketColors.nightSoft,
              iconColor: DocketColors.nightSoft,
              iconSize: u * 2,
              elevation: 0,
              textStyle: _text(u * 2, weight: FontWeight.w500),
            ),
            icon: const Icon(LucideIcons.settings),
            label: const Text(BoardStrings.settings),
          ),
      ],
    );
  }
}

class _Rooms extends StatelessWidget {
  const _Rooms({
    required this.rooms,
    required this.metrics,
    required this.flashes,
  });

  final List<BoardRoom> rooms;
  final BoardMetrics metrics;
  final Map<String, int> flashes;

  @override
  Widget build(BuildContext context) {
    final perRow = metrics.roomsPerRow;
    final rows = <List<BoardRoom>>[
      for (var i = 0; i < rooms.length; i += perRow)
        rooms.sublist(i, (i + perRow).clamp(0, rooms.length)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) SizedBox(height: metrics.rowGap),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var c = 0; c < perRow; c++) ...[
                  if (c > 0) SizedBox(width: metrics.columnGap),
                  Expanded(
                    child: c < rows[r].length
                        ? RoomColumn(
                            room: rows[r][c],
                            metrics: metrics,
                            flashCount: flashes[rows[r][c].roomName] ?? 0,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// One room: its name in nightSoft and the label it's calling in white. A
/// new call floods the column with danfo, which settles back to night over
/// four seconds.
class RoomColumn extends StatefulWidget {
  const RoomColumn({
    super.key,
    required this.room,
    required this.metrics,
    required this.flashCount,
  });

  final BoardRoom room;
  final BoardMetrics metrics;
  final int flashCount;

  @override
  State<RoomColumn> createState() => _RoomColumnState();
}

class _RoomColumnState extends State<RoomColumn>
    with SingleTickerProviderStateMixin {
  late final _flash = AnimationController(
    vsync: this,
    duration: boardFlashLength,
  );

  /// Full danfo for the first fifth, then an eased settle back to night.
  late final _settle = CurvedAnimation(
    parent: _flash,
    curve: const Interval(0.2, 1, curve: DocketMotion.curve),
  );

  @override
  void didUpdateWidget(RoomColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashCount > oldWidget.flashCount) _flash.forward(from: 0);
  }

  @override
  void dispose() {
    _settle.dispose();
    _flash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.metrics;
    final room = widget.room;
    final label = room.nowServingLabel;
    final idle = switch (room.state) {
      RoomState.paused => BoardStrings.onBreak,
      RoomState.closed => BoardStrings.closed,
      RoomState.open => label == null ? BoardStrings.open : null,
    };
    final semantics = idle == null
        ? BoardStrings.roomNowCalling(room.roomName, label!)
        : '${room.roomName}, $idle';

    return Semantics(
      container: true,
      label: semantics,
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _settle,
          builder: (context, _) {
            final flashing = _flash.isAnimating;
            final t = flashing ? _settle.value : 1.0;
            final field = Color.lerp(
              DocketColors.danfo,
              DocketColors.night,
              t,
            )!;
            final strong = Color.lerp(
              DocketColors.register,
              DocketColors.daylight,
              t,
            )!;
            final soft = Color.lerp(
              DocketColors.register,
              DocketColors.nightSoft,
              t,
            )!;
            return ColoredBox(
              color: field,
              child: Padding(
                padding: EdgeInsets.all(m.columnPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.roomName,
                      maxLines: m.rows > 1 ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: _text(
                        m.roomNameSize,
                        weight: FontWeight.w700,
                        color: soft,
                      ),
                    ),
                    SizedBox(height: m.nameGap),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topLeft,
                          child: idle == null
                              ? Text(
                                  label!,
                                  maxLines: 1,
                                  style: _labelStyle(
                                    m.labelSize,
                                  ).copyWith(color: strong),
                                )
                              : Text(
                                  idle,
                                  style: _text(
                                    m.roomNameSize,
                                    weight: FontWeight.w500,
                                    color: soft,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.view, required this.unit, required this.gap});

  final BoardView view;
  final double unit;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: _RecentCalls(calls: view.recentCalls, unit: unit),
        ),
        SizedBox(width: gap),
        Expanded(
          flex: 4,
          child: _Waiting(waiting: view.waitingByLine, unit: unit),
        ),
        SizedBox(width: gap),
        _JoinQr(joinUrl: view.joinUrl, unit: unit),
      ],
    );
  }
}

class _ListHeading extends StatelessWidget {
  const _ListHeading(this.text, this.unit);

  final String text;
  final double unit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: unit * 1.2),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: _text(unit * 2.4, color: DocketColors.nightSoft),
      ),
    ),
  );
}

class _RecentCalls extends StatelessWidget {
  const _RecentCalls({required this.calls, required this.unit});

  final List<BoardCall> calls;
  final double unit;

  @override
  Widget build(BuildContext context) {
    final u = unit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ListHeading(BoardStrings.recentCalls, u),
        if (calls.isEmpty)
          Semantics(
            container: true,
            child: Text(
              BoardStrings.noCallsYet,
              style: _text(u * 3, color: DocketColors.nightSoft),
            ),
          )
        else
          Expanded(
            child: ClipRect(
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  for (final call in calls.take(5))
                    TableRow(
                      children: [
                        Semantics(
                          label: BoardStrings.calledTo(
                            call.label,
                            call.roomName,
                          ),
                          child: ExcludeSemantics(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: u * 3,
                                bottom: u * 0.8,
                              ),
                              child: Text(
                                call.label,
                                style: _text(u * 3.4, weight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        ExcludeSemantics(
                          child: Text(
                            call.roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _text(
                              u * 3.4,
                              color: DocketColors.nightSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting({required this.waiting, required this.unit});

  final Map<String, int> waiting;
  final double unit;

  @override
  Widget build(BuildContext context) {
    final u = unit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ListHeading(BoardStrings.waiting, u),
        Expanded(
          child: ClipRect(
            child: Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                for (final MapEntry(key: line, value: count) in waiting.entries)
                  TableRow(
                    children: [
                      Semantics(
                        label: BoardStrings.waitingFor(count, line),
                        child: ExcludeSemantics(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: u * 3,
                              bottom: u * 0.8,
                            ),
                            child: Text(
                              line,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _text(
                                u * 3.4,
                                color: DocketColors.nightSoft,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ExcludeSemantics(
                        child: Text(
                          '$count',
                          style: _text(u * 3.4, weight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinQr extends StatelessWidget {
  const _JoinQr({required this.joinUrl, required this.unit});

  final String joinUrl;
  final double unit;

  @override
  Widget build(BuildContext context) {
    final u = unit;
    return LayoutBuilder(
      builder: (context, constraints) {
        final caption = _text(
          u * 2.2,
          weight: FontWeight.w700,
          color: DocketColors.register,
        );
        const captionLines = 2;
        final captionHeight = captionLines * u * 2.2 * 1.2;
        // Text heights round up to whole pixels, so leave a little room.
        const rounding = 4;
        final qrSize =
            (constraints.maxHeight - u * 2 * 2 - u - captionHeight - rounding)
                .floorToDouble();
        return ColoredBox(
          color: DocketColors.daylight,
          child: Padding(
            padding: EdgeInsets.all(u * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  image: true,
                  label: BoardStrings.joinQr,
                  child: QrImageView(
                    data: joinUrl,
                    size: qrSize,
                    padding: EdgeInsets.zero,
                    backgroundColor: DocketColors.daylight,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: DocketColors.night,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: DocketColors.night,
                    ),
                  ),
                ),
                SizedBox(height: u),
                Semantics(
                  container: true,
                  child: SizedBox(
                    width: qrSize,
                    child: Text(
                      BoardStrings.scanToJoin,
                      maxLines: captionLines,
                      style: caption,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The loading state: night, with a calm progress line where the clinic
/// name will be.
class BoardLoading extends StatelessWidget {
  const BoardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DocketColors.night,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metrics = BoardMetrics.of(constraints.biggest, 1, (_) => 0);
          return Center(
            child: SizedBox.fromSize(
              size: metrics.frame,
              child: Padding(
                padding: EdgeInsets.all(metrics.gutter),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: DocketProgressLine(
                    color: DocketColors.nightSoft,
                    semanticsLabel: BoardStrings.loading,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A board link that no longer works, with the server's own words.
class BoardMessage extends StatelessWidget {
  const BoardMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DocketColors.night,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metrics = BoardMetrics.of(constraints.biggest, 1, (_) => 0);
          final u = metrics.unit;
          return Center(
            child: SizedBox.fromSize(
              size: metrics.frame,
              child: Padding(
                padding: EdgeInsets.all(metrics.gutter),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: u * 110),
                    child: Semantics(
                      container: true,
                      liveRegion: true,
                      child: Text(
                        message,
                        style: _text(
                          u * 5,
                          weight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
