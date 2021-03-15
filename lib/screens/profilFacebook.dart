import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FacebookProfil extends StatefulWidget {
  FacebookProfil({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FacebookProfilState createState() => _FacebookProfilState();
}

class _FacebookProfilState extends State<FacebookProfil> {
  @override
  Widget build(BuildContext context) {
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
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
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 15,
                width: 15,
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.only(top: 60),
                  width: 370,
                  height: 370,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      // image: AssetImage(arguments['image']),
                      image: AssetImage('assets/images/affiche1.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              // Header(),
              // RecentPodcast(),
              // Emission(),
              // Video(),
            ]),
      ),
    );
  }
}
