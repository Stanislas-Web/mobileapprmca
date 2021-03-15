import 'package:flutter/material.dart';
import 'package:ufm/size_config.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen({this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/back.svg',
              height: getProportionateScreenWidth(15),
              width: getProportionateScreenWidth(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [],
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          aspectRatio: 16 / 9,
          onReady: () {
            print('Player is ready.');
          },
        ),
      ),
    );
  }
}
