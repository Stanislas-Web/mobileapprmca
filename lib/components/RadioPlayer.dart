import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';

class RadioPlayer extends StatefulWidget {
  @override
  _RadioPlayerState createState() => new _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> {
  String url = "https://www.radioking.com/play/urbain-fm";

  @override
  void initState() {
    super.initState();
    audioStart();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        FlatButton(
          child: Icon(Icons.play_circle_filled),
          onPressed: () => FlutterRadio.play(url: url),
        ),
        FlatButton(
          child: Icon(Icons.pause_circle_filled),
          onPressed: () => FlutterRadio.pause(url: url),
        )
      ],
    ));
  }
}
