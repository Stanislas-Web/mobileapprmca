import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:ufm/components/FormSignUp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ufm/components/custom_surfix_icon.dart';
import 'package:ufm/provider/facebookAuth.dart';
// import 'package:ufm/components/SocialMediaButtonLogin.dart';
import 'package:ufm/provider/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ufm/components/form_error.dart';
import 'package:ufm/constants.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  bool _isLoading = false;
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();
  FacebookAuthController facebookAuth = new FacebookAuthController();
  bool isAuth = false;
  bool _checkbox = false;
  var userData;
  var user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email;
  String password;

  Future deconnect() async {
    setState(() {
      isAuth = false;
    });
  }

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
    Future.delayed(const Duration(milliseconds: 1500), () {
// Here you can write your code
      setState(() {
        _isLoading = true;
        // Here you can write your code for open new view
      });
    });
  }

  final FirebaseAuth authEmail = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {
    UserCredential result = await authEmail.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    // final User currentUser = await autEmail.currentUser();
    final User currentUser = await authEmail.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<User> handleSignUp(email, password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
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
    return Scaffold(
      backgroundColor: _isLoading ? Color(0xFFFFEB3B) : Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: SvgPicture.asset(
        //     'assets/icons/back.svg',
        //     height: 15,
        //     width: 15,
        //   ),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        actions: [
          // IconButton(
          //     icon: SvgPicture.asset(
          //       'assets/icons/menu.svg',
          //       height: 15,
          //       width: 15,
          //     ),
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/detail');
          //     }),
        ],
      ),
      body: _isLoading
          ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isAuth == false
                        ? Container(
                            margin: EdgeInsets.only(top: 30),
                            height: size.height,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100))),
                            child: Column(
                              children: [
                                // Login(),

                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 30.0, bottom: 30.0),
                                  child: Text(
                                    "Se connecter",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 50.0,
                                  ),
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (newValue) => email = newValue,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        removeError(error: kEmailNullError);
                                      } else if (emailValidatorRegExp
                                          .hasMatch(value)) {
                                        removeError(error: kInvalidEmailError);
                                      }
                                      return null;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        addError(error: kEmailNullError);
                                        return "";
                                      } else if (!emailValidatorRegExp
                                          .hasMatch(value)) {
                                        addError(error: kInvalidEmailError);
                                        return "";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      // labelText: "Email",
                                      hintText: "Email",
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      suffixIcon: CustomSurffixIcon(
                                          svgIcon: "assets/icons/Mail.svg"),
                                    ),
                                  ),
                                  // child: TextFormField(
                                  //   keyboardType: TextInputType.emailAddress,
                                  //   controller: emailController,
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Email',
                                  //   ),
                                  //   validator: (value) {
                                  //     if (value.isEmpty) {
                                  //       return "Veuillez entrez votre adresse email l'email";
                                  //     }
                                  //     return null;
                                  //   },
                                  // ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 50.0,
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    onSaved: (newValue) => password = newValue,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        removeError(error: kPassNullError);
                                      } else if (value.length >= 8) {
                                        removeError(error: kShortPassError);
                                      }
                                      return null;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        addError(error: kPassNullError);
                                        return "";
                                      } else if (value.length != 4) {
                                        addError(error: kShortPassError);
                                        return "";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      // labelText: "Email",
                                      hintText: "Mot de  passe",
                                      // If  you are using latest version of flutter then lable text and hint text shown like this
                                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      suffixIcon: CustomSurffixIcon(
                                          svgIcon: "assets/icons/Lock.svg"),
                                    ),
                                  ),
                                ),
                                FormError(errors: errors),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 16.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Toast.show(
                                          " Bientôt disponible En attendant connectez-vous avec Google",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    },
                                    child: new Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Color(0xFFFFEB3B),
                                      ),
                                      width: 220.0,
                                      padding: new EdgeInsets.all(15.0),
                                      child: new Column(children: [
                                        new Text(
                                          "Connexion",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  if (_checkbox == false) {
                                                    Toast.show(
                                                        "Veuillez accepter les Termes & Conditions ",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                  } else {
                                                    Toast.show(
                                                        " Bientôt disponible En attendant connectez-vous avec Google",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                    // pr.show();
                                                    // await facebookAuth.auth();
                                                    // pr.hide();
                                                    // checkUser();
                                                  }
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
                                                  if (_checkbox == false) {
                                                    Toast.show(
                                                        "Veuillez accepter les Termes & Conditions ",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                  } else {
                                                    pr.show();
                                                    await googleAuth.login();
                                                    pr.hide();
                                                    checkUser();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: _checkbox,
                                            onChanged: (value) {
                                              setState(() {
                                                _checkbox = !_checkbox;
                                              });
                                            },
                                          ),
                                          RichText(
                                            text: new TextSpan(
                                              children: [
                                                new TextSpan(
                                                  text: "J' accepte les ",
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                ),
                                                new TextSpan(
                                                  text: 'Termes & Conditions ',
                                                  style: new TextStyle(
                                                      color: Colors.blue),
                                                  recognizer:
                                                      new TapGestureRecognizer()
                                                        ..onTap = () {
                                                          launch(
                                                              'https://privacy-cgzea7esf.vercel.app/');
                                                        },
                                                ),
                                                TextSpan(
                                                  text: " d'UFM",
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: size.width,
                            padding: EdgeInsets.all(30),
                            height: size.height,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(100))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text("Mon Profil"),
                                ),
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      "${userData.photoURL}?height=500"),
                                  // NetworkImage(""),

                                  radius: 60,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(userData.displayName),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  // child: Text(userData.email),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        deconnect();
                                        googleAuth.logout();
                                        facebookAuth.logOut();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF19232F),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 41,
                                        width: 239,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Se déconnecter",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Container(
                                                child: SvgPicture.asset(
                                                  "assets/icons/share-arrow.svg",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ]),
            )
          : Center(
              child: SpinKitRipple(
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
            ),
    );
  }
}

Widget formulaire(size) {
  return Container(
    width: size.width,
    padding: EdgeInsets.symmetric(vertical: 60),
    child: Column(
      children: [
        Text(
          "S'inscrire",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SingUp(),
      ],
    ),
  );
}
