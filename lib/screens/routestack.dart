import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufm/screens/favoris.dart';
import 'package:ufm/screens/home.dart';
import 'package:ufm/screens/profil.dart';
import 'package:ufm/screens/recherche.dart';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:ufm/size_config.dart';
import 'package:ufm/components/Player.dart';

class RouteStack extends StatefulWidget {
  RouteStack({Key key, this.label}) : super(key: key);
  final String label;

  @override
  _RouteStackState createState() => _RouteStackState();
}

class _RouteStackState extends State<RouteStack> {
  int _selectedIndex = 0;
  PageController pageController = PageController();
  bool _tryAgain = false;
  bool connectState = false;
  SharedPreferences prefs;
  String theme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnection();
    initial();
  }

  void initial() async {
    setState(() {
      theme = prefs.getString('theme');
    });
    prefs ??= await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  Future checkConnection() async {
    try {
      setState(() {
        _tryAgain = true;
      });
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          connectState = true;
          setState(() {
            _tryAgain = false;
          });
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        connectState = false;
        _tryAgain = false;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _screens = [MyHomePage(), Recherche(), Profil(), Favoris()];

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return connectState == true
        ? Scaffold(
            backgroundColor: Color(0xFFFFFFFF),
            body: PageView(
              controller: pageController,
              onPageChanged: _onPageChanged,
              children: _screens,
              physics: NeverScrollableScrollPhysics(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xFF035887),
              // child: const Icon(Icons.add),
              child: Player(),
              onPressed: () {
                // Overlay.of(context).insert(entry);
              },
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0)),
              child: BottomAppBar(
                color: Color(0xFF035887),
                shape: CircularNotchedRectangle(),
                notchMargin: 4.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(0);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(10),
                            horizontal: getProportionateScreenWidth(30)),
                        child: Stack(children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: SvgPicture.asset(
                              'assets/icons/home.svg',
                              height: _selectedIndex == 0 ? 15.0 : 15,
                              width: _selectedIndex == 0 ? 15.0 : 15,
                              color: _selectedIndex == 0
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFFFFFFFF).withOpacity(.5),
                            ),
                          ),
                          _selectedIndex == 0
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: 60,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 1,
                                  width: 1,
                                )
                        ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onItemTapped(1);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(10),
                            horizontal: getProportionateScreenWidth(30)),
                        child: Stack(children: [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: SvgPicture.asset(
                              'assets/icons/recherche.svg',
                              height: _selectedIndex == 0 ? 15.0 : 15,
                              width: _selectedIndex == 0 ? 15.0 : 15,
                              color: _selectedIndex == 1
                                  ? Color(0xFFFFFFFF)
                                  : Color(0xFFFFFFFF).withOpacity(.5),
                            ),
                          ),
                          _selectedIndex == 1
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    width: 60,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 1,
                                  width: 1,
                                )
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : _tryAgain == true
            ? Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: SpinKitRipple(
                    color: Color(0xFF035887),
                    size: 100,
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkConnection();
                          Toast.show(
                              "vérifiez votre connexion internet ", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        },
                        child: Column(
                          children: [
                            Image(
                                image: AssetImage(
                                  'assets/images/pasconnection.png',
                                ),
                                width: getProportionateScreenWidth(100),
                                height: getProportionateScreenWidth(100)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(
                                  (20),
                                ),
                              ),
                              child: Text(
                                "Réseau mobile ou Wifi non détecté.Cliquez sur le Bouton pour Actualiser ",
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(17),
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(30),
                            ),
                            Container(
                              height: getProportionateScreenWidth(50),
                              width: getProportionateScreenWidth(200),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    getProportionateScreenWidth(30),
                                  ),
                                  border: Border.all(color: Colors.yellow)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Actualiser",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontSize: getProportionateScreenWidth(10),
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
              );
  }
}
