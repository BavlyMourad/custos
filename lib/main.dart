import 'package:flutter/material.dart';
import 'package:custos/screens/login_screen.dart';
import 'package:custos/screens/forgot_password_screen.dart';
import 'package:custos/screens/register_screen.dart';
import 'screens/walkthrough_screen.dart';
import 'package:custos/screens/home_screen.dart';
import 'package:custos/screens/map_screen.dart';
import 'package:custos/screens/tip_screen.dart';
import 'package:custos/screens/settings_screen.dart';
import 'package:custos/screens/profile_screen.dart';
import 'package:custos/screens/contacts_screen.dart';
import 'package:custos/screens/saved_tips_screen.dart';
import 'package:custos/screens/privacy_policy_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custos',
      color: Colors.grey.shade300,
      initialRoute: HomeScreen.id,
      routes: {
        LoginScreen.id : (context) => LoginScreen(),
        ForgotPasswordScreen.id : (context) => ForgotPasswordScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        WalkthroughScreen.id : (context) => WalkthroughScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        MapScreen.id : (context) => MapScreen(),
        TipScreen.id : (context) => TipScreen(),
        SettingsScreen.id : (context) => SettingsScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        ContactsScreen.id : (context) => ContactsScreen(),
        SavedTipsScreen.id : (context) => SavedTipsScreen(),
        PrivacyPolicyScreen.id: (context) => PrivacyPolicyScreen(),
      },
    ),
  );
}
