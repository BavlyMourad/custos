import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sendsms/sendsms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/widgets/round_button.dart';
import 'package:custos/widgets/button_content.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_drawer.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';
import 'package:custos/widgets/form_button.dart';
import 'package:custos/screens/login_screen.dart';
import 'package:custos/screens/walkthrough_screen.dart';

Authentication auth = Authentication();

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  SharedPreferences prefs;

  StreamSubscription<Position> _positionStream;

  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String name, password;
  bool walkedThrough = false;
  bool safeButtonEnabled = false;

  String updatedLocationMessage, sosMessage, safeMessage;

  String primaryNumber, secondNumber, thirdNumber, fourthNumber, fifthNumber;

  bool sosSmsPrimaryContact = true;
  bool sosSmsOtherContacts = true;
  bool sosCallPrimary = true;
  bool sendLocationSms = true;
  bool sendUpdatedLocationSms = true;
  int updatedLocationSmsTimer;

  bool safeSmsPrimaryContact = true;
  bool safeSmsOtherContacts = true;

  Timer timer;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  void getUserInfo() async {
    loggedInUser = await auth.getCurrentUser();

    // Checks if there is no user so it navigates to the Login Screen
    if(loggedInUser == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }
    else {
      prefs = await SharedPreferences.getInstance();

      setState(() {
        safeButtonEnabled = prefs.getBool('safeButtonEnabled');
        walkedThrough = prefs.getBool('walkedThrough');
        password = prefs.getString('password');
      });

      // Checks if it is the first time for the user to use the app so it navigates him to the Walkthrough Screen
      if(walkedThrough == false) {
        Navigator.pushReplacementNamed(context, WalkthroughScreen.id);
      }
      // Get the name of the user and save it in shared preference so it can be shown in the drawer
      else {
        final users = await _firestore
            .collection('users')
            .where('Email', isEqualTo: loggedInUser.email)
            .getDocuments();

        for (var user in users.documents) {
          setState(() {
            name = user.data['Name'];
          });
        }
        prefs.setString('name', name);
      }
    }
  }

  // Get user's location automatically
  void _startTracking() {
    final geolocator = Geolocator();
    final locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 5);

    _positionStream = geolocator.getPositionStream(locationOptions).listen(_onLocationUpdate);
  }

  // Get the updated latitude and longitude
  void _onLocationUpdate(Position position) {
    if(position != null) {
      updatedLocationMessage = 'This is my last known location: maps.google.com/?q=${position.latitude},${position.longitude}';
    }
  }

  void _sendSmsAndCall(String message, bool call, bool isSafe) async {
    final contacts = await _firestore.collection('contacts')
        .where('Email', isEqualTo: loggedInUser.email)
        .getDocuments();

    for (var contact in contacts.documents) {
      if(primaryNumber == null) {
        primaryNumber = contact.data['FirstNumber'];
      }
      secondNumber = contact.data['SecondNumber'];
      thirdNumber = contact.data['ThirdNumber'];
      fourthNumber = contact.data['FourthNumber'];
      fifthNumber = contact.data['FifthNumber'];
    }

    setState(() {
      // Get the primary number that the user saved
      primaryNumber = prefs.getString('primaryContact');

      // Get user approvals for SOS and SAFE buttons features
      sosSmsPrimaryContact = prefs.getBool('sosSmsPrimary');
      sosSmsOtherContacts = prefs.getBool('sosSmsOthers');
      sosCallPrimary = prefs.getBool('sosCall');

      safeSmsPrimaryContact = prefs.getBool('safeSmsPrimary');
      safeSmsOtherContacts = prefs.getBool('safeSmsOthers');
    });

    // If the user didn't save a primary number, police number is assigned as a primary number
    if(primaryNumber.isEmpty || primaryNumber == null) {
      primaryNumber = '122';
    }

    // If it is true then it's called from the SOS function and check if the user approved to call primary contact directly
    if(call == true && sosCallPrimary == true) {
      await FlutterPhoneDirectCaller.directCall(primaryNumber);
    }

    // Check if the function is called by the SAFE function, and approved to send sms to primary contact and the primary number is not the police
    if(isSafe == true && safeSmsPrimaryContact == true && primaryNumber != '122') {
      Future.delayed(
        Duration(seconds: 7), () async => primaryNumber.isNotEmpty ? await Sendsms.onSendSMS(primaryNumber, message) : null,
      );
    }

    // Check if the function is called by the SOS function, and approved to send sms to primary contact and the primary number is not the police
    if(isSafe == false && sosSmsPrimaryContact == true && primaryNumber != '122') {
      Future.delayed(
        Duration(seconds: 7), () async => primaryNumber.isNotEmpty ? await Sendsms.onSendSMS(primaryNumber, message) : null,
      );
    }

    // Check if the function is called by the SAFE function, and approved to send sms to other contacts
    if(isSafe == true && safeSmsOtherContacts == true) {
      Future.delayed(
        Duration(seconds: 9), () async => secondNumber.isNotEmpty ? await Sendsms.onSendSMS(secondNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 11), () async => thirdNumber.isNotEmpty ? await Sendsms.onSendSMS(thirdNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 13), () async => fourthNumber.isNotEmpty ? await Sendsms.onSendSMS(fourthNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 15), () async => fifthNumber.isNotEmpty ? await Sendsms.onSendSMS(fifthNumber, message) : null,
      );
    }

    // Check if the function is called by the SOS function, and approved to send sms to other contacts
    if(isSafe == false && sosSmsOtherContacts == true) {
      Future.delayed(
        Duration(seconds: 9), () async => secondNumber.isNotEmpty ? await Sendsms.onSendSMS(secondNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 11), () async => thirdNumber.isNotEmpty ? await Sendsms.onSendSMS(thirdNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 13), () async => fourthNumber.isNotEmpty ? await Sendsms.onSendSMS(fourthNumber, message) : null,
      );
      Future.delayed(
        Duration(seconds: 15), () async => fifthNumber.isNotEmpty ? await Sendsms.onSendSMS(fifthNumber, message) : null,
      );
    }
  }

  void _sendSOS() async {
    prefs = await SharedPreferences.getInstance();

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    // Get approvals for sending location in sms and sending updated locations in sms and its timer
    setState(() {
      sendLocationSms = prefs.getBool('sendLocation');
      sendUpdatedLocationSms = prefs.getBool('sendUpdatedLocation');
      updatedLocationSmsTimer = prefs.getInt('updatedLocationTimer');
    });

    // If the user didn't approve to send his location in the sms
    if(sendLocationSms == false) {
      sosMessage = 'This message is sent from a women security application(Custos) and i am in danger, please help!';
    }
    else {
      sosMessage = 'This message is sent from a women security application(Custos) and i am in danger, please help. maps.google.com/?q=${position.latitude},${position.longitude}';
    }

    // Saves the current location when the SOS button was clicked
    _firestore.collection('dangerZones').add({
      'Latitude': position.latitude,
      'Longitude': position.longitude,
    });

    _sendSmsAndCall(sosMessage, true, false);

    // Changes the value of the safeButtonEnabled to true because the SOS button is clicked
    prefs.setBool('safeButtonEnabled', true);

    // Check if the user approved to send updated location sms
    if(sendUpdatedLocationSms == true) {
      // Get user's location automatically and set timer to keep sending SMS if the user didn't click on the Safe button
      _startTracking();

      // Keep sending the last known location to the primary contact if he still didn't click on the Safe button
      timer = Timer.periodic(Duration(minutes: updatedLocationSmsTimer), (Timer t) async {
        safeButtonEnabled = prefs.getBool('safeButtonEnabled');

        if(safeButtonEnabled == true) {
          await Sendsms.onSendSMS(primaryNumber, updatedLocationMessage);
        }
        else {
          if(_positionStream != null) {
            _positionStream.cancel();
            _positionStream = null;
          }

          if(timer != null) {
            timer.cancel();
            timer = null;
          }
        }
      });
    }
  }

  void _sendSafe() async {
    safeMessage = 'I am safe now, thank you!';

    _sendSmsAndCall(safeMessage, false, true);

    // Changes the value of the safeButtonEnabled to false because the Safe button is clicked
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('safeButtonEnabled', false);

    setState(() {
      safeButtonEnabled = false;
    });
  }

  void _checkRealUser () {
    if(_formKey.currentState.validate() && password == _passwordController.text) {
      _sendSafe();

      Navigator.pop(context);
    }
  }

  void _showDialog() {
    _passwordController.clear();

    showDialog(
      context: context,
      child: SimpleDialog(
        title: Text(
          'Please enter your password to check if it\'s really you!',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w400,
            fontSize: 17.0,
          ),
          textAlign: TextAlign.center,
        ),
        children: [
          SimpleDialogOption(
            child: Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if(value != password) {
                    return 'Wrong password';
                  }
                  return null;
                },
                decoration: kTextFormFieldDecoration.copyWith(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Password',
                ),
                controller: _passwordController,
                obscureText: true,
              ),
            ),
          ),
          SimpleDialogOption(
            child: FormButton(
              onPress: _checkRealUser,
              status: 'Check',
            ),
          ),
        ],
      )
    );
  }

  void _showBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: safeButtonEnabled
          ? Text(
              'Click on The SAFE Button First!',
              textAlign: TextAlign.center,
            )
          : Text(
              'Click on The SOS Button First!',
              textAlign: TextAlign.center,
            ),
      backgroundColor: Color(0xFFf55255),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomisedDrawer(),
      appBar: ReusableAppBar(
        title: Text('Custos'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RoundButton(
                  onPress: () {
                    if (!safeButtonEnabled) {
                      _sendSOS();
                      setState(() {
                        safeButtonEnabled = true;
                      });
                    }
                    else {
                      _showBar();
                    }
                  },
                  buttonChild: ButtonContent(
                    status: 'SOS',
                    icon: Icons.report_problem,
                  ),
                  color: safeButtonEnabled
                      ? Colors.grey
                      : Color(0xFFf55255),
                ),
              ),
              Expanded(
                child: RoundButton(
                  onPress: () {
                    if(safeButtonEnabled) {
                    _showDialog();
                    }
                    else {
                      _showBar();
                    }
                  },
                  buttonChild: ButtonContent(
                    status: 'SAFE',
                    icon: Icons.security,
                  ),
                  color: safeButtonEnabled
                      ? Color(0xFF3aa7f9)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 0,
        isBottomNavItem: true,
      ),
    );
  }
}
