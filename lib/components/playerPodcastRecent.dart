import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ufm/provider/player.dart';

class PlayerPodcastRecent extends StatefulWidget {
  final String streamUrl;
  PlayerPodcastRecent({this.streamUrl});

  @override
  _PlayerPodcastRecentState createState() => new _PlayerPodcastRecentState();
}

class _PlayerPodcastRecentState extends State<PlayerPodcastRecent> {
  PlayerProvider player = new PlayerProvider();
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
                player.stopPlayer();
                player.startPlayer(widget.streamUrl);
                // FlutterRadio.playOrPause(url: widget.streamUrl);
                // playingStatus();
                check = false;
              } else {
                check = true;
                player.stopPlayer();
                // FlutterRadio.playOrPause(url: widget.streamUrl);
                // playingStatus();
              }
            });
          },
          child: Container(
            child: SvgPicture.asset(
              check
                  ? 'assets/icons/btn-play.svg'
                  : 'assets/icons/btn-pause.svg',
              height: 71,
              width: 71,
            ),
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
