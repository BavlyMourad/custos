import 'package:flutter/material.dart';
import 'package:custos/utilities/constants.dart';

// The content of the round button in the home screen
class ButtonContent extends StatelessWidget {
  ButtonContent({@required this.status, @required this.icon});

  final String status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          status,
          style: kStatusTextStyle,
        ),
        Icon(
          icon,
          size: 40.0,
          color: Colors.white,
        ),
      ],
    );
  }
}
