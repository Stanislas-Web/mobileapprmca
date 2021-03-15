import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:ufm/components/playerPodcast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufm/provider/facebookAuth.dart';
import 'package:ufm/provider/google_sign_in.dart';
import 'package:ufm/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ufm/components/form_error.dart';
import 'package:ufm/constants.dart';
import 'package:ufm/components/custom_surfix_icon.dart';

class DetailEmission extends StatefulWidget {
  final String id, nom, image, description;
  DetailEmission({this.id, this.nom, this.image, this.description});

  @override
  _DetailEmissionState createState() => _DetailEmissionState();
}

class _DetailEmissionState extends State<DetailEmission> {
  final imgUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "";
  List data;
  bool _isLoading = false;
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();
  FacebookAuthController facebookAuth = new FacebookAuthController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email;
  String password;
  final List<String> errors = [];

  bool isAuth = false;
  var userData;
  var user;
  bool _checkbox = false;
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

  Future getHttp() async {
    var dio = Dio();
    var response = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/podcastsbyemission/" +
          widget.nom,
      // options: buildCacheOptions(Duration(days: 7)),
    );

    setState(() {
      data = response.data;
      _isLoading = true;
    });
    print(data);
  }

  Future<void> downloadFile(url) async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      await dio.download(
        url,
        "${dir.path}/podcast.mp3",
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            downloading = true;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "100 %";
    });
    print("Download completed");
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUser();
    super.initState();
    getHttp();
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
    return isAuth == false
        ? Scaffold(
            backgroundColor: _isLoading ? Color(0xFFFFEB3B) : Colors.white,
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
            body: _isLoading
                ? SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                        ]),
                  )
                : Center(
                    child: SpinKitRipple(
                      color: Theme.of(context).primaryColor,
                      size: 100,
                    ),
                  ),
          )
        : Scaffold(
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
            ),
            body: Container(
              child: Column(
                children: [
                  // isAuth == false
                  //     ?
                  // Container(
                  //     margin: EdgeInsets.only(top: 30),
                  //     height: size.height - getProportionateScreenWidth(90.5),
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius:
                  //             BorderRadius.only(topLeft: Radius.circular(100))),
                  //     child: Column(
                  //       children: [
                  //         // Login(),

                  //         Padding(
                  //           padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                  //           child: Text(
                  //             "Se connecter",
                  //             style: TextStyle(
                  //                 fontSize: 20, fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //             vertical: 10.0,
                  //             horizontal: 50.0,
                  //           ),
                  //           child: TextFormField(
                  //             decoration: InputDecoration(
                  //               hintText: 'Email',
                  //             ),
                  //             validator: (value) {
                  //               if (value.isEmpty) {
                  //                 return 'Please enter some text';
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //             vertical: 10.0,
                  //             horizontal: 50.0,
                  //           ),
                  //           child: TextFormField(
                  //             obscureText: true,
                  //             decoration: InputDecoration(
                  //               // suffixIcon:                       //     icon: SvgPicture.asset(
                  //               //   //       'assets/icons/play.svg',
                  //               //   //       height: 100,
                  //               //   //       width: 100,
                  //               //   //     ),
                  //               hintText: 'Mot de passe',
                  //             ),
                  //             validator: (value) {
                  //               if (value.isEmpty) {
                  //                 return 'Please enter some text';
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //             vertical: 16.0,
                  //             horizontal: 16.0,
                  //           ),
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               print("top");
                  //               // Validate returns true if the form is valid, or false
                  //               // otherwise.
                  //               // if (_formKey.currentState.validate()) {
                  //               //   // If the form is valid, display a Snackbar.
                  //               //   Scaffold.of(context).showSnackBar(SnackBar(
                  //               //       content: Text('Processing Data')));
                  //               // }
                  //             },
                  //             child: new Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(30.0),
                  //                 color: Color(0xFFFFEB3B),
                  //               ),
                  //               width: 220.0,
                  //               padding: new EdgeInsets.all(15.0),
                  //               child: new Column(children: [
                  //                 new Text(
                  //                   "Créer un compte",
                  //                   style: TextStyle(
                  //                     fontSize: 13,
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.w400,
                  //                   ),
                  //                 ),
                  //               ]),
                  //             ),
                  //           ),
                  //         ),
                  //         // SocialMediaButton(),
                  //         //SocialButton
                  //         Container(
                  //           child: Column(
                  //             children: [
                  //               Text("ou"),
                  //               Container(
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Padding(
                  //                       padding: EdgeInsets.all(20),
                  //                       child: IconButton(
                  //                         icon: SvgPicture.asset(
                  //                           'assets/icons/face.svg',
                  //                           height: 50,
                  //                           width: 50,
                  //                         ),
                  //                         onPressed: () async {
                  //                           pr.show();
                  //                           await facebookAuth.auth();
                  //                           pr.hide();
                  //                           checkUser();
                  //                         },
                  //                       ),
                  //                     ),
                  //                     Padding(
                  //                       padding: EdgeInsets.all(20),
                  //                       child: IconButton(
                  //                         icon: SvgPicture.asset(
                  //                           'assets/icons/google.svg',
                  //                           height: 50,
                  //                           width: 50,
                  //                         ),
                  //                         onPressed: () async {
                  //                           await googleAuth.login();
                  //                           // googleAuth.logout();
                  //                           checkUser();
                  //                           // print(auth);
                  //                           // print("google");
                  //                         },
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  // :
                  Container(
                    child: Stack(children: [
                      Container(
                        width: size.width,
                        height: size.height / 2 * 0.9,
                        decoration: new BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(widget.image),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  _isLoading
                      ? Expanded(
                          child: SingleChildScrollView(
                          child: Column(
                            children: [
                              contenuEmissionDetail(context, widget, data,
                                  downloadFile, progressString)
                            ],
                          ),
                        ))
                      // contenuEmissionDetail(
                      //     context, widget, data, downloadFile, progressString)
                      : Center(
                          child: SpinKitRipple(
                            color: Color(0xFFFFEB3B),
                            size: 100,
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}

Widget contenuEmissionDetail(
    context, widget, data, downloadFile, progressString) {
  return Container(
    padding: EdgeInsets.only(left: 30, right: 30),
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/likes.svg',
                  height: 22,
                  width: 22,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "12 456",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          widget.description,
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
                fontSize: 18,
                // letterSpacing: 1.0,
                height: 1.4,
                fontWeight: FontWeight.w300,
              ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          child: Row(
            children: [
              Text(
                "Episodes ",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              )
            ],
          ),
        ),
        contenuPodcast(widget, context, data, downloadFile, progressString),
        // contenuPodcast(arguments),
        // contenuPodcast(arguments),
        // contenuPodcast(arguments),
      ],
    ),
  );
}

Widget contenuPodcast(widget, context, data, downloadFile, progressString) {
  return Container(
    height: getProportionateScreenWidth(200),
    child: new ListView.builder(
      // scrollDirection: Axis.horizontal,
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                data[index]["photo"]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.7 / 2,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index]["description"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              data[index]["createdAt"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/ecoute1.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "128",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
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
              ),

              //podcast liste

              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: PlayerPodcast(streamUrl: data[index]['streamUrl']),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                    ),
                    // Text(progressString),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
