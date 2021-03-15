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
          // height: size.height * 0.4,
          child: Stack(
            children: [
              // CarouselSlide(data: data),
              // ClipRRect(
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(50),
              //     bottomRight: Radius.circular(50),
              //   ),
                // child: Expanded(
               Container(
                  // height: size.height * 0.4 - 27,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
    height: 200.0,
    width: 350.0,
    child: Carousel(
      images: [
        NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
        NetworkImage('https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
        ExactAssetImage("assets/images/LaunchImage.jpg")
      ],
      showIndicator: false,
      borderRadius: false,
      moveIndicatorFromBottom: 180.0,
      noRadiusForIndicator: true,
      overlayShadow: true,
      overlayShadowColors: Colors.white,
      overlayShadowSize: 0.7,
    )
),
                      // Expanded(
                      //   child: Carousel(
                      //     boxFit: BoxFit.fill,
                      //     autoplay: true,
                      //     animationCurve: Curves.fastOutSlowIn,
                      //     animationDuration: Duration(milliseconds: 500),
                      //     dotSize: 5.0,
                      //     dotIncreasedColor: Color(0xFFFFEB3B),
                      //     dotBgColor: Colors.transparent,
                      //     dotPosition: DotPosition.bottomLeft,
                      //     // dotVerticalPadding: 20.0,
                      //     dotHorizontalPadding: 25,
                      //     dotSpacing: 20,
                      //     showIndicator: true,
                      //     indicatorBgPadding: 8.0,
                      //     overlayShadow: true,
                      //     overlayShadowColors: Colors.white,
                      //     overlayShadowSize: 0.7,
                      //     images: data,
                      //   ),
                      // ),
                    ],
                  ),
                  // ),
                
              ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     margin: EdgeInsets.symmetric(horizontal: size.width * 0.25),
              //     height: 54,
              //     child: Row(
              //       // crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           width: 40,
              //           height: 90,
              //           decoration: BoxDecoration(
              //             image: DecorationImage(
              //               image: AssetImage("assets/images/logo1.png"),
              //               fit: BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //         Text(
              //           "Radio Urban FM",
              //           style: Theme.of(context).textTheme.headline6.copyWith(
              //                 color: Colors.black,
              //                 fontSize: 10,
              //                 fontWeight: FontWeight.w300,
              //               ),
              //         ),
              //         Player(),
              //       ],
              //     ),
              //     decoration: BoxDecoration(
              //         color: Color(0xFFFFEB3B),
              //         borderRadius: BorderRadius.circular(50),
              //         boxShadow: [
              //           BoxShadow(
              //               offset: Offset(0, 10),
              //               blurRadius: 50,
              //               color: Colors.black.withOpacity(0.1)),
              //         ]),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}