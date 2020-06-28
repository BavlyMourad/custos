import 'package:custos/utilities/constants.dart';
import 'package:flutter/material.dart';

// Customised List Tile consists of icon and title for drawer navigation list
class TextIcon extends StatelessWidget {
  TextIcon({
    @required this.onPress,
    @required this.title,
    @required this.icon,
  });

  final Function onPress;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        onTap: onPress,
        title: Align(
          child: Text(
            title,
            style: kNavLabelTextStyle,
          ),
          alignment: Alignment(-1.25, 0),
          heightFactor: 0.0,
        ),
        leading: icon,
      ),
    );
  }
}
