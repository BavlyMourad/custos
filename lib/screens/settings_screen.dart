import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/customised_drawer.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';

class SettingsScreen extends StatefulWidget {
  static String id = 'SettingsScreen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences prefs;

  bool sosSmsPrimaryContact = true;
  bool sosSmsOtherContacts = true;
  bool sosCallPrimary = true;
  bool sendLocationSms = true;
  bool sendUpdatedLocationSms = true;
  int updatedLocationSmsTimer = 10;

  bool safeSmsPrimaryContact = true;
  bool safeSmsOtherContacts = true;

  @override
  void initState() {
    _getSettings();
    super.initState();
  }

  void _getSettings() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sosSmsPrimaryContact = prefs.getBool('sosSmsPrimary');
      sosSmsOtherContacts = prefs.getBool('sosSmsOthers');
      sosCallPrimary = prefs.getBool('sosCall');
      sendLocationSms = prefs.getBool('sendLocation');
      sendUpdatedLocationSms = prefs.getBool('sendUpdatedLocation');
      updatedLocationSmsTimer = prefs.getInt('updatedLocationTimer');

      safeSmsPrimaryContact = prefs.getBool('safeSmsPrimary');
      safeSmsOtherContacts = prefs.getBool('safeSmsOthers');
    });
  }

  void sosSmsPrimary(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sosSmsPrimaryContact = isSwitched;
    });

    prefs.setBool('sosSmsPrimary', sosSmsPrimaryContact);
  }

  void sosSmsOthers(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sosSmsOtherContacts = isSwitched;
    });

    prefs.setBool('sosSmsOthers', sosSmsOtherContacts);
  }

  void sosCall(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sosCallPrimary = isSwitched;
    });

    prefs.setBool('sosCall', sosCallPrimary);
  }

  void sendLocation(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sendLocationSms = isSwitched;
    });

    prefs.setBool('sendLocation', sendLocationSms);
  }

  void sendUpdatedLocation(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      sendUpdatedLocationSms = isSwitched;
    });

    prefs.setBool('sendUpdatedLocation', sendUpdatedLocationSms);
  }

  void safeSmsPrimary(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      safeSmsPrimaryContact = isSwitched;
    });

    prefs.setBool('safeSmsPrimary', safeSmsPrimaryContact);
  }

  void safeSmsOthers(bool isSwitched) async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      safeSmsOtherContacts = isSwitched;
    });

    prefs.setBool('safeSmsOthers', safeSmsOtherContacts);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: CustomisedDrawer(),
      appBar: ReusableAppBar(
        title: Text('Custos'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'SOS Button',
                    style: kTitleTextStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send SMS to the primary contact',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: sosSmsPrimaryContact,
                      onChanged: sosSmsPrimary,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send SMS to other contacts',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: sosSmsOtherContacts,
                      onChanged: sosSmsOthers,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Call primary contact/police',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: sosCallPrimary,
                      onChanged: sosCall,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send your location within the SMS',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: sendLocationSms,
                      onChanged: sendLocation,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send your updated location automatically to the primary contact in SMS',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: sendUpdatedLocationSms,
                      onChanged: sendUpdatedLocation,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  'Send your updated location every $updatedLocationSmsTimer minutes',
                  style: kSettingsText,
                ),
                SizedBox(height: screenHeight * 0.03),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Color(0xFF4682B4),
                    thumbColor: Color(0xFF0052a5),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 5.0),
                  ),
                  child: Slider(
                    value: updatedLocationSmsTimer.toDouble(),
                    min: 1.0,
                    max: 30.0,
                    onChanged: sendUpdatedLocationSms == false
                        ? null
                        : (double newValue) async {
                      prefs = await SharedPreferences.getInstance();

                      setState(() {
                        updatedLocationSmsTimer = newValue.round();
                      });

                      prefs.setInt('updatedLocationTimer', updatedLocationSmsTimer);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.081),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'SAFE Button',
                    style: kTitleTextStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send SMS to the primary contact',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: safeSmsPrimaryContact,
                      onChanged: safeSmsPrimary,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Send SMS to other contacts',
                        style: kSettingsText,
                      ),
                    ),
                    Switch(
                      value: safeSmsOtherContacts,
                      onChanged: safeSmsOthers,
                      activeColor: Color(0xFF4682B4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 3,
        isBottomNavItem: true,
      ),
    );
  }
}
