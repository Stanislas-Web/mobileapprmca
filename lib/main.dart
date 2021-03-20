import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ufm/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:ufm/provider/download_provider.dart';
import 'package:ufm/screens/detailpodcast.dart';
import 'package:ufm/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => FileDownloaderProvider(),
                child: MusicApp(),
              ),
            ],
            child: GetMaterialApp(
              title: 'RMCA',
              debugShowCheckedModeBanner: false,
              theme: notifier.darkTheme ? dark : light,
              routes: Routes().routes,
              initialRoute: '/splash',
            ),
          );
        },
      ),
    );

    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (context) => FileDownloaderProvider(),
    //       child: MusicApp(),
    //     ),
    //   ],
    //   child: GetMaterialApp(
    //     title: 'RMCA',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       primarySwatch: MyColors.navy,
    //       // visualDensity: VisualDensity.adaptivePlatformDensity,
    //     ),
    //     routes: Routes().routes,
    //     initialRoute: '/splash',
    //   ),
    // );
  }
}

class MyColors {
  static const MaterialColor navy = MaterialColor(
    // 0xFF039BE5,
    0xFF0083CC,
    // 0xFFF2E307,
    <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81DAFA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(0xFF03A9F4),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    },
  );
}
