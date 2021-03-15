import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufm/components/Carousel.dart';
import 'package:ufm/components/FormSignUp.dart';
import 'package:ufm/components/Header.dart';
import 'package:ufm/components/RecentPodcast.dart';
import 'package:ufm/components/Emission.dart';
import 'package:ufm/components/Video.dart';

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFEB3B),
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
          IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 15,
                width: 15,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/detail');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100))),
            child: Column(
              children: [formulaire(size)],
            ),
          ),
        ]),
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
