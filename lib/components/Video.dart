import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<String> _emission = [
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t31.0-8/25182124_765275507013391_2248680862831682624_o.jpg?_nc_cat=100&ccb=2&_nc_sid=730e14&_nc_eui2=AeFihyF5VMB9g9adqmTwMOPFIsIpIOQjieYiwikg5COJ5ip9bFY23TajHqjVx7_e-vsuWYietPXYHeT_xME__isi&_nc_ohc=NRyJhrYbz3cAX_D10J-&_nc_ht=scontent.ffih1-2.fna&oh=0a5548c31ea06525403ac100368f2582&oe=5FBCAC05",
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t1.0-9/107934418_1426094464264822_3870506924368542340_o.jpg?_nc_cat=107&ccb=2&_nc_sid=8bfeb9&_nc_eui2=AeHrr4-FtCxFLoSIwL7-xtiiCGCbT00iww8IYJtPTSLDD0OHEovWKrR0U5XO06kNC0IOIcllLGMN4tjoYYkwceiP&_nc_ohc=uIehlktOAdcAX_pzLIq&_nc_oc=AQkV6l5-H4q_Pw6DvFn1zS3ef4o-Rx9OzTJNIsj8LWj4aEdfR2jaFQ5tQPnhFqLGHJI&_nc_ht=scontent.ffih1-2.fna&oh=75f557eb0ad3f48cf59b143c68004f88&oe=5FBC76D5",
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t31.0-8/25182124_765275507013391_2248680862831682624_o.jpg?_nc_cat=100&ccb=2&_nc_sid=730e14&_nc_eui2=AeFihyF5VMB9g9adqmTwMOPFIsIpIOQjieYiwikg5COJ5ip9bFY23TajHqjVx7_e-vsuWYietPXYHeT_xME__isi&_nc_ohc=NRyJhrYbz3cAX_D10J-&_nc_ht=scontent.ffih1-2.fna&oh=0a5548c31ea06525403ac100368f2582&oe=5FBCAC05",
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t1.0-9/107934418_1426094464264822_3870506924368542340_o.jpg?_nc_cat=107&ccb=2&_nc_sid=8bfeb9&_nc_eui2=AeHrr4-FtCxFLoSIwL7-xtiiCGCbT00iww8IYJtPTSLDD0OHEovWKrR0U5XO06kNC0IOIcllLGMN4tjoYYkwceiP&_nc_ohc=uIehlktOAdcAX_pzLIq&_nc_oc=AQkV6l5-H4q_Pw6DvFn1zS3ef4o-Rx9OzTJNIsj8LWj4aEdfR2jaFQ5tQPnhFqLGHJI&_nc_ht=scontent.ffih1-2.fna&oh=75f557eb0ad3f48cf59b143c68004f88&oe=5FBC76D5",
    ];
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dernières Vidéos",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: _emission.map((image) {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.dstATop),
                                      image: new CachedNetworkImageProvider(
                                        image,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
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
                              child: Icon(Icons.place_outlined),
                              // child:
                              //     SvgPicture.asset('assets/icon/playVideo.svg'),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
