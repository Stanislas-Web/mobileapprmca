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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF035887),
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              height: 15,
              width: 15,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Stack(children: [
                Container(
                  width: size.width,
                  height: size.height / 2 * 0.7,
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
                    height: 30,
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
                    child: Container(
                      child: Column(
                        children: [
                          contenuEmissionDetail(context, widget, data,
                              downloadFile, progressString)
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: SpinKitRipple(
                      color: Color(0xFF035887),
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
    // height: defaultHeight(),
    // height: getProportionateScreenHeight(400),
    child: Column(
      children: [
        Text(
          widget.description.length > 60
              ? '${widget.description.substring(0, 60)} ...'
              : widget.description['description'],
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: Colors.black,
                fontSize: 15,
                // letterSpacing: 1.0,
                height: 1.4,
                fontWeight: FontWeight.w300,
              ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
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
      ],
    ),
  );
}

Widget contenuPodcast(widget, context, data, downloadFile, progressString) {
  return Container(
    height: getProportionateScreenWidth(300),
    child: new ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(
              top: getProportionateScreenHeight(10), bottom: 24),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index]["description"].length > 30
                                ? '${data[index]["description"].substring(0, 30)} ...'
                                : data[index]["description"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              data[index]["createdAt"],
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
