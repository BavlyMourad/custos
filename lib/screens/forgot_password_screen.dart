import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/form_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'ForgotPasswordScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  String _email;

  void _showSnackBar(String message, Color color) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: Duration(
              seconds: 7
          ),
        )
    );
  }

  void resetPassword() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      _formKey.currentState.save();
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        setState(() {
          showSpinner = false;
        });
        _showSnackBar('Check your E-mail address to reset your password.', Colors.green);
      }
      on PlatformException catch(e) {
        setState(() {
          showSpinner = false;
        });
        if(e.message == 'An internal error has occurred. [ 7: ]' || e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          _showSnackBar('Internet connection is required to reset your password!', Color(0xFFf55255));
        }
        else {
          _showSnackBar(e.message, Color(0xFFf55255));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF4682B4),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xFF0E4C92),
                  Color(0xFF4682B4),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Color(0xFF4682B4), // Activated icons color
                      errorColor: Color(0xFFB80F0A), //EC8781
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Custos',
                                style: kAppTitleTextStyle,
                              ),
                              SizedBox(width: 15.0),
                              Image.asset(
                                'assets/logo.png',
                                width: 50.0,
                                height: 50.0,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.07),
                          TextFormField(
                            validator: (value) {
                              if(value.isEmpty) {
                                return 'Email shouldn\'t be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value;
                            },
                            decoration: kTextFormFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.mail),
                              hintText: 'Email',
                              enabledBorder: kAuthFieldDecoration,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: kTextFieldValueDecoration,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          FormButton(
                            status: 'Reset Password',
                            onPress: resetPassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}