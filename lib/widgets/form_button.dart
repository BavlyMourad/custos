import 'package:flutter/material.dart';

// The button which is used in submitting a form like sign in, sign up, update
class FormButton extends StatelessWidget {
  FormButton({@required this.status, @required this.onPress});

  final String status;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      child: RaisedButton(
        color: Color(0xFF4682B4),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Text(
          status,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        onPressed: onPress,
      ),
    );
  }
}
