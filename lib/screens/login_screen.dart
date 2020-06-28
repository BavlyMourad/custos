import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/form_button.dart';
import 'package:custos/screens/forgot_password_screen.dart';
import 'package:custos/screens/register_screen.dart';
import 'package:custos/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  bool isHidden = true;

  bool walkedThrough = false;

  String _email;
  String _password;

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

  void _login() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      _formKey.currentState.save();
      try {
        prefs = await SharedPreferences.getInstance();

        setState(() {
          walkedThrough = prefs.getBool('walkedThrough');
        });

	// If the user reinstalled the app we reset these values to dodge errors
        if(walkedThrough == null) {
          // Set walkedThrough boolean to true because he is not a new user
          prefs.setBool('walkedThrough', true);

          // Set the safeButtonEnabled to false so when the user reinstall the app, it highlights the SOS button instead of the Safe button
          prefs.setBool('safeButtonEnabled', false);

          // Reset user's image
          prefs.setString('image', null);

          // Set default values for settings screen
          prefs.setBool('sosSmsPrimary', true);
          prefs.setBool('sosSmsOthers', true);
          prefs.setBool('sosCall', true);
          prefs.setBool('sendLocation', true);
          prefs.setBool('sendUpdatedLocation', true);
          prefs.setInt('updatedLocationTimer', 10);
          prefs.setBool('safeSmsPrimary', true);
          prefs.setBool('safeSmsOthers', true);
        }

        // Save the user's password to use it in a condition when he clicks on the safe button to check if he is the real user
        prefs.setString('password', _password);

        await _auth.signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
      on PlatformException catch(e) {
        setState(() {
          showSpinner = false;
        });

        // Exception message for no internet connection
        if(e.message == 'An internal error has occurred. [ 7: ]' || e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          _showSnackBar('Internet connection is required to login!', Color(0xFFf55255));
        }
        else {
          _showSnackBar(e.message, Color(0xFFf55255));
        }
      }
    }
  }

  // Changes the value of the obscure text for password fields
  void passVisibility() {
    setState(() {
      if(isHidden) {
        isHidden = false;
      }
      else {
        isHidden = true;
      }
    });
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
                          TextFormField(
                            validator: (value) {
                              if(value.length < 6) {
                                return 'Password should be 6 characters or more';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                            decoration: kTextFormFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: passVisibility,
                                icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                              ),
                              hintText: 'Password',
                              enabledBorder: kAuthFieldDecoration,
                            ),
                            obscureText: isHidden,
                            style: kTextFieldValueDecoration,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          FormButton(
                            status: 'Login',
                            onPress: _login,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.id),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Don\'t have an account yet?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, RegisterScreen.id);
                                },
                                child: Text(
                                  ' Register',
                                  style: TextStyle(
                                    color: Color(0xFF95c8d8),
                                  ),
                                ),
                              ),
                            ],
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

