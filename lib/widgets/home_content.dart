import 'package:flutter/material.dart';
import 'package:flutter_dial_login/widgets/dialer/dialer.dart';
import 'package:flutter_dial_login/widgets/pin_view/pin_view.dart';
import 'package:flutter_dial_login/widgets/text_indicator.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  ValueNotifier<String> pinNotifier;

  @override
  void initState() {
    super.initState();
    pinNotifier = ValueNotifier('');
  }

  @override
  void dispose() {
    pinNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TextIndicator(),
        ValueListenableBuilder<String>(
          valueListenable: pinNotifier,
          builder: (context, pin, child) => PinView(
            pin: pin,
            resetPin: () => pinNotifier.value = '',
          ),
        ),
        Dialer(
          onDigitSelected: (int digit) {
            final currentPin = pinNotifier.value;
            if (currentPin.length < 4) {
              pinNotifier.value = '$currentPin$digit';
            }
          },
        )
      ],
    );
  }
}
