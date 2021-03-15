import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ufm/components/playerPodcastRecent.dart';
import 'package:ufm/provider/facebookAuth.dart';
import 'package:ufm/provider/google_sign_in.dart';
import 'package:ufm/provider/player.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  PlayerProvider player = new PlayerProvider();
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();
  FacebookAuthController facebookAuth = new FacebookAuthController();
  bool isAuth = false;
  var userData;
  var user;
  Future checkUser() async {
    user = await FirebaseAuth.instance.currentUser;
    print("mon user $user");
    if (user != null) {
      userData = user;
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    pr.style(
      message: 'Veuillez patienter...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressTextStyle: TextStyle(
          color: Color(0xFFFFEB3B),
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w300),
    );
    Size size = MediaQuery.of(context).size;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              height: 15,
              width: 15,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 15,
                width: 15,
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          isAuth == false
              ? Container(
                  margin: EdgeInsets.only(top: 30),
                  height: size.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(100))),
                  child: Column(
                    children: [
                      // Login(),

                      Padding(
                        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 50.0,
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
                          horizontal: 50.0,
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
                            // if (_formKey.currentState.validate()) {
                            //   // If the form is valid, display a Snackbar.
                            //   Scaffold.of(context).showSnackBar(SnackBar(
                            //       content: Text('Processing Data')));
                            // }
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
                          ),
                        ),
                      ),
                      // SocialMediaButton(),
                      //SocialButton
                      Container(
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
                                      onPressed: () async {
                                        pr.show();
                                        await facebookAuth.auth();
                                        pr.hide();
                                        checkUser();
                                      },
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
                                        pr.show();
                                        await googleAuth.login();
                                        pr.hide();
                                        // googleAuth.logout();
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
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        margin: EdgeInsets.only(top: 30),
                        width: size.width * 0.7,
                        height: size.height * 0.4,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image: NetworkImage(arguments['image']),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.1 / 2,
                      ),
                      Slider(
                        value: 10,
                        max: 100,
                        onChanged: null,
                        activeColor: Color(0xFFFFEB3B),
                        inactiveColor: Color(0xFFFFEB3B),
                      ),
                      SizedBox(
                        height: size.height * 0.1 / 2,
                      ),
                      PlayerPodcastRecent(streamUrl: arguments['streamUrl']),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                    ],
                  ),
                ),

          // Header(),
          // RecentPodcast(),
          // Emission(),
          // Video(),
        ]),
      ),
    );
  }
}
