import 'package:flutter/material.dart';

class TextIndicator extends StatelessWidget {
  const TextIndicator();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'ENTER\nPASSCODE',
        style: TextStyle(
          fontFamily: 'Rubik',
          fontSize: 32.0,
        ),
      ),
    );
  }
}
