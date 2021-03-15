import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';

class PlayerProvider extends ChangeNotifier {
  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  Future startPlayer(url) async {
    await FlutterRadio.play(url: url);
  }

  Future stopPlayer() async {
    await FlutterRadio.stop();
  }
}
