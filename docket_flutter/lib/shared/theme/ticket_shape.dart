import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'tokens.dart';

/// The ticket: rounded corners, a semicircle notch on each side at the tear
/// line, and a row of perforation dots between the notches.
///
/// The notches are cut out of the outline. The dots are drawn by [paint], so
/// they sit on the ticket's field.
class TicketShapeBorder extends ShapeBorder {
  const TicketShapeBorder({
    required this.tearFraction,
    required this.perforationColor,
    this.radius = DocketRadius.ticket,
    this.notchRadius = DocketRadius.notch,
  }) : assert(tearFraction > 0 && tearFraction < 1);

  /// Where the tear line sits, as a fraction of the height from the top.
  final double tearFraction;
  final Color perforationColor;
  final double radius;
  final double notchRadius;

  static const double perforationDotDiameter = DocketSpace.s4;
  static const double perforationPitch = DocketSpace.s12;
  static const double perforationInset = DocketSpace.s8;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final g = _TicketGeometry(rect, this);
    final corner = Radius.circular(g.corner);
    final notch = Radius.circular(g.notch);

    return Path()
      ..moveTo(rect.left + g.corner, rect.top)
      ..lineTo(rect.right - g.corner, rect.top)
      ..arcToPoint(Offset(rect.right, rect.top + g.corner), radius: corner)
      ..lineTo(rect.right, g.tearY - g.notch)
      ..arcToPoint(
        Offset(rect.right, g.tearY + g.notch),
        radius: notch,
        clockwise: false,
      )
      ..lineTo(rect.right, rect.bottom - g.corner)
      ..arcToPoint(Offset(rect.right - g.corner, rect.bottom), radius: corner)
      ..lineTo(rect.left + g.corner, rect.bottom)
      ..arcToPoint(Offset(rect.left, rect.bottom - g.corner), radius: corner)
      ..lineTo(rect.left, g.tearY + g.notch)
      ..arcToPoint(
        Offset(rect.left, g.tearY - g.notch),
        radius: notch,
        clockwise: false,
      )
      ..lineTo(rect.left, rect.top + g.corner)
      ..arcToPoint(Offset(rect.left + g.corner, rect.top), radius: corner)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final g = _TicketGeometry(rect, this);
    const dotRadius = perforationDotDiameter / 2;
    final start = rect.left + g.notch + perforationInset + dotRadius;
    final end = rect.right - g.notch - perforationInset - dotRadius;
    if (end < start) return;

    final count = ((end - start) / perforationPitch).floor() + 1;
    final first = start + (end - start - (count - 1) * perforationPitch) / 2;
    final dot = Paint()..color = perforationColor;
    for (var i = 0; i < count; i++) {
      canvas.drawCircle(
        Offset(first + i * perforationPitch, g.tearY),
        dotRadius,
        dot,
      );
    }
  }

  @override
  ShapeBorder scale(double t) => TicketShapeBorder(
    tearFraction: tearFraction,
    perforationColor: perforationColor,
    radius: radius * t,
    notchRadius: notchRadius * t,
  );

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => a is TicketShapeBorder
      ? TicketShapeBorder._lerp(a, this, t)
      : super.lerpFrom(a, t);

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => b is TicketShapeBorder
      ? TicketShapeBorder._lerp(this, b, t)
      : super.lerpTo(b, t);

  static TicketShapeBorder _lerp(
    TicketShapeBorder a,
    TicketShapeBorder b,
    double t,
  ) => TicketShapeBorder(
    tearFraction: lerpDouble(a.tearFraction, b.tearFraction, t)!,
    perforationColor: Color.lerp(a.perforationColor, b.perforationColor, t)!,
    radius: lerpDouble(a.radius, b.radius, t)!,
    notchRadius: lerpDouble(a.notchRadius, b.notchRadius, t)!,
  );

  @override
  bool operator ==(Object other) =>
      other is TicketShapeBorder &&
      other.tearFraction == tearFraction &&
      other.perforationColor == perforationColor &&
      other.radius == radius &&
      other.notchRadius == notchRadius;

  @override
  int get hashCode =>
      Object.hash(tearFraction, perforationColor, radius, notchRadius);

  @override
  String toString() =>
      'TicketShapeBorder(tearFraction: $tearFraction, radius: $radius, '
      'notchRadius: $notchRadius)';
}

