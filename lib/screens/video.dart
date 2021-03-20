import 'package:flutter/material.dart';
import 'package:ufm/models/channel_model.dart';
import 'package:ufm/models/video_model.dart';
import 'package:ufm/screens/VideoComponent.dart';
import 'package:ufm/services/api_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ufm/size_config.dart';

class VideoHome extends StatefulWidget {
  @override
  _VideoHomeState createState() => _VideoHomeState();
}

class _VideoHomeState extends State<VideoHome> {
  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCLpmW_tEJbdt8BAD2M39BUg');
    setState(() {
      _channel = channel;
    });
  }

  _buildProfileInfo() {
    return Container(
      margin: EdgeInsets.all(0.0),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          height: getProportionateScreenWidth(130.0),
                          width: getProportionateScreenWidth(150.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                video.thumbnailUrl,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                getProportionateScreenWidth(30),
                              ),
                              topLeft: Radius.circular(
                                getProportionateScreenWidth(30),
                              ),
                              topRight: Radius.circular(
                                getProportionateScreenWidth(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    // bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    top: 40,
                    // top: 0.0,
                    child: Center(
                        child: IconButton(
                            icon: Icon(
                              Icons.play_circle_outline,
                              color: Colors.white54,
                              size: 40,
                            ),
                            onPressed: null)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dernières Vidéos",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: getProportionateScreenWidth(200),
                child: _channel != null
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollDetails) {
                          if (!_isLoading &&
                              _channel.videos.length !=
                                  int.parse(_channel.videoCount) &&
                              scrollDetails.metrics.pixels ==
                                  scrollDetails.metrics.maxScrollExtent) {
                            _loadMoreVideos();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 1 + _channel.videos.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return _buildProfileInfo();
                            }

                            Video video = _channel.videos[index - 1];
                            return _buildVideo(video);
                          },
                        ),
                      )
                    : Center(
                        child: SpinKitRipple(
                          color: Theme.of(context).primaryColor,
                          size: getProportionateScreenWidth(50),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
