import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PlayerPodcast extends StatefulWidget {
  final String streamUrl;
  PlayerPodcast({this.streamUrl});

  @override
  _PlayerPodcastState createState() => new _PlayerPodcastState();
}

class _PlayerPodcastState extends State<PlayerPodcast> {
  bool check = true;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
    print("Musique " + widget.streamUrl);
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
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
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () {
              pr.show();
              Future.delayed(const Duration(milliseconds: 2000), () {
                pr.hide();
              });
              setState(() {
                if (check) {
                  FlutterRadio.playOrPause(url: widget.streamUrl);
                  playingStatus();
                  check = false;
                } else {
                  check = true;
                  FlutterRadio.playOrPause(url: widget.streamUrl);
                  playingStatus();
                }
              });
            },
            child: check
                ? Icon(
                    Icons.play_circle_filled_outlined,
                    size: 50,
                    color: Color(0xFF0083CC),
                  )
                : Icon(
                    Icons.pause_circle_filled_outlined,
                    size: 50,
                    color: Color(0xFF0083CC),
                  )
            // child: SvgPicture.asset(
            //   check ? 'assets/icons/btn-play.svg' : 'assets/icons/btn-pause.svg',
            //   height: 60,
            //   width: 60,
            // ),
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
