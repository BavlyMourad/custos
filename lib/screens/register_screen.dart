import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/form_button.dart';
import 'package:custos/screens/login_screen.dart';
import 'package:custos/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();

  SharedPreferences prefs;

  final _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  bool showSpinner = false;

  bool isHidden = true;

  String _email;
  String _name;
  String _confirmPassword;
  String _phoneNumber;

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

  void register() async {
    if(_formKey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      _formKey.currentState.save();
      try {
        // Create email and password for the user
        await _auth.createUserWithEmailAndPassword(email: _email, password: _confirmPassword);

        prefs = await SharedPreferences.getInstance();

        // Set walkedThrough boolean to false because it's a new user
        prefs.setBool('walkedThrough', false);

        // Set the safeButtonEnabled to true so when another user registers it highlights the SOS button instead of the Safe button
        prefs.setBool('safeButtonEnabled', false);

        // Save the user's password to use it in a condition when he clicks on the safe button to check if he is the real user
        prefs.setString('password', _confirmPassword);

        // Reset user's image
        prefs.setString('image', null);

        // Reset the primary contact number for the new user
        prefs.setString('primaryContact', '');

        // Set default values for settings screen
        prefs.setBool('sosSmsPrimary', true);
        prefs.setBool('sosSmsOthers', true);
        prefs.setBool('sosCall', true);
        prefs.setBool('sendLocation', true);
        prefs.setBool('sendUpdatedLocation', true);
        prefs.setInt('updatedLocationTimer', 10);
        prefs.setBool('safeSmsPrimary', true);
        prefs.setBool('safeSmsOthers', true);

        // Save the email, name and the phone of the user in the database
        _firestore.collection('users').add({
          'Email': _email,
          'Name': _name,
          'Phone': _phoneNumber,
        });

        // Save empty contacts for the user in the database so he can update it later
        _firestore.collection('contacts').add({
          'Email': _email,
          'FirstName': '',
          'FirstNumber': '',
          'SecondName': '',
          'SecondNumber': '',
          'ThirdName': '',
          'ThirdNumber': '',
          'FourthName': '',
          'FourthNumber': '',
          'FifthName': '',
          'FifthNumber': '',
        });
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
      on PlatformException catch(e) {
        setState(() {
          showSpinner = false;
        });

        // Exception message for no internet connection
        if(e.message == 'An internal error has occurred. [ 7: ]' || e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          _showSnackBar('Internet connection is required to register!', Color(0xFFf55255));
        }
        else {
          _showSnackBar(e.message, Color(0xFFf55255));
        }
      }
    }
  }

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
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Color(0xFF4682B4), // Activated icons color
                      errorColor: Color(0xFFB80F0A),
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
                              if (value.isEmpty) {
                                return 'Name shouldn\'t be empty';
                              }
                              else if(value.length > 30) {
                                return 'Name cannot be more than 30 characters';
                              }
                              else if (RegExp(r'^[a-zA-Z_ ]+$').hasMatch(value) == false) {
                                return 'Only letters are allowed';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value;
                            },
                            decoration: kTextFormFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Name',
                              enabledBorder: kAuthFieldDecoration,
                            ),
                            style: kTextFieldValueDecoration,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if(value.length < 6) {
                                return 'Password should be 6 characters or more';
                              }
                              return null;
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
                          TextFormField(
                            validator: (value) {
                              if(value.length < 6) {
                                return 'Password should be 6 characters or more';
                              }
                              else if(_passwordController.text != value) {
                                return 'Password is not matched';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _confirmPassword = value;
                            },
                            decoration: kTextFormFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: passVisibility,
                                icon: isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                              ),
                              hintText: 'Confirm Password',
                              enabledBorder: kAuthFieldDecoration,
                            ),
                            obscureText: isHidden,
                            style: kTextFieldValueDecoration,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          TextFormField(
                            validator: (value) {
                              String firstDigit = '+0123456789';

                              if (value.isEmpty) {
                                return 'Phone number shouldn\'t be empty';
                              }
                              else if(value.length > 15) {
                                return 'Phone number cannot contain more than 15 digits';
                              }
                              else if(!firstDigit.contains(value[0])) {
                                return 'Please write a proper telephone number';
                              }
                              else if (RegExp(r'^[0-9_ ]+$').hasMatch(value.substring(1)) == false && value.length >= 1) {
                                return 'Please write a proper telephone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phoneNumber = value;
                            },
                            decoration: kTextFormFieldDecoration.copyWith(
                              prefixIcon: Icon(Icons.phone),
                              hintText: 'Phone Number',
                              enabledBorder: kAuthFieldDecoration,
                            ),
                            keyboardType: TextInputType.phone,
                            style: kTextFieldValueDecoration,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          FormButton(
                            status: 'Register',
                            onPress: register,
                          ),
                          SizedBox(height: screenHeight * 0.035),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                                },
                                child: Text(
                                  ' Login',
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
