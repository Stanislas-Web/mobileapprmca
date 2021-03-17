import 'package:flutter/material.dart';
import 'package:ufm/components/FormLogin.dart';
import 'package:ufm/screens/VideoComponent.dart';
import 'package:ufm/screens/detail.dart';
import 'package:ufm/screens/detailpodcast.dart';
import 'package:ufm/screens/favoris.dart';
import 'package:ufm/screens/profilFacebook.dart';
import 'package:ufm/screens/recherche.dart';
import 'package:ufm/screens/home.dart';
import 'package:ufm/screens/routestack.dart';
import 'package:ufm/screens/video.dart';
import 'package:ufm/screens/detailemission.dart';
import 'package:ufm/screens/splash.dart';

class Routes {
  Map<String, WidgetBuilder> routes = {
    '/detail': (context) => Detail(),
    '/recherche': (context) => Recherche(),
    '/favoris': (context) => Favoris(),
    '/home': (context) => MyHomePage(),
    '/stack': (context) => RouteStack(),
    '/login': (context) => Login(),
    '/profilfacebook': (context) => FacebookProfil(),
    '/video': (context) => VideoHome(),
    '/listevideo': (context) => VideoScreen(),
    '/detailemission': (context) => DetailEmission(),
    '/musiqueapp': (context) => MusicApp(),
    '/splash': (context) => Splash(),
  };
}
