import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ufm/main.dart';
import 'package:ufm/screens/home.dart';
import 'package:ufm/screens/profilFacebook.dart';
import 'package:ufm/services/authGoogle.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {}

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 50, right: 50, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    // suffixIcon:                       //     icon: SvgPicture.asset(
                    //   //       'assets/icons/play.svg',
                    //   //       height: 100,
                    //   //       width: 100,
                    //   //     ),
                    hintText: 'Mot de passe',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: GestureDetector(
                    onTap: () {
                      print("top");
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFFFFEB3B),
                      ),
                      width: 220.0,
                      padding: new EdgeInsets.all(15.0),
                      child: new Column(children: [
                        new Text(
                          "Créer un compte",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]),
                    )),
              ),
            ],
          ),
        ));
  }
}

Widget signUpFacebookanGoogle(authBloc) {
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
                  onPressed: () => authBloc.loginFacebook(),
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
                    onPressed: () {}),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
