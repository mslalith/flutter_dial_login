import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_dial_login/widgets/dialer/dialer_painter.dart';
import 'package:flutter_dial_login/widgets/mobile_view.dart';
import 'package:flutter_dial_login/widgets/radial_gesture_detector.dart';

class Dialer extends StatefulWidget {
  final Function(int) onDigitSelected;
  const Dialer({
    Key key,
    @required this.onDigitSelected,
  }) : super(key: key);

  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer> with SingleTickerProviderStateMixin {
  static final double sweepAngle = 270.0;
  static final double maxSweepAngle = 330.0;
  AnimationController rotationController;
  Offset center = Offset.zero;
  double radius = 0.0;
  double numberCircleRadius = 0.0;
  double degreeSpace = 0.0;
  double spacing = 0.0;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      radius = MobileView.dimensions(context).width * 0.3;
      numberCircleRadius = radius * 0.6 * 0.8 * 0.4;
      center = context.size.center(Offset.zero);

      degreeSpace = 2 * pi * radius / 360.0;
      final totalSweepSpace = degreeSpace * sweepAngle;
      final totalSpacing = totalSweepSpace - (numberCircleRadius * 2 * 10);
      spacing = totalSpacing / 9;
      setState(() {});
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: AnimatedBuilder(
            animation: rotationController,
            builder: (context, child) {
              return RadialGestureDetector(
                onRadiaDragUpdate: _onRadialDragUpdate,
                onRadialDragEnd: _onRadialDragEnd,
                center: center,
                maxSweepAngle: maxSweepAngle,
                child: CustomPaint(
                  painter: DialerPainter(
                    radius: radius,
                    numberCircleRadius: numberCircleRadius,
                    rotation: rotationController.value,
                    sweepAngle: -sweepAngle.radians,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onRadialDragUpdate(double angle) =>
      rotationController.value = angle / 360.0;

  void _onRadialDragEnd() {
    final value = rotationController.value / (330.0 / 360.0);
    final sweepSpace = degreeSpace * (value * 300.0);
    final digitPercent = sweepSpace / ((numberCircleRadius * 2) + spacing);
    final digit = digitPercent.round() - 1;

    if (!digit.isNegative) {
      if (digitPercent > 0.6 && digit == 10) {
        widget.onDigitSelected(0);
      } else {
        widget.onDigitSelected(digit);
      }
    }

    rotationController.animateBack(
      0.0,
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 1500),
    );
  }
}
