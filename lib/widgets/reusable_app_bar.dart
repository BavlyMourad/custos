import 'package:flutter/material.dart';

class ReusableAppBar extends AppBar {
  ReusableAppBar({Key key, Widget title})
      : super(
          // Passing the key, title, centerTitle, backgroundColor, actions to the super class(AppBar)
          key: key,
          title: title,
          centerTitle: true,
          backgroundColor: Color(0xFF4682B4),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/logo.png',
                  height: 33.0,
                  width: 33.0,
                ),
              ),
            ),
          ],
        );
}
