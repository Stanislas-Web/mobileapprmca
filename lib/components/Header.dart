import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufm/components/Player.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Header extends StatelessWidget {
  // final List data;
  List<CachedNetworkImage> data = List<CachedNetworkImage>();
  Header({this.data});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Container(
          height: size.height * 0.4 - 10,
          child: Stack(
            children: [
              // CarouselSlide(data: data),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                // child: Expanded(
                child: Container(
                  height: size.height * 0.4 - 26,
                  width: size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: Carousel(
                          boxFit: BoxFit.fill,
                          autoplay: true,
                          animationCurve: Curves.fastOutSlowIn,
                          animationDuration: Duration(milliseconds: 500),
                          dotSize: 5.0,
                          dotIncreasedColor: Color(0xFF035887),
                          dotBgColor: Colors.transparent,
                          dotPosition: DotPosition.bottomLeft,
                          dotHorizontalPadding: 25,
                          dotSpacing: 20,
                          showIndicator: true,
                          indicatorBgPadding: 8.0,
                          overlayShadow: false,
                          overlayShadowColors: Colors.white,
                          overlayShadowSize: 0.7,
                          images: data,
                        ),
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
