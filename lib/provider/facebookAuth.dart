import 'package:flutter/cupertino.dart';
import 'package:ufm/controllers/firestoreController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookAuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = new FacebookLogin();
  FireStoreController fireStoreController = new FireStoreController();
  User user;

  Future<bool> signOut() async {
    try {
      await facebookSignIn.logOut();
      return true;
    } catch (e) {
      print("FACEBOOK SIGNOUT ERR ${e.toString()}");
      return false;
    }
  }

  Future<void> logOut() async {
    await facebookSignIn.logOut();
    await _auth.signOut();
    user = null;
  }

  Future<FirebaseUser> auth() async {
    bool isSignedIn = await facebookSignIn.isLoggedIn;
    if (isSignedIn) {
      user = await _auth.currentUser;
    } else {
      FacebookLoginResult result = await facebookSignIn.logIn(['email']);
      FacebookAccessToken accessToken = result.accessToken;

      var credential =
          FacebookAuthProvider.getCredential(result.accessToken.token);
      await _auth.signInWithCredential(credential);
      user = await _auth.currentUser;
    }
    return user;
  }
}
