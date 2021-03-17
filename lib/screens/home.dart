import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:ufm/components/Header.dart';
import 'package:ufm/components/RecentPodcast.dart';
import 'package:ufm/components/Emission.dart';
import 'package:ufm/provider/facebookAuth.dart';
import 'package:ufm/provider/google_sign_in.dart';
import 'package:ufm/screens/video.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animator/animator.dart';
import '../size_config.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _controller;
  List<CachedNetworkImage> _imgs = List<CachedNetworkImage>();
  @override
  bool get wantKeepAlive => true;
  bool _isLoading = false;
  bool positionIcon = false;
  List data;
  List podcast;
  List banniere;
  GoogleSignInProvider googleAuth = new GoogleSignInProvider();
  FacebookAuthController facebookAuth = new FacebookAuthController();
  bool isAuth = false;
  var userData;
  var user;
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

  Future _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        // message = "reach the bottom";
        positionIcon = false;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        // message = "reach the top";
        positionIcon = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkUser();
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getHttp();
  }

  Future getHttp() async {
    var dio = Dio();
    var response = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/emissions",
      options: buildCacheOptions(Duration(days: 7)),
    );

    var dataPodcast = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/podcastsRecents",
      options: buildCacheOptions(Duration(days: 7)),
    );

    var dataBanniere = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/bannieres",
      options: buildCacheOptions(Duration(days: 7)),
    );

    var images = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/bannieres",
      options: buildCacheOptions(Duration(days: 7)),
    );

    setState(() {
      data = response.data;
      podcast = dataPodcast.data;
      banniere = dataBanniere.data;
      _isLoading = true;
      images.data.forEach((urlBannier) {
        // _imgs.add(CachedNetworkImage(
        //   imageUrl: urlBannier['urlBannier'],
        //   placeholder: (context, url) => CircularProgressIndicator(),
        //   errorWidget: (context, url, error) => Icon(Icons.error),

        //   // height: 150.0,
        //   // width: 150.0,
        // ));

        _imgs.add(
          CachedNetworkImage(
            imageUrl: urlBannier['urlBannier'],
            imageBuilder: (context, imageProvider) => Container(
              // width: 80.0,
              // height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
        // _imgs.add(NetworkImage(urlBannier['urlBannier']));
        // _imgs.add(urlBannier["urlBannier"]);
      });
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // drawerEdgeDragWidth: 0,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:Color(0xFF035887),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: getProportionateScreenWidth(15),
                width: getProportionateScreenWidth(15),
                color: Colors.white,
              ),
              onPressed: () {
                print("top top");
                checkUser();
                _scaffoldKey.currentState.openDrawer();
              }),
        ],
      ),
      // floatingActionButton: positionIcon
      //     ? null
      //     : FloatingActionButton.extended(
      //         onPressed: () {
      //           // Add your onPressed code here!
      //         },
      //         label: Text('Radio Urbain FM'),
      //         icon: Icon(Icons.play_circle_filled),
      //         backgroundColor: Color(0xFFFFEB3B),
      //       ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      // drawer: Drawer(),
      drawer: drawerMenu(context, size, _launchURL, isAuth, userData,
          googleAuth, deconnect, facebookAuth),
      body: _isLoading
          ?
          // SingleChildScrollView(
          //     controller: _controller,
          //     physics: ScrollPhysics(),
          //     child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(data: _imgs),
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _controller,
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        RecentPodcast(data: podcast),
                        Emission(data: data),
                        // Video(),
                        VideoHome(),
                      ],
                    ),
                  ),
                ),
              ],
            ):
          // )
          // : Container(
          //     height: MediaQuery.of(context).size.height,
          //     color: Color(0xFFFFFFFF),
          //     child: Animator<double>(
          //       duration: Duration(seconds: 1),
          //       tween: Tween<double>(begin: 0, end: 150),
          //       cycles: 0,
          //       builder: (context, animatorState, child) => Center(
          //         child: Container(
          //           margin: EdgeInsets.symmetric(vertical: 10),
          //           height: animatorState.value,
          //           width: animatorState.value,
          //           child: Image(
          //             image: AssetImage('assets/images/logo1.png'),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
      Center(
          child: SpinKitRipple(
            color: Color(0xFF035887),
            size: 100,
          ),
        ),
    );
  }
}

Widget drawerMenu(context, size, _launchURL, isAuth, userData, googleAuth,
    deconnect, facebookAuth) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            bottom: getProportionateScreenWidth(20),
          ),
          height: getProportionateScreenWidth(150),
          decoration: BoxDecoration(
              color: Color(0xFFFFEB3B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  getProportionateScreenWidth(30),
                ),
              )),
          child: Column(
            children: [
              isAuth == false
                  ? Container()
                  : Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                            vertical: 30),
                        child: Container(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    userData.photoURL),
                                radius: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(10),
                                ),
                              ),
                              Text(
                                userData.displayName,
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
          ),
          padding: EdgeInsets.only(
            top: getProportionateScreenWidth(20),
            left: getProportionateScreenWidth(10),
          ),
          height: size.height,
          decoration: BoxDecoration(
            color: Color(0xFFdadada).withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                getProportionateScreenWidth(30),
              ),
            ),
          ),
          child: Column(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/site.svg",
                  width: 30,
                  height: getProportionateScreenWidth(20),
                ),
                title: new Text(
                  'Site Web',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () async {
                  const url = 'http://u947.fm/';
                  await _launchURL(url);
                },
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/note.svg",
                  width: getProportionateScreenWidth(20),
                  height: getProportionateScreenWidth(20),
                ),
                title: new Text(
                  "Noter l'application",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Toast.show(
                      "Noter l'application bientôt disponible  ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/page.svg",
                  width: getProportionateScreenWidth(20),
                  height: getProportionateScreenWidth(20),
                ),
                title: new Text(
                  'Notre page facebook',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () async {
                  const url = 'https://web.facebook.com/947UFM/?_rdc=1&_rdr';
                  await _launchURL(url);
                },
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/apropos.svg",
                  width: getProportionateScreenWidth(20),
                  height: getProportionateScreenWidth(20),
                ),
                title: new Text(
                  'A propos',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Toast.show(
                      "A propos de l'application bientôt disponible ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/parametre.svg",
                  width: getProportionateScreenWidth(20),
                  height: getProportionateScreenWidth(20),
                ),
                title: new Text(
                  'Paramètre',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Toast.show(
                      "Paramètre de l'application bientôt disponible ", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
              ),
              isAuth == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(20),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () async {
                            await googleAuth.logout();
                            facebookAuth.logOut();
                            deconnect();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF19232F),
                              borderRadius: BorderRadius.circular(
                                getProportionateScreenWidth(20),
                              ),
                            ),
                            height: 41,
                            width: 239,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Se déconnecter",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Container(
                                    child: SvgPicture.asset(
                                      "assets/icons/share-arrow.svg",
                                      width: getProportionateScreenWidth(20),
                                      height: getProportionateScreenWidth(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    ),
  );
}
