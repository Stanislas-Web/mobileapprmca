import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufm/components/FormLogin.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _spinnerState();
    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code

      setState(() {
        _isLoading = true;
        // Here you can write your code for open new view
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFFEB3B),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //     icon: SvgPicture.asset(
          //       'assets/icons/menu.svg',
          //       height: 15,
          //       width: 15,
          //     ),
          //     onPressed: () {
          //       print("top");
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
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(100))),
                      child: Column(
                        children: [formulaire(size)],
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
    // width: size.width,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        Text(
          "Se connecter",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Login(),
      ],
    ),
  );
}
