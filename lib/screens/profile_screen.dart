import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custos/utilities/constants.dart';
import 'package:custos/utilities/authentication.dart';
import 'package:custos/widgets/reusable_app_bar.dart';
import 'package:custos/widgets/customised_bottom_navbar.dart';
import 'package:custos/widgets/form_button.dart';

Authentication auth = Authentication();

class ProfileScreen extends StatefulWidget {
  static String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage(storageBucket: kStorageBucket);

  File _pickedImage;
  String _savedImage;

  SharedPreferences prefs;

  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  String docId;

  String name, phone, oldPassword, confirmPassword;

  bool isHidden = true;

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();

    getUserInfo();
  }

  void getUserInfo() async {
    loggedInUser = await auth.getCurrentUser();

    prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedImage = prefs.getString('image');
      oldPassword = prefs.getString('password');
    });

    final users = await _firestore
        .collection('users')
        .where('Email', isEqualTo: loggedInUser.email)
        .getDocuments();

    for (var user in users.documents) {
      setState(() {
        name = user.data['Name'];
        phone = user.data['Phone'];
        docId = user.documentID;
      });
    }
  }

  void updateProfile() async {
    prefs = await SharedPreferences.getInstance();

    if (_formKey.currentState.validate()) {
      setState(() {
        showSpinner = true;
      });
      _formKey.currentState.save();
      try {
        // Checks if the user typed anything in the password field so it updates the password
        if (confirmPassword.isNotEmpty) {
          await loggedInUser.updatePassword(confirmPassword);

          // Update the user's password to use it in a condition when he clicks on the Safe button to check if he is the real user
          prefs.setString('password', confirmPassword);
        }

        if(_pickedImage != null) {
          // Upload image to FirebaseStorage
          StorageReference ref = storage.ref().child(_pickedImage.path);
          StorageUploadTask storageUploadTask = ref.putFile(_pickedImage);
          StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
          String url = await taskSnapshot.ref.getDownloadURL();

          // Save the url of the image in shared preferences to use it in Network Image
          prefs.setString('image', url);
        }

        _firestore.collection('users').document(docId).updateData({
          'Name': name,
          'Phone': phone,
        });

        // Updates the name so it updates in the drawer
        prefs.setString('name', name);

        _showSnackBar('Successfully saved!', Colors.green);

        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        if(e.message == 'This operation is sensitive and requires recent authentication. Log in again before retrying this request.') {
          _showSnackBar('Please Log in again and retry your request', Color(0xFFf55255));
        }
        else {
          _showSnackBar('Internet connection is required to update your changes', Color(0xFFf55255));
        }
        setState(() {
          showSpinner = false;
        });
      }
    }
  }

  Future _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = image;
    });
  }

  void passVisibility() {
    setState(() {
      if (isHidden) {
        isHidden = false;
      } else {
        isHidden = true;
      }
    });
  }

  void _showSnackBar(String message, Color color) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
      message,
      textAlign: TextAlign.center,
    ),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: ReusableAppBar(
        title: Text('Profile'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: name == null
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4682B4)), strokeWidth: 3))
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 15.0, right: 10.0, bottom: 30.0),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        primaryColor:
                            Color(0xFF4682B4), // Activated icons color
                        errorColor: Color(0xFFB80F0A),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                // Check if you didn't pick an image, if yes it will check if there is already saved image
                                // If you did pick an image it will show the image you just picked, if you saved an image before then it will show the saved image
                                // If you didn't save or pick an image then the background will be null
                                backgroundImage: _pickedImage == null
                                    ? _savedImage == null
                                        ? null
                                        : NetworkImage(_savedImage)
                                    : FileImage(_pickedImage),
                                radius: 80.0,
                                backgroundColor: Color(0xFFD6D6D6),
                                // Check if you didn't save an image, if yes it will check if you picked an image
                                // If you did save an image then child will be null, if you picked an image then the child will be null
                                // If you didn't save or pick an image then the child will be a camera icon
                                child: _savedImage == null
                                    ? _pickedImage == null
                                        ? Icon(Icons.photo_camera, color: Colors.grey, size: 50.0)
                                        : null
                                    : null,
                              ),
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
                              decoration: kTextFormFieldDecoration.copyWith(
                                prefixIcon: Icon(Icons.person),
                                suffixIcon: Icon(Icons.edit),
                              ),
                              initialValue: name,
                              onSaved: (value) {
                                name = value;
                              },
                              style: kTextFieldValueDecoration,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            TextFormField(
                              validator: (value) {
                                // Checks if the password is not empty because it is not required to update the profile
                                if (value.length < 6 && value.length >= 1) {
                                  return 'Password should be 6 characters or more';
                                }
                                else if(value != oldPassword && value.length >= 1) {
                                  return 'Incorrect password, please try again';
                                }
                                else if (_passwordController.text.isEmpty && value.length >= 1) {
                                  return 'Please write your new password';
                                }
                                return null;
                              },
                              decoration: kTextFormFieldDecoration.copyWith(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: passVisibility,
                                  icon: isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                hintText: 'Old Password',
                              ),
                              style: kTextFieldValueDecoration,
                              obscureText: isHidden,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                // Checks if the password is not empty because it is not required to update the profile
                                if (value.length < 6 && value.length >= 1) {
                                  return 'Password should be 6 characters or more';
                                }
                                else if (_confirmPasswordController.text != value) {
                                  return 'Password is not matched';
                                }
                                return null;
                              },
                              decoration: kTextFormFieldDecoration.copyWith(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: passVisibility,
                                  icon: isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                hintText: 'New Password',
                              ),
                              style: kTextFieldValueDecoration,
                              obscureText: isHidden,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            TextFormField(
                              controller: _confirmPasswordController,
                              validator: (value) {
                                // Checks if the password is not empty because it is not required to update the profile
                                if (value.length < 6 && value.length >= 1) {
                                  return 'Password should be 6 characters or more';
                                }
                                else if (_passwordController.text != value) {
                                  return 'Password is not matched';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                confirmPassword = value;
                              },
                              decoration: kTextFormFieldDecoration.copyWith(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: passVisibility,
                                  icon: isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                hintText: 'Confirm Password',
                              ),
                              style: kTextFieldValueDecoration,
                              obscureText: isHidden,
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
                              decoration: kTextFormFieldDecoration.copyWith(
                                prefixIcon: Icon(Icons.phone),
                                suffixIcon: Icon(Icons.edit),
                              ),
                              initialValue: phone,
                              onSaved: (value) {
                                phone = value;
                              },
                              style: kTextFieldValueDecoration,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            FormButton(
                              onPress: updateProfile,
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
