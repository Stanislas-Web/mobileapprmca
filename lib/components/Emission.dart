import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ufm/screens/detailemission.dart';
import 'package:ufm/size_config.dart';

class Emission extends StatelessWidget {
  final List data;

  Emission({this.data});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Emissions",
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: getProportionateScreenWidth(25),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: getProportionateScreenWidth(200),
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data == null ? 0 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: getProportionateScreenWidth(20),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailEmission(
                              id: data[index]['id'],
                              nom: data[index]['nom'],
                              image: data[index]['photo'],
                              description: data[index]['description'],
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: getProportionateScreenWidth(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: ClipRRect(
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
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: data[index]['photo'],
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        height:
                                            getProportionateScreenWidth(150.0),
                                        width:
                                            getProportionateScreenWidth(170.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: getProportionateScreenWidth(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          data[index]['nom'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12),
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Image(
                            //   image: NetworkImage(image),
                            //   width: 120,
                            //   height: 120,
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
