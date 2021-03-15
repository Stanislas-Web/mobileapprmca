import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufm/screens/detailpodcast.dart';
import 'package:ufm/size_config.dart';

class RecentPodcast extends StatelessWidget {
  final List data;
  RecentPodcast({this.data});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: getProportionateScreenWidth(20),
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Les plus récents",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(20),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              podcastSection(context, data),
            ],
          ),
        )
      ],
    );
  }
}

Widget podcastSection(context, _myData) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: getProportionateScreenWidth(200),
    child: ListView.builder(
      // scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _myData == null ? 0 : _myData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MusicApp(
                  nom: _myData[index]['nomEmission'],
                  description: _myData[index]['description'],
                  image: _myData[index]['photo'],
                  streamUrl: _myData[index]['streamUrl'],
                  duree: _myData[index]['duree'],
                ),
              ),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //image podcast
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: getProportionateScreenWidth(20),
                          ),
                          height: getProportionateScreenWidth(80),
                          width: getProportionateScreenWidth(80),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: _myData[index]['photo'],
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.all(
                                  getProportionateScreenWidth(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _myData[index]['description'].length > 20
                                          ? '${_myData[index]['description'].substring(0, 20)} ...'
                                          : _myData[index]['description'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(13),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 10)),
                                    Text(_myData[index]['createdAt'])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //text podcast

                  Container(
                    margin: EdgeInsets.only(
                        // left: MediaQuery.of(context).size.width * 0.1,
                        left: 0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_myData[index]['duree']),
                        Text(
                          " min",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        // return Image(
        //   image: NetworkImage(image),
        //   width: 1getProportionateScreenWidth(20),
        //   height: 1getProportionateScreenWidth(20),
        // );
      },
    ),
  );

  // );
}
