import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:carousel_pro/carousel_pro.dart';

class CarouselSlide extends StatefulWidget {
  List<NetworkImage> data = List<NetworkImage>();
  CarouselSlide({this.data});
  @override
  _CarouselSlideState createState() => _CarouselSlideState();
}

class _CarouselSlideState extends State<CarouselSlide> {
  List<NetworkImage> _imgs = List<NetworkImage>();
  Future getHttp() async {
    var dio = Dio();
    var images = await dio.get(
      "https://us-central1-urbainfm-bd5e6.cloudfunctions.net/api/bannieres",
      options: buildCacheOptions(Duration(days: 7)),
    );
    print("image ");
    setState(() {
      // _imgs = images.data;
      images.data.forEach((urlBannier) {
        _imgs.add(NetworkImage(urlBannier['urlBannier']));
        // _imgs.add(urlBannier["urlBannier"]);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHttp();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<String> image = [
      "https://firebasestorage.googleapis.com/v0/b/urbainfm-bd5e6.appspot.com/o/images%2Fmo2.jpg?alt=media&token=93e14842-f793-4d67-ac49-a4f6eba86082",
      "https://firebasestorage.googleapis.com/v0/b/urbainfm-bd5e6.appspot.com/o/images%2Fmo.jpg?alt=media&token=f12da5ac-fe2c-48f6-b727-7999c779bb6d",
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t1.0-9/133207102_1565081420366125_1985511631538739084_o.jpg?_nc_cat=108&ccb=2&_nc_sid=8bfeb9&_nc_eui2=AeHlSiDplAULhWBPpG_cglEYyFra7l6dSj3IWtruXp1KPVkHl4DryQsedQSgBq_07Jyky_-YH1kNFBdxYD-XITSU&_nc_ohc=8xYetA5Mg90AX_FPaBf&_nc_ht=scontent.ffih1-2.fna&oh=1148ec344322772aaacb4c1e0f2415c6&oe=600A9419",
      "https://scontent.ffih1-2.fna.fbcdn.net/v/t1.0-9/133333336_1565404570333810_6374254147615974827_o.jpg?_nc_cat=103&ccb=2&_nc_sid=8bfeb9&_nc_eui2=AeHBQoiRVt8xH_HxP5EGDXlpF73kDc7czEUXveQNztzMRYksm1mJDgZ90iHx59Pa_iQnKbzOjIMlvxznzAcv14QA&_nc_ohc=IY416VO5tKUAX_JZi8Y&_nc_ht=scontent.ffih1-2.fna&oh=daebbf347585bff9bdacba5a06535505&oe=600A7B63",
      "https://firebasestorage.googleapis.com/v0/b/urbainfm-bd5e6.appspot.com/o/images%2Fic.jpg?alt=media&token=0231086f-59fd-4f54-a2f8-f10db7d7cbac"
      // "https://scontent.ffih1-2.fna.fbcdn.net/v/t1.0-9/133333336_1565404570333810_6374254147615974827_o.jpg?_nc_cat=103&ccb=2&_nc_sid=8bfeb9&_nc_eui2=AeHBQoiRVt8xH_HxP5EGDXlpF73kDc7czEUXveQNztzMRYksm1mJDgZ90iHx59Pa_iQnKbzOjIMlvxznzAcv14QA&_nc_ohc=IY416VO5tKUAX_JZi8Y&_nc_ht=scontent.ffih1-2.fna&oh=daebbf347585bff9bdacba5a06535505&oe=600A7B63",
    ];

    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
      child: Expanded(
        child: Container(
          // height: size.height * 0.4 - 27,
          width: size.width,
          child: Carousel(
            boxFit: BoxFit.fill,
            autoplay: true,
            animationCurve: Curves.fastOutSlowIn,
            animationDuration: Duration(milliseconds: 500),
            dotSize: 5.0,
            dotIncreasedColor: Color(0xFFFFEB3B),
            dotBgColor: Colors.transparent,
            dotPosition: DotPosition.bottomLeft,
            // dotVerticalPadding: 15.0,
            dotHorizontalPadding: 25,
            dotSpacing: 20,
            showIndicator: true,
            indicatorBgPadding: 8.0,
            overlayShadow: false,
            overlayShadowColors: Colors.white,
            overlayShadowSize: 0.7,
            images: _imgs,
          ),
        ),
      ),
    );
  }
}
