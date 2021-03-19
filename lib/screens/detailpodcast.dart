// import 'dart:io';
// import 'dart:typed_data';

import 'dart:io';
import 'dart:ui' as prefix0;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:ufm/screens/album_record_play_animation.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:ufm/provider/player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:ufm/provider/download_provider.dart';
import 'package:ufm/size_config.dart';

class MusicApp extends StatefulWidget {
  final String nom, image, streamUrl, description, duree;
  MusicApp(
      {this.nom, this.image, this.streamUrl, this.description, this.duree});
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SequenceAnimation _sequenceAnimation;
  bool _animated = false;
  bool _favoriteState = false;
  bool _minimized = false;
  bool _playPauseButton = false;
  double _screenWidth, _screenHeight, _bottomNavigationBarHeight;
  PlayerProvider playerProvider = new PlayerProvider();
  SharedPreferences loginData;
  final databaseReference = FirebaseFirestore.instance;
  Duration _duration = new Duration();
  Duration _position = new Duration();

  bool playing = false;
  // Uyulama release modunda başlarken (apk build edildikten sonra)
  // çok hızlı başladığı için size değerleri 0.0 oluyor. Bunu önlemek için
  // size 0.0 olmayana kadar çalıştırıyoruz.
  _recursiveZeroCheck(_size) {
    if (_size > 0) {
      return _size;
    } else {
      _recursiveZeroCheck(_size);
    }
  }

  // Future<File> _downloadFile() async {
  //   print("debut");
  //   var fileName = widget.nom;
  //   http.Client client = new http.Client();
  //   var req = await client.get(Uri.parse(widget.streamUrl));
  //   var bytes = req.bodyBytes;
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File('$dir/$fileName');
  //   await file.writeAsBytes(bytes);
  //   return file;
  // }

  Future<void> checkFavoriteExist() async {
    final QuerySnapshot snapShot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('streamUrl', isEqualTo: widget.streamUrl)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = snapShot.docs;

    if (documents.length == 1) {
      setState(() {
        _favoriteState = !_favoriteState;
      });
    } else {
      setState(() {
        _favoriteState = false;
      });
    }
  }

