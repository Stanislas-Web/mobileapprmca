import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:ufm/provider/player.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => new _PlayerState();
}

class _PlayerState extends State<Player> {
  PlayerProvider player = new PlayerProvider();
  static const streamUrl = "http://edge.iono.fm/xice/142_medium.aac";

  bool check = true;

  bool isPlaying = false;
  bool _tryAgain = false;
  bool connectState = false;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
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
        // setState(() {
        //   _tryAgain = false;
        // });
      });
    }
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
          color: Color(0xFF0083CC),
          fontSize: 13.0,
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w300),
    );
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            // Future checkConnection() async {
            try {
              setState(() {
                _tryAgain = true;
              });
              final result = await InternetAddress.lookup('google.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                print('connected');
                pr.show();
                Future.delayed(const Duration(milliseconds: 2000), () {
                  pr.hide();
                });
                setState(() {
                  if (check) {
                    player.startPlayer(streamUrl);
                    check = false;
                  } else {
                    check = true;

                    player.stopPlayer();
                  }
                });
                setState(() {
                  connectState = true;
                  setState(() {
                    _tryAgain = false;
                  });
                });
              }
            } on SocketException catch (_) {
              print('not connected');
              Toast.show("vérifiez votre connexion internet ", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              setState(() {
                connectState = false;
                _tryAgain = false;
                // setState(() {
                //   _tryAgain = false;
                // });
              });
            }
            // }
          },
          child: Padding(
            padding: EdgeInsets.only(top:8,left: 5,right: 5,bottom: 5),
            child: check?Icon(Icons.play_arrow_rounded ,size: 40,color: Colors.white,): Icon(Icons.pause,size: 40,color: Colors.white,),
            // padding: EdgeInsets.all(2),
            // child: SvgPicture.asset(
            //   check
            //       ? 'assets/icons/playcircular.svg'
            //       : 'assets/icons/stopcircular.svg',
            //   height: 40,
            //   width: 30,
            // ),
          ),
        ),
      ],
    );
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }
}
