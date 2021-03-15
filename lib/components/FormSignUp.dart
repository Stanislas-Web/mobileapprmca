import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingUp extends StatefulWidget {
  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 50, right: 50, top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
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
                  vertical: 10.0,
                  horizontal: 16.0,
                ),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirmer mot de passe',
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
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    )),
              ),
              signUpFacebookanGoogle(),
            ],
          ),
        ));
  }
}

Widget signUpFacebookanGoogle() {
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