  Future<void> createFavorite() async {
    final QuerySnapshot snapShot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('streamUrl', isEqualTo: widget.streamUrl)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = snapShot.docs;

    if (documents.length == 1) {
      Toast.show("Le podcast existe déjà dans les favoris", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Le podcast ajouté aux favoris avec succès", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      var user = FirebaseAuth.instance.currentUser;
      DocumentReference ref =
          await databaseReference.collection("favorites").add({
        'nomEmission': widget.nom,
        'image': widget.image,
        'streamUrl': widget.streamUrl,
        'description': widget.description,
        'durée': widget.duree,
        'userId': user.uid,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      print(ref.id);
    }
  }

  @override
  void initState() {
    super.initState();

    _screenWidth = _recursiveZeroCheck(
        MediaQueryData.fromWindow(prefix0.window).size.width);
    _screenHeight = _recursiveZeroCheck(
        MediaQueryData.fromWindow(prefix0.window).size.height);

    // Bottom Navigation Bar Height
    _bottomNavigationBarHeight = 40;

    // -- Animation Positions and Size --
    // Round Container
    double _roundContainerWidthSize = _screenWidth * 0.93;
    double _roundContainerHeightSize = _screenHeight * 0.11;

    Offset _roundContainerPosition =
        Offset(0, ((_screenHeight * 0.40) - (_bottomNavigationBarHeight / 2)));
    BorderRadius _roundContainerBorderRadius = BorderRadius.circular(100);

    // Song Name
    Offset _songNameEndPosition =
        Offset(-(_screenWidth * 0.02), _screenHeight * 0.78);
    Offset _songNameStartPosition = Offset(0, _screenHeight * 0.50);
    double _songNameStartFontSize = 23;
    double _songNameEndFontSize = 18;

    _controller = AnimationController(vsync: this);
    _sequenceAnimation = SequenceAnimationBuilder()
        // RoundContainerWidth
        .addAnimatable(
            animatable: Tween<double>(
              begin: _screenWidth,
              end: _roundContainerWidthSize,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'RoundContainerWidth')
        // RoundContainerHeight
        .addAnimatable(
            animatable: Tween<double>(
              begin: _screenHeight,
              end: _roundContainerHeightSize,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'RoundContainerHeight')
        // RoundContainerPosition
        .addAnimatable(
            animatable: Tween<Offset>(
              begin: Offset(0, 0),
              end: _roundContainerPosition,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'RoundContainerPosition')
        // RoundContainerBorderRadius
        .addAnimatable(
            animatable: BorderRadiusTween(
              begin: BorderRadius.circular(0),
              end: _roundContainerBorderRadius,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'RoundContainerBorderRadius')
        // Album Cover Position
        .addAnimatable(
            animatable: Tween<double>(
              begin: -100,
              end: 400,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'AlbumCoverPosition')
        // Second Area Opacity
        .addAnimatable(
            animatable: Tween<double>(
              begin: 1,
              end: 0,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 100),
            tag: 'SecondAreaOpacity')
        // Song Name Position
        .addAnimatable(
            animatable: Tween<Offset>(
              begin: _songNameStartPosition,
              end: _songNameEndPosition,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'SongNamePosition')
        // Song Name Font Size
        .addAnimatable(
            animatable: Tween<double>(
              begin: _songNameStartFontSize,
              end: _songNameEndFontSize,
            ),
            from: Duration(milliseconds: 0),
            to: Duration(milliseconds: 300),
            tag: 'SongNameFontSize')
        // Minimize Play/Pause Button Opacity
        .addAnimatable(
            animatable: Tween<double>(
              begin: 0,
              end: 1,
            ),
            from: Duration(milliseconds: 300),
            to: Duration(milliseconds: 400),
            tag: 'MinimizeButtonOpacity')
        .animate(_controller);
    checkFavoriteExist();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: false);
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
    // Appbar
    AppBar appbar = AppBar(
      elevation: 0,
      backgroundColor: Color(0xFF035887),
      centerTitle: true,
      title: Text(widget.nom),
      leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back.svg',
            height: 15,
            width: 15,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
    );

    double appbarHeightSize = appbar.preferredSize.height;

    return Scaffold(
      appBar: appbar,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget child) {
            return Container(
              color: Color(0xFFFFEB3B),
              child: Stack(
                children: <Widget>[
                  // Rounded Container
                  AlignPositioned(
                    dx: _sequenceAnimation['RoundContainerPosition'].value.dx,
                    dy: _sequenceAnimation['RoundContainerPosition'].value.dy,
                    child: Container(
                      width: _sequenceAnimation['RoundContainerWidth'].value,
                      height: _sequenceAnimation['RoundContainerHeight'].value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            _sequenceAnimation['RoundContainerBorderRadius']
                                .value,
                      ),
                    ),
                  ),
                  // Album-Vinlyn Area
                  Positioned(
                    // dx: _sequenceAnimation['AlbumCoverPosition'].value.dx,
                    // dy: _sequenceAnimation['AlbumCoverPosition'].value.dy,
                    left: ((_sequenceAnimation['AlbumCoverPosition'].value +
                            100) *
                        -0.27),
                    bottom:
                        (280 - _sequenceAnimation['AlbumCoverPosition'].value),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: (_screenHeight * 0.50 - appbarHeightSize),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AlbumRecordPlayAnimation(
                                image: widget.image,
                                animated: _animated,
                                minimized: _minimized,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Second Area - ( Button and Name Area)
                  AlignPositioned(
                    dx: _sequenceAnimation['SongNamePosition'].value.dx,
                    dy: _sequenceAnimation['SongNamePosition']
                        .value
                        .dy, //screenHeight * 0.50 - appbarHeightSize,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: (_screenHeight * 0.40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              // Song Name Area
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // Song Name
                                    Text(
                                      widget.nom,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _sequenceAnimation[
                                                'SongNameFontSize']
                                            .value,
                                        color: Color(0xff342844),
                                      ),
                                    ),
                                    SizedBox(height: 7.0),
                                    // Singer Name

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            getProportionateScreenWidth(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.description,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Button Area
                              Opacity(
                                opacity: _sequenceAnimation['SecondAreaOpacity']
                                    .value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(width: 15),
                                    IconButton(
                                      iconSize: 25,
                                      color: Color(0xff342844),
                                      icon: Icon(Icons.share),
                                      onPressed: () async {
                                        Share.text(widget.description,
                                            widget.streamUrl, 'text/plain');
                                      },
                                    ),
                                    // IconButton(
                                    //   iconSize: 25,
                                    //   color: Color(0xff342844),
                                    //   icon: Icon(Icons.folder_open),
                                    //   onPressed: () {},
                                    // ),
                                    IconButton(
                                      iconSize: 25,
                                      color: Color(0xff342844),
                                      icon: Icon(Icons.file_download),
                                      onPressed: () {
                                        // var nameEmission = widget.nom;
                                        fileDownloaderProvider
                                            .downloadFile(widget.streamUrl,
                                                widget.description)
                                            .then((onValue) {});
                                        downloadProgress();
                                        // _downloadFile();
                                        // print("object");
                                      },
                                    ),
                                    // IconButton(
                                    //   iconSize: 25,
                                    //   color: Color(0xff342844),
                                    //   icon: Icon(Icons.repeat),
                                    //   onPressed: () {},
                                    // ),
                                    IconButton(
                                      iconSize: 25,
                                      color: _favoriteState
                                          ? Color(0xFF035887)
                                          : Color(0xff342844),
                                      icon: Icon(_favoriteState
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      onPressed: () {
                                        print("favoris");

                                        setState(() {
                                          _favoriteState = !_favoriteState;
                                          createFavorite();
                                        });
                                      },
                                    ),
                                    SizedBox(width: 15),
                                  ],
                                ),
                              ),

                              // slider
                              // slider(),
                              Slider.adaptive(
                                onChanged: (double value) {
                                  // setState(() {
                                  //   audioPlayer
                                  //       .seek(Duration(seconds: value.toInt()));
                                  // });
                                },
                                min: 0.0,
                                max: _duration.inSeconds.toDouble(),
                                value: _position.inSeconds.toDouble(),
                              ),
                              // Slider Area
                              // Opacity(
                              //   opacity: _sequenceAnimation['SecondAreaOpacity']
                              //       .value,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: <Widget>[
                              //       SizedBox(width: 15),
                              //       Text(
                              //         '01:30',
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //           fontSize: 13,
                              //         ),
                              //       ),
                              //       SliderTheme(
                              //         data: Theme.of(context)
                              //             .sliderTheme
                              //             .copyWith(
                              //               trackHeight: 2,
                              //               activeTrackColor: Color(0xFFFFEB3B),
                              //               inactiveTrackColor:
                              //                   Color(0xffDCDBDC),
                              //               thumbColor: Colors.yellow,
                              //               thumbShape: RoundSliderThumbShape(
                              //                   enabledThumbRadius: 5,
                              //                   disabledThumbRadius: 8),
                              //               overlayShape: RoundSliderThumbShape(
                              //                   enabledThumbRadius: 7,
                              //                   disabledThumbRadius: 8),
                              //             ),
                              //         child: Container(
                              //           width: _screenWidth * 0.75 - 30,
                              //           child: Slider(
                              //             value: 0.5,
                              //             onChanged: (newSliderValue) {},
                              //           ),
                              //         ),
                              //       ),
                              //       Text(
                              //         '04:05',
                              //         style: TextStyle(
                              //           color: Colors.grey,
                              //           fontSize: 13,
                              //         ),
                              //       ),
                              //       SizedBox(width: 15),
                              //     ],
                              //   ),
                              // ),
                              // Play Button Area
                              Opacity(
                                opacity: _sequenceAnimation['SecondAreaOpacity']
                                    .value,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    // Back Button
                                    IconButton(
                                      icon: Icon(Icons.fast_rewind),
                                      color: Color(0xff342844),
                                      iconSize: 45,
                                      onPressed: () {},
                                    ),
                                    // Play Button
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: FloatingActionButton(
                                        heroTag: "btn1",
                                        backgroundColor: Color(0xFF035887),
                                        child: Icon(
                                          // _animated
                                          playing == true
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                        onPressed: () {
                                          // var url = widget.streamUrl;

                                          // if (playing) {
                                          //   var res = await audioPlayer.pause();
                                          //   if (res == 1) {
                                          //     setState(() {
                                          //       playing = false;
                                          //     });
                                          //   }
                                          // } else {
                                          //   var res = await audioPlayer
                                          //       .play(url, isLocal: true);
                                          //   if (res == 1) {
                                          //     setState(() {
                                          //       playing = true;
                                          //     });
                                          //   }
                                          // }
                                          // audioPlayer.onDurationChanged
                                          //     .listen((Duration duration) {
                                          //   setState(() {
                                          //     _duration = duration;
                                          //   });
                                          // });

                                          // audioPlayer.onAudioPositionChanged
                                          //     .listen((Duration duration) {
                                          //   setState(() {
                                          //     _position = duration;
                                          //   });
                                          // });

                                          // getAudio();
                                          pr.show();
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 2000), () {
                                            pr.hide();
                                          });

                                          _animated
                                              ? playerProvider.stopPlayer()
                                              : playerProvider.startPlayer(
                                                  widget.streamUrl);

                                          setState(() {
                                            _animated = !_animated;
                                          });
                                        },
                                      ),
                                    ),
                                    // Next Button
                                    IconButton(
                                      icon: Icon(Icons.fast_forward),
                                      color: Color(0xff342844),
                                      iconSize: 45,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Minimize Play/Pause Button
                  AlignPositioned(
                    dx: _screenWidth * 0.35,
                    dy: _screenHeight * 0.375,
                    child: Opacity(
                      opacity:
                          _sequenceAnimation['MinimizeButtonOpacity'].value,
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          backgroundColor: Color(0xffffffff),
                          child: Icon(
                            _playPauseButton ? Icons.pause : Icons.play_arrow,
                            size: 25,
                            color: Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              pr.show();
                              Future.delayed(const Duration(milliseconds: 2000),
                                  () {
                                pr.hide();
                              });
                              _playPauseButton = !_playPauseButton;
                              _animated = _minimized ? false : !_animated;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dowloadButton(FileDownloaderProvider downloaderProvider) {
    return new FlatButton(
      onPressed: () {
        downloaderProvider
            .downloadFile("URL", "My File.mp3")
            .then((onValue) {});
      },
      textColor: Colors.black,
      color: Colors.redAccent,
      padding: const EdgeInsets.all(8.0),
      child: new Text(
        "Download File",
      ),
    );
  }

  Widget downloadProgress() {
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: true);

    return new Text(
      downloadStatus(fileDownloaderProvider),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  downloadStatus(FileDownloaderProvider fileDownloaderProvider) {
    var retStatus = "";

    switch (fileDownloaderProvider.downloadStatus) {
      case DownloadStatus.Downloading:
        {
          retStatus = "Download Progress : " +
              fileDownloaderProvider.downloadPercentage.toString() +
              "%";
        }
        break;
      case DownloadStatus.Completed:
        {
          retStatus = "Download Completed";
        }
        break;
      case DownloadStatus.NotStarted:
        {
          retStatus = "Click Download Button";
        }
        break;
      case DownloadStatus.Started:
        {
          retStatus = "Download Started";
        }
        break;
    }

    return retStatus;
  }

  // Widget slider() {
  //   return Slider.adaptive(
  //     min: 0.0,
  //     value: position.inSeconds.toDouble(),
  //     max: duration.inSeconds.toDouble(),
  //     onChanged: (double value) {
  //       setState(() {
  //         audioPlayer.seek(Duration(microseconds: value.toInt()));
  //         // audioPlayer.seekAudio(Duration(milliseconds: value.toInt()));
  //       });
  //     },
  //   );
  // }

  // void getAudio() async {
  //   var url = widget.streamUrl;
  //   if (playing) {
  //     var res = await audioPlayer.pause();
  //     if (res == 1) {
  //       setState(() {
  //         playing = false;
  //       });
  //     }
  //   } else {
  //     var res = await audioPlayer.play(url, isLocal: true);
  //     if (res == 1) {
  //       setState(() {
  //         playing = true;
  //       });
  //     }
  //   }
  //   audioPlayer.onDurationChanged.listen((Duration dd) {
  //     setState(() {
  //       _duration = dd;
  //     });
  //   });
  //   audioPlayer.onAudioPositionChanged.listen((Duration dd) {
  //     setState(() {
  //       _position = dd;
  //     });
  //   });
  // }
}
