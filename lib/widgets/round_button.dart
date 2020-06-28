import 'package:flutter/material.dart';

// Round button used for SOS and Safe buttons in the home screen
class RoundButton extends StatelessWidget {
  RoundButton({
    @required this.onPress,
    @required this.buttonChild,
    @required this.color,
  });

  final Function onPress;
  final Widget buttonChild;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      child: buttonChild,
      fillColor: color,
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(
        width: 170.0,
        height: 170.0,
      ),
      elevation: 7.0,
    );
  }
}
