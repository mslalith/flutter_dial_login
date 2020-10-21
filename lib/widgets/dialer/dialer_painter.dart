import 'dart:math' show cos, pi, sin;

import 'package:flutter/material.dart';

class DialerPainter extends CustomPainter {
  final double radius;
  final double rotation;
  final double numberCircleRadius;
  final double sweepAngle;
  final double outerDialThickness;
  final double innerDialThickness;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color numbersColor;
  TextPainter numberPainter;
  TextStyle numberStyle;
  Paint backgroundPaint;
  Paint foregroundPaint;
  Paint dialPaint;

  DialerPainter({
    @required this.radius,
    @required this.numberCircleRadius,
    @required this.rotation,
    @required this.sweepAngle,
    double outerDialThickness,
    double innerDialThickness,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.numbersColor = Colors.white,
  })  : this.outerDialThickness = outerDialThickness ?? radius * 0.6,
        this.innerDialThickness = innerDialThickness ?? radius * 0.6 * 0.8,
        dialPaint = Paint()..color = numbersColor,
        foregroundPaint = Paint()
          ..color = foregroundColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        backgroundPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke,
        numberPainter = TextPainter(
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
        numberStyle = TextStyle(
          color: numbersColor,
          fontFamily: 'Rubik',
          fontSize: 20.0,
        );

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    backgroundPaint.strokeWidth = outerDialThickness;
    foregroundPaint.strokeWidth = innerDialThickness;

    _drawOuterDial(canvas, center, radius);
    _drawInnerDial(canvas, center, radius, numberCircleRadius);
    _drawNumbers(canvas, center, radius, outerDialThickness);
  }

  void _drawOuterDial(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );
  }

  void _drawInnerDial(
    Canvas canvas,
    Offset center,
    double radius,
    double numberCircleRadius,
  ) {
    final startAngle = -(pi / 6) + (2 * pi * rotation);
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    backgroundPaint.style = PaintingStyle.fill;
    for (int i = 0; i < 10; ++i) {
      _drawCircle(
        canvas,
        startAngle,
        radius,
        numberCircleRadius,
        backgroundPaint,
      );
      canvas.rotate(-(2 * pi) / 12);
    }
    backgroundPaint.style = PaintingStyle.stroke;

    canvas.restore();
  }

  void _drawNumbers(
    Canvas canvas,
    Offset center,
    double radius,
    double thickness,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    for (int i = 0; i < 12; ++i) {
      if (i == 11) continue;

      final angle = -(pi / 6) - (2 * pi / 12) * i;
      if (i == 10) {
        _drawCircle(
          canvas,
          angle,
          radius,
          thickness * 0.2,
          dialPaint,
        );
        continue;
      }

      _drawNumber(
        canvas,
        numberPainter,
        angle,
        radius,
        i == 9 ? 0 : i + 1,
      );
    }
    canvas.restore();
  }

  void _drawCircle(
    Canvas canvas,
    double angle,
    double radius,
    double circleRadius,
    Paint paint,
  ) {
    final numberOffset = _numberOffsetFromAngleAndRadius(
      angle,
      radius,
    );
    canvas.drawCircle(
      numberOffset,
      circleRadius,
      paint,
    );
  }

  void _drawNumber(
    Canvas canvas,
    TextPainter numberPainter,
    double angle,
    double radius,
    int number,
  ) {
    numberPainter.text = TextSpan(
      text: '$number',
      style: numberStyle,
    );
    numberPainter.layout();
    final numberOffset = _numberOffsetFromAngleAndRadius(
      angle,
      radius,
    );
    numberPainter.paint(
      canvas,
      Offset(
        numberOffset.dx - (numberPainter.width * 0.5),
        numberOffset.dy - (numberPainter.height * 0.5),
      ),
    );
  }

  Offset _numberOffsetFromAngleAndRadius(double angle, double radius) {
    return Offset(
      radius * cos(angle),
      radius * sin(angle),
    );
  }

  @override
  bool shouldRepaint(DialerPainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.rotation != rotation;
}