/// Corner and notch sizes that fit the rect, and the tear line's position.
/// Small rects shrink the corners first, so the notch always stays round.
final class _TicketGeometry {
  factory _TicketGeometry(Rect rect, TicketShapeBorder shape) {
    final notch = math.min(shape.notchRadius, rect.shortestSide / 4);
    final corner = math.min(
      shape.radius,
      math.min(rect.width / 2, math.max(0.0, rect.height / 2 - notch)),
    );
    final highest = rect.top + corner + notch;
    final lowest = rect.bottom - corner - notch;
    final tearY = math.min(
      math.max(rect.top + rect.height * shape.tearFraction, highest),
      math.max(highest, lowest),
    );
    return _TicketGeometry._(corner: corner, notch: notch, tearY: tearY);
  }

  const _TicketGeometry._({
    required this.corner,
    required this.notch,
    required this.tearY,
  });

  final double corner;
  final double notch;
  final double tearY;
}

/// A ticket with [top] above the tear line and [bottom] below it.
///
/// The ticket carries the one shadow in the app. When [color] changes, the
/// field cross-fades over [DocketMotion.ticket], or switches at once when the
/// platform asks for reduced motion. A translucent [color], such as a stale
/// ticket's field at 60%, is mixed with the page so the shadow doesn't show
/// through the paper.
///
/// With a bounded height the ticket fills it. Otherwise it takes the smallest
/// height that keeps the tear at [tearFraction] with both halves fitting.
class DocketTicket extends StatelessWidget {
  const DocketTicket({
    super.key,
    required this.top,
    required this.bottom,
    required this.color,
    required this.tearFraction,
    this.radius = DocketRadius.ticket,
  }) : assert(tearFraction > 0 && tearFraction < 1);

  final Widget top;
  final Widget bottom;
  final Color color;
  final double tearFraction;
  final double radius;

  /// The perforation shows the page through the paper, darkened by the
  /// ticket's own shadow.
  static Color perforationColorOn(Color page) =>
      Color.alphaBlend(DocketShadows.ticket.last.color, page);

  @override
  Widget build(BuildContext context) {
    final page = Theme.of(context).scaffoldBackgroundColor;
    final shape = TicketShapeBorder(
      tearFraction: tearFraction,
      radius: radius,
      perforationColor: perforationColorOn(page),
    );

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: Color.alphaBlend(color, page)),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : DocketMotion.ticket,
      curve: DocketMotion.curve,
      builder: (context, field, child) => DecoratedBox(
        decoration: ShapeDecoration(
          color: field,
          shape: shape,
          shadows: DocketShadows.ticket,
        ),
        child: child,
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(shape: shape),
        child: _TicketLayout(
          top: top,
          bottom: bottom,
          tearFraction: tearFraction,
        ),
      ),
    );
  }
}

enum _TicketSlot { top, bottom }

class _TicketLayout
    extends SlottedMultiChildRenderObjectWidget<_TicketSlot, RenderBox> {
  const _TicketLayout({
    required this.top,
    required this.bottom,
    required this.tearFraction,
  });

  final Widget top;
  final Widget bottom;
  final double tearFraction;

  @override
  Iterable<_TicketSlot> get slots => _TicketSlot.values;

  @override
  Widget childForSlot(_TicketSlot slot) => switch (slot) {
    _TicketSlot.top => top,
    _TicketSlot.bottom => bottom,
  };

  @override
  _RenderTicketLayout createRenderObject(BuildContext context) =>
      _RenderTicketLayout(tearFraction);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTicketLayout renderObject,
  ) {
    renderObject.tearFraction = tearFraction;
  }
}

