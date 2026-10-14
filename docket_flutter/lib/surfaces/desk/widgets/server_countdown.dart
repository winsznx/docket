import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/server_clock.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/theme/tokens.dart';

/// Minutes and seconds left until [end] in server time, in the mono face so
/// the digits never jitter, followed by [suffix].
class ServerCountdown extends StatefulWidget {
  const ServerCountdown({
    super.key,
    required this.end,
    required this.suffix,
    required this.color,
  });

  final DateTime end;
  final String suffix;
  final Color color;

  @override
  State<ServerCountdown> createState() => _ServerCountdownState();
}

class _ServerCountdownState extends State<ServerCountdown> {
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final left = ServerClock.mmss(
      ServerClock.instance.secondsUntil(widget.end),
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: left,
            style: text.headlineMedium?.copyWith(
              fontFamily: DocketType.mono,
              fontWeight: FontWeight.w500,
              fontFeatures: tabularFigures,
              color: widget.color,
            ),
          ),
          TextSpan(
            text: ' ${widget.suffix}',
            style: text.bodyLarge?.copyWith(color: widget.color),
          ),
        ],
      ),
    );
  }
}
