import 'package:flutter/material.dart';

class VerificationGoogleProvider extends ChangeNotifier {
  var userData;
  Future updateUserData(value) {
    userData = value;
    return userData;
  }

  Future getUserData() {
    return userData;
  }
}
