import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/models/tip_data.dart';
import 'package:custos/widgets/customised_drawer.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';
import 'package:custos/widgets/reusable_card.dart';

TipBrain tipBrain = TipBrain();
Authentication auth = Authentication();

class TipScreen extends StatefulWidget {
  static String id = 'TipScreen';

  @override
  _TipScreenState createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String savedTipTitle;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  void getUserInfo() async {
    loggedInUser = await auth.getCurrentUser();
  }

  void _saveTip() async {
    setState(() {
      showSpinner = true;
    });

    final savedTips = await _firestore.collection('savedTips')
        .where('Email', isEqualTo: loggedInUser.email)
        .where('TipTitle', isEqualTo: tipBrain.getTipTitle())
        .getDocuments();

    for (var tip in savedTips.documents) {
      savedTipTitle = tip.data['TipTitle'];
    }

    if(savedTipTitle != tipBrain.getTipTitle()) {
      _firestore.collection('savedTips').add({
        'Email': loggedInUser.email,
        'TipTitle': tipBrain.getTipTitle(),
        'TipBody': tipBrain.getTipDescription(),
      });
    }

    setState(() {
      showSpinner = false;
    });

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: savedTipTitle != tipBrain.getTipTitle() ? Text('Successfully Saved!', textAlign: TextAlign.center) : Text('Sorry, can\'t save the tip. Maybe this tip has been already saved!'),
        backgroundColor: savedTipTitle != tipBrain.getTipTitle() ? Colors.green : Color(0xFFf55255),
        duration: Duration(seconds: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomisedDrawer(),
      appBar: ReusableAppBar(
        title: Text('Custos'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ReusableCard(
                children: <Widget>[
                  Text(
                    tipBrain.getTipTitle(),
                    style: kTitleTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.0175),
                  Text(
                    tipBrain.getTipDescription(),
                    style: kTipBodyTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveTip,
        child: Icon(
          Icons.add,
          size: 30.0,
        ),
        backgroundColor: Color(0xFF4682B4),
        mini: true,
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 2,
        isBottomNavItem: true,
      ),
    );
  }
}