class _RenderTicketLayout extends RenderBox
    with SlottedContainerRenderObjectMixin<_TicketSlot, RenderBox> {
  _RenderTicketLayout(this._tearFraction);

  double _tearFraction;
  double get tearFraction => _tearFraction;
  set tearFraction(double value) {
    if (value == _tearFraction) return;
    _tearFraction = value;
    markNeedsLayout();
  }

  RenderBox get _top => childForSlot(_TicketSlot.top)!;
  RenderBox get _bottom => childForSlot(_TicketSlot.bottom)!;

  double _heightFor(double topHeight, double bottomHeight) => math.max(
    topHeight / _tearFraction,
    bottomHeight / (1 - _tearFraction),
  );

  @override
  double computeMinIntrinsicWidth(double height) => math.max(
    _top.getMinIntrinsicWidth(height * _tearFraction),
    _bottom.getMinIntrinsicWidth(height * (1 - _tearFraction)),
  );

  @override
  double computeMaxIntrinsicWidth(double height) => math.max(
    _top.getMaxIntrinsicWidth(height * _tearFraction),
    _bottom.getMaxIntrinsicWidth(height * (1 - _tearFraction)),
  );

  @override
  double computeMinIntrinsicHeight(double width) => _heightFor(
    _top.getMinIntrinsicHeight(width),
    _bottom.getMinIntrinsicHeight(width),
  );

  @override
  double computeMaxIntrinsicHeight(double width) => _heightFor(
    _top.getMaxIntrinsicHeight(width),
    _bottom.getMaxIntrinsicHeight(width),
  );

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final width = _widthFor(constraints, (child, c) => child.getDryLayout(c));
    if (constraints.hasBoundedHeight) {
      return constraints.constrain(Size(width, constraints.maxHeight));
    }
    final halves = BoxConstraints.tightFor(width: width);
    return constraints.constrain(
      Size(
        width,
        _heightFor(
          _top.getDryLayout(halves).height,
          _bottom.getDryLayout(halves).height,
        ),
      ),
    );
  }

  @override
  void performLayout() {
    final width = _widthFor(constraints, (child, c) {
      child.layout(c, parentUsesSize: true);
      return child.size;
    });

    final double height;
    if (constraints.hasBoundedHeight) {
      height = constraints.maxHeight;
    } else {
      final halves = BoxConstraints.tightFor(width: width);
      _top.layout(halves, parentUsesSize: true);
      _bottom.layout(halves, parentUsesSize: true);
      height = _heightFor(_top.size.height, _bottom.size.height);
    }
    size = constraints.constrain(Size(width, height));

    final topHeight = size.height * _tearFraction;
    _top.layout(
      BoxConstraints.tight(Size(size.width, topHeight)),
      parentUsesSize: true,
    );
    _bottom.layout(
      BoxConstraints.tight(Size(size.width, size.height - topHeight)),
      parentUsesSize: true,
    );
    (_top.parentData! as BoxParentData).offset = Offset.zero;
    (_bottom.parentData! as BoxParentData).offset = Offset(0, topHeight);
  }

  /// The full width when it's bounded, otherwise the wider half's own width.
  double _widthFor(
    BoxConstraints constraints,
    Size Function(RenderBox child, BoxConstraints constraints) measure,
  ) {
    if (constraints.hasBoundedWidth) return constraints.maxWidth;
    final loose = BoxConstraints(minWidth: constraints.minWidth);
    return math.max(
      measure(_top, loose).width,
      measure(_bottom, loose).width,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      context.paintChild(
        child,
        offset + (child.parentData! as BoxParentData).offset,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in children) {
      final childOffset = (child.parentData! as BoxParentData).offset;
      final hit = result.addWithPaintOffset(
        offset: childOffset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      );
      if (hit) return true;
    }
    return false;
  }
}
