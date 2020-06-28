import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/widgets/text_icon.dart';
import 'package:custos/screens/login_screen.dart';
import 'package:custos/screens/profile_screen.dart';
import 'package:custos/screens/contacts_screen.dart';
import 'package:custos/screens/saved_tips_screen.dart';
import 'package:custos/screens/privacy_policy_screen.dart';

Authentication auth = new Authentication();

class CustomisedDrawer extends StatefulWidget {
  @override
  _CustomisedDrawerState createState() => _CustomisedDrawerState();
}

class _CustomisedDrawerState extends State<CustomisedDrawer> {

  SharedPreferences prefs;

  String name;
  String image;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  void getUserInfo() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      image = prefs.getString('image');
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                color: Color(0xFF4682B4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: screenWidth * 0.04),
                    CircleAvatar(
                      backgroundImage: image == null ? null : NetworkImage(image),
                      child: image == null ? Icon(Icons.person, color: Colors.grey, size: 50.0) : null,
                      backgroundColor: Color(0xFFD6D6D6),
                      radius: 50.0,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: AutoSizeText(
                        name == null ? '' : name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35.0,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextIcon(
              onPress: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
              icon: Icon(Icons.person),
              title: 'Profile',
            ),
            TextIcon(
              onPress: () {
                Navigator.pushNamed(context, ContactsScreen.id);
              },
              icon: Icon(Icons.people),
              title: 'Contacts',
            ),
            TextIcon(
              onPress: () {
                Navigator.pushNamed(context, SavedTipsScreen.id);
              },
              icon: Icon(Icons.info),
              title: 'Saved Tips',
            ),
            TextIcon(
              onPress: () {
                Navigator.pushNamed(context, PrivacyPolicyScreen.id);
              },
              icon: Icon(Icons.lock),
              title: 'Privacy Policy',
            ),
            SizedBox(height: screenHeight * 0.0175),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  auth.logout();
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFFE6666),
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

