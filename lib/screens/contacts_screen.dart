import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';
import 'package:custos/widgets/reusable_card.dart';
import 'package:custos/widgets/form_button.dart';

Authentication auth = Authentication();

class ContactsScreen extends StatefulWidget {
  static String id = 'ContactsScreen';

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sorry for that spam
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();
  final TextEditingController _thirdNameController = TextEditingController();
  final TextEditingController _thirdNumberController = TextEditingController();
  final TextEditingController _fourthNameController = TextEditingController();
  final TextEditingController _fourthNumberController = TextEditingController();
  final TextEditingController _fifthNameController = TextEditingController();
  final TextEditingController _fifthNumberController = TextEditingController();


  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  SharedPreferences prefs;

  bool showSpinner = false;

  PhoneContact contact;

  String docId;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  String nameValidator(String value) {
    if(value.length >= 1 && RegExp(r'^[a-zA-Z0-9_ ]+$').hasMatch(value) == false) {
      return 'Only letters are allowed';
    }
    return null;
  }

  String phoneValidator(String value) {
    String firstDigit = '+0123456789';

    if(value.length >= 1 && RegExp(r'^[0-9_ ]+$').hasMatch(value.substring(1)) == false) {
      return 'Please write a proper mobile number';
    }
    else if(value.length >= 1 && !firstDigit.contains(value[0])) {
      return 'Please write a proper telephone number';
    }
    else if(value.length >= 15) {
      return 'Phone number cannot contain more than 15 digits';
    }
    return null;
  }

  void getUserInfo() async {
    loggedInUser = await auth.getCurrentUser();

    final contacts = await _firestore
        .collection('contacts')
        .where('Email', isEqualTo: loggedInUser.email)
        .getDocuments();

    for (var contact in contacts.documents) {
      setState(() {
        _firstNameController.text = contact.data['FirstName'];
        _secondNameController.text = contact.data['SecondName'];
        _thirdNameController.text = contact.data['ThirdName'];
        _fourthNameController.text = contact.data['FourthName'];
        _fifthNameController.text = contact.data['FifthName'];
        _firstNumberController.text = contact.data['FirstNumber'];
        _secondNumberController.text = contact.data['SecondNumber'];
        _thirdNumberController.text = contact.data['ThirdNumber'];
        _fourthNumberController.text = contact.data['FourthNumber'];
        _fifthNumberController.text = contact.data['FifthNumber'];
        docId = contact.documentID;
      });
    }
  }

  void updateContacts() async {
    prefs = await SharedPreferences.getInstance();

    if (_formKey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      _formKey.currentState.save();
      try {
        _firestore.collection('contacts').document(docId).updateData({
          'FirstName': _firstNameController.text,
          'FirstNumber': _firstNumberController.text,
          'SecondName': _secondNameController.text,
          'SecondNumber': _secondNumberController.text,
          'ThirdName': _thirdNameController.text,
          'ThirdNumber': _thirdNumberController.text,
          'FourthName': _fourthNameController.text,
          'FourthNumber': _fourthNumberController.text,
          'FifthName': _fifthNameController.text,
          'FifthNumber': _fifthNumberController.text,
        });

        // Saving primary contact so we don't have to wait too long if the user clicked on the SOS button with no internet connection
        prefs.setString('primaryContact', _firstNumberController.text);

        _showSnackBar();

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = true;
        });
      }
    }
  }

  void _showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Successfully Saved!',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: ReusableAppBar(
        title: Text('Contacts'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: docId == null
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4682B4)), strokeWidth: 3))
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor:
                            Color(0xFF4682B4), // Activated icons color
                        errorColor: Color(0xFFB80F0A),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'Primary Contact',
                                style: kTitleTextStyle,
                              ),
                            ),
                            ReusableCard(
                              children: <Widget>[
                                TextFormField(
                                  controller: _firstNameController,
                                  validator: nameValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _firstNameController.text = contact.fullName;
                                          _firstNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Contact Name #1',
                                  ),
                                  onSaved: (value) {
                                    _firstNameController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.0175),
                                TextFormField(
                                  controller: _firstNumberController,
                                  validator: phoneValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.phone),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _firstNameController.text = contact.fullName;
                                          _firstNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Phone Number #1',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) {
                                    _firstNumberController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5.0, top: 40.0),
                              child: Text(
                                'Other Contacts',
                                style: kTitleTextStyle,
                              ),
                            ),
                            ReusableCard(
                              children: <Widget>[
                                TextFormField(
                                  controller: _secondNameController,
                                  validator: nameValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _secondNameController.text = contact.fullName;
                                          _secondNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Contact Name #2',
                                  ),
                                  onSaved: (value) {
                                    _secondNameController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.0175),
                                TextFormField(
                                  controller: _secondNumberController,
                                  validator: phoneValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.phone),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _secondNameController.text = contact.fullName;
                                          _secondNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Phone Number #2',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) {
                                    _secondNumberController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.07),
                                TextFormField(
                                  controller: _thirdNameController,
                                  validator: nameValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _thirdNameController.text = contact.fullName;
                                          _thirdNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Contact Name #3',
                                  ),
                                  onSaved: (value) {
                                    _thirdNameController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.0175),
                                TextFormField(
                                  controller: _thirdNumberController,
                                  validator: phoneValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.phone),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _thirdNameController.text = contact.fullName;
                                          _thirdNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Phone Number #3',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) {
                                    _thirdNumberController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.07),
                                TextFormField(
                                  controller: _fourthNameController,
                                  validator: nameValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _fourthNameController.text = contact.fullName;
                                          _fourthNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Contact Name #4',
                                  ),
                                  onSaved: (value) {
                                    _fourthNameController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.0175),
                                TextFormField(
                                  controller: _fourthNumberController,
                                  validator: phoneValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.phone),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _fourthNameController.text = contact.fullName;
                                          _fourthNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Phone Number #4',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) {
                                    _fourthNumberController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.07),
                                TextFormField(
                                  controller: _fifthNameController,
                                  validator: nameValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _fifthNameController.text = contact.fullName;
                                          _fifthNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Contact Name #5',
                                  ),
                                  onSaved: (value) {
                                    _fifthNameController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                                SizedBox(height: screenHeight * 0.0175),
                                TextFormField(
                                  controller: _fifthNumberController,
                                  validator: phoneValidator,
                                  decoration: kTextFormFieldDecoration.copyWith(
                                    prefixIcon: Icon(Icons.phone),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        contact = await FlutterContactPicker.pickPhoneContact();
                                        setState(() {
                                          _fifthNameController.text = contact.fullName;
                                          _fifthNumberController.text = contact.phoneNumber.number;
                                        });
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                    hintText: 'Phone Number #5',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) {
                                    _fifthNumberController.text = value;
                                  },
                                  style: kTextFieldValueDecoration,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            FormButton(
                              onPress: updateContacts,
                              status: 'Save',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: CustomisedBottomNavigationBar(
        index: 0,
        isBottomNavItem: false,
      ),
    );
  }
}
