import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  Future<FirebaseUser> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if(user != null) {
        return user;
      }
    }
    catch(e) {
      print(e);
    }
  }

  void logout() {
    _auth.signOut();
  }
}