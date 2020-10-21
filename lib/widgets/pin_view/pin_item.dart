import 'package:flutter/material.dart';

class PinItem extends StatelessWidget {
  final int digit;
  final double size;
  final double animPercent;
  final Color color;
  final Color activeColor;
  final Duration duration;

  const PinItem({
    Key key,
    @required this.digit,
    @required this.animPercent,
    this.size = 20.0,
    this.color = Colors.black,
    this.activeColor = Colors.white,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _dot(
      size: size,
      color: color,
      child: _dot(
        size: size * 0.5 * animPercent,
        color: activeColor,
      ),
    );
  }

  Widget _dot({
    @required double size,
    @required Color color,
    Widget child,
  }) {
    return AnimatedContainer(
      duration: duration,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
