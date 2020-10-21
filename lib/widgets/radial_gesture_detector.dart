import 'dart:math' show atan2, min, pi;

import 'package:flutter/material.dart';

class RadialGestureDetector extends StatefulWidget {
  final VoidCallback onRadialDragStart;
  final ValueChanged<double> onRadiaDragUpdate;
  final VoidCallback onRadialDragEnd;
  final Widget child;
  final double maxSweepAngle;
  final Offset center;
  final bool stopAtFullSwipe;

  const RadialGestureDetector({
    Key key,
    @required this.child,
    @required this.onRadiaDragUpdate,
    this.onRadialDragStart,
    this.onRadialDragEnd,
    this.maxSweepAngle,
    this.center = Offset.zero,
    this.stopAtFullSwipe = true,
  }) : super(key: key);

  @override
  _RadialGestureDetectorState createState() => _RadialGestureDetectorState();
}

class _RadialGestureDetectorState extends State<RadialGestureDetector> {
  double dragStartAngleInDegrees = 0.0;
  double dragPreviousAngleInDegrees = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    final dragStart = details.localPosition - widget.center;
    final angleInRadians = atan2(dragStart.dy, dragStart.dx);
    dragStartAngleInDegrees = angleInRadians.degrees + 90.0;
    widget.onRadialDragStart?.call();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragUpdate = details.localPosition;
    final dragDelta = dragUpdate - widget.center;
    final angleInRadians = atan2(dragDelta.dy, dragDelta.dx);
    double angleInDegrees =
        angleInRadians.degrees + 90.0 - dragStartAngleInDegrees;
    if (angleInDegrees.isNegative) angleInDegrees += 360.0;
    
    final changeInDegrees = dragPreviousAngleInDegrees - angleInDegrees;
    if (widget.stopAtFullSwipe && changeInDegrees > 0.0) return;

    dragPreviousAngleInDegrees = angleInDegrees;
    if (widget.maxSweepAngle != null)
      angleInDegrees = min(angleInDegrees, widget.maxSweepAngle);
    widget.onRadiaDragUpdate(angleInDegrees);
  }

  void _onPanEnd(DragEndDetails details) {
    dragStartAngleInDegrees = 0.0;
    dragPreviousAngleInDegrees = 0.0;
    widget.onRadialDragEnd?.call();
  }
}

extension AngleX on double {
  double get degrees => (this * 180.0) / pi;
  double get radians => (this * pi) / 180.0;
}
