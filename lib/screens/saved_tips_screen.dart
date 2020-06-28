import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/models/tip_data.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';
import 'package:custos/widgets/reusable_card.dart';

TipBrain tipBrain = TipBrain();
Authentication auth = Authentication();

class SavedTipsScreen extends StatefulWidget {
  static String id = 'SavedTipsScreen';

  @override
  _SavedTipsScreenState createState() => _SavedTipsScreenState();
}

class _SavedTipsScreenState extends State<SavedTipsScreen> {
  Firestore _firestore = Firestore.instance;

  FirebaseUser loggedInUser;

  String savedTipTitle;
  String savedTipBody;
  String docId;

  bool emptyTips = false;

  ReusableCard tipCard;
  List<ReusableCard> savedTips = [];
  List<String> docIds = [];

  @override
  void initState() {
    super.initState();

    getTips();
  }

  void getTips() async {
    loggedInUser = await auth.getCurrentUser();

    final tips = await _firestore
        .collection('savedTips')
        .where('Email', isEqualTo: loggedInUser.email)
        .getDocuments();

    if (tips.documents.isEmpty) {
      setState(() {
        emptyTips = true;
      });
    } else {
      for (var tip in tips.documents) {
        setState(() {
          savedTipTitle = tip.data['TipTitle'];
          savedTipBody = tip.data['TipBody'];
          docIds.add(tip.documentID);
        });

        tipCard = ReusableCard(
          children: <Widget>[
            Text(
              savedTipTitle,
              style: kTitleTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              savedTipBody,
              style: kTipBodyTextStyle,
              textAlign: TextAlign.justify,
            ),
          ],
        );

        savedTips.add(tipCard);
      }
    }
  }

  void _deleteSavedTips() {
    for(docId in docIds) {
      _firestore.collection('savedTips').document(docId).delete();
    }

    setState(() {
      savedTips.clear();
      emptyTips = true;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        child: SimpleDialog(
          title: Text(
            'Are you sure you want to delete all of your saved tips?',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w400,
              fontSize: 17.0,
            ),
            textAlign: TextAlign.center,
          ),
          children: [
            Row(
              children: [
                SimpleDialogOption(
                    child: RaisedButton(
                      onPressed: (){
                        _deleteSavedTips();
                        Navigator.pop(context);
                      },
                      child: Text('Yes'),
                      color: Colors.green,
                      textColor: Colors.white,
                    )
                ),
                SimpleDialogOption(
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                    color: Color(0xFFf55255),
                    textColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        title: Text('Saved Tips'),
      ),
      body: SafeArea(
        // Check if saved tip title is null
        // If yes then check if the user has saved tips
        // If he has no saved tips then "Empty" message will be shown
        // If he has then it will show circular progress indicator till the saved tip title changes the value from null to real data
        child: savedTips.isEmpty
            ? emptyTips
                ? Center(
                    child: Text('Empty', style: kEmptySavedTips,),
                  )
                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4682B4)), strokeWidth: 3))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: savedTips,
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(
          Icons.delete_forever,
          size: 25.0,
        ),
        backgroundColor: Color(0xFFf55255),
        mini: true,
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 0,
        isBottomNavItem: false,
      ),
    );
  }
}
