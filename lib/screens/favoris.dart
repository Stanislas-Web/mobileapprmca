import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:ufm/provider/google_sign_in.dart';
import 'package:ufm/screens/detailpodcast.dart';
import 'package:ufm/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ufm/components/form_error.dart';
import 'package:ufm/components/custom_surfix_icon.dart';
import 'package:ufm/constants.dart';

class Favoris extends StatefulWidget {
  Favoris({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FavorisState createState() => _FavorisState();
}

class _FavorisState extends State<Favoris> {
  bool checkData = false;
  List data;
  bool loading = false;
  var user = FirebaseAuth.instance.currentUser;

  final myController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final List<String> errors = [];
  String email;
  String password;
  bool _checkbox = false;
  bool isAuth = false;
  var userData;
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> deleteFavoris(String id) async {
    await FirebaseFirestore.instance.collection("favorites").doc(id).delete();
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
    return user == null
        ? Scaffold(
            // backgroundColor: _isLoading ? Color(0xFFFFEB3B) : Colors.white,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/back.svg',
                  height: 15,
                  width: 15,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
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
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                                  borderRadius: BorderRadius.circular(30.0),
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
                                            if (_checkbox == false) {
                                              Toast.show(
                                                  "Veuillez accepter les Termes & Conditions ",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
                                                  gravity: Toast.BOTTOM);
                                            } else {
                                              Toast.show(
                                                  " Bientôt disponible En attendant connectez-vous avec Google",
                                                  context,
                                                  duration: Toast.LENGTH_LONG,
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
                                                  duration: Toast.LENGTH_LONG,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                  ]),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
            ),
            // drawer: drawerMenu(context, size),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('favorites')
                  .where('userId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  children: snapshot.data.docs.map((doc) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MusicApp(
                            nom: doc['nomEmission'],
                            description: doc['description'],
                            image: doc['image'],
                            streamUrl: doc['streamUrl'],
                            duree: doc['durée'],
                          ),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenWidth(5),
                          horizontal: getProportionateScreenWidth(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    height: 80,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: doc['image'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    // width: 160,
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doc['description'].length > 20
                                              ? '${doc['description'].substring(0, 20)} ...'
                                              : doc['description'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                color: Colors.black,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10)),
                                        Text(
                                          doc['durée'] + " minutes",
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //text podcast
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        // left: MediaQuery.of(context).size.width * 0.1,
                                        left: 0),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Colors.yellow,
                                          ),
                                          onPressed: () async {
                                            print(doc.id);
                                            await deleteFavoris(doc.id);
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            // : favoriSection(context),
            // favoriSection(context)
          );
  }
}
