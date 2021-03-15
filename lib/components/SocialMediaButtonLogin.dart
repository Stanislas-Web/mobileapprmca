import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufm/provider/google_sign_in.dart';

class SocialMediaButton extends StatefulWidget {
  @override
  _SocialMediaButtonState createState() => _SocialMediaButtonState();
}

class _SocialMediaButtonState extends State<SocialMediaButton> {
  // var googleAuth = new FireStoreController();
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();
  bool isAuth = false;
  var userData;
  void checkUser() {
    googleAuth.login().then((value) {
      print(value.displayName);
      if (value != null) {
        setState(() {
          isAuth = true;
          userData = value;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("ou"),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/face.svg',
                      height: 50,
                      width: 50,
                    ),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/google.svg',
                      height: 50,
                      width: 50,
                    ),
                    onPressed: () async {
                      await googleAuth.login();
                      checkUser();
                      // print(auth);
                      // print("google");
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
