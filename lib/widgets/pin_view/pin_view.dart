import 'package:flutter/material.dart';
import 'package:flutter_dial_login/widgets/pin_view/pin_item.dart';

class PinView extends StatefulWidget {
  final String pin;
  final VoidCallback resetPin;

  const PinView({
    Key key,
    @required this.pin,
    @required this.resetPin,
  }) : super(key: key);

  @override
  _PinViewState createState() => _PinViewState();
}

class _PinViewState extends State<PinView> with TickerProviderStateMixin {
  static const SECRET_PIN = '1231';
  List<AnimationController> sizeControllers;
  List<Color> pinActiveColors;
  bool isPinValid;

  @override
  void initState() {
    super.initState();
    sizeControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      )..addListener(() => setState(() {})),
    );
    resetPinActiveColors();
  }

  @override
  void dispose() {
    sizeControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PinView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final length = widget.pin.length;
    switch (length) {
      case 1:
        sizeControllers[0].forward(from: 0.0);
        break;
      case 2:
        sizeControllers[1].forward(from: 0.0);
        break;
      case 3:
        sizeControllers[2].forward(from: 0.0);
        break;
      case 4:
        sizeControllers[3].forward(from: 0.0).then((_) async {
          // you can call your own implemented validation method
          // or await a response from server
          isPinValid = widget.pin == SECRET_PIN;

          await Future.delayed(const Duration(milliseconds: 1000));
          for (int i = 0; i < pinActiveColors.length; i++) {
            Future.delayed(
              Duration(milliseconds: i * 80),
              () => setState(() => pinActiveColors[i] = _activePinColor),
            );
          }

          await Future.delayed(const Duration(milliseconds: 2000));
          for (int i = 0; i < sizeControllers.length; i++) {
            Future.delayed(
              Duration(milliseconds: i * 80),
              () => sizeControllers[i].reverse(from: 1.0),
            );
          }
          widget.resetPin();
          resetPinActiveColors();
          isPinValid = null;
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = 4 - widget.pin.length;
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < widget.pin.length; i++) ...[
            if (i != 0) const SizedBox(width: 4.0),
            PinItem(
              digit: int.parse(widget.pin[i]),
              activeColor: pinActiveColors[i],
              animPercent: sizeControllers[i].value,
            ),
          ],
          if (widget.pin.length != 4) const SizedBox(width: 4.0),
          for (int i = 0; i < remaining; i++) ...[
            if (i != 0) const SizedBox(width: 4.0),
            PinItem(
              digit: -1,
              animPercent: 0.0,
            ),
          ],
        ],
      ),
    );
  }

  Color get _activePinColor {
    if (isPinValid == null) return Colors.white;
    return isPinValid ? Colors.green : Colors.red;
  }

  void resetPinActiveColors() {
    pinActiveColors = List.generate(
      4,
      (i) => Colors.white,
    );
  }
}
