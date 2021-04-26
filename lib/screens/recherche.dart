import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

import 'detailpodcast.dart';

class Recherche extends StatefulWidget {
  Recherche({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  bool _isLoading = false;
  bool checkData = false;
  List data;
  bool loading = false;

  final myController = TextEditingController();
  Future getHttpPodcastByEmission(query) async {
    setState(() {
      loading = true;
    });
    var dio = Dio();
    var response = await dio.get(
      "https://us-central1-rmca-8ac5b.cloudfunctions.net/api/podcastsbyemission/$query",
    );

    setState(() {
      data = response.data;
      checkData = false;
      loading = false;
    });
    print(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0083CC),
        elevation: 0,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //       icon: SvgPicture.asset(
        //         'assets/icons/menu.svg',
        //         height: 15,
        //         width: 15,
        //       ),
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/detail');
        //       }),
        // ],
      ),
      // drawer: drawerMenu(context, size),
      body: _isLoading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchSection(context, myController, getHttpPodcastByEmission,
                      checkData, data, loading)
                ],
              ),
            )
          : Center(
              child: SpinKitRipple(
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
            ),
    );
  }
}

Widget searchSection(
    context, myController, getHttpPodcastByEmission, checkData, data, loading) {
  return Container(
    margin: EdgeInsets.only(top: 10, left: 10, right: 20),
    width: MediaQuery.of(context).size.width,
    decoration: new BoxDecoration(
      borderRadius: new BorderRadius.circular(16.0),
      // color: Colors.grey[100],
    ),
    child: Column(
      children: [
        // SearchBar(onSearch: null, onItemFound: null),

        inputSearch(context, myController, getHttpPodcastByEmission, checkData,
            loading),
        checkData
            ? searchResult(context, data)
            : Center(
                child: SpinKitRipple(
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
              ),
        // loading
        //     ? Center(
        //         child: SpinKitRipple(
        //           color: Theme.of(context).primaryColor,
        //           size: 100,
        //         ),
        //       )
        //     : searchResult(context, data),
        // searchResult(context)
      ],
    ),
  );
}

Widget inputSearch(
    context, myController, getHttpPodcastByEmission, checkData, loading) {
  return Container(
    // margin: EdgeInsets.only(top: 30),
    width: MediaQuery.of(context).size.width,
    height: 50,
    padding: EdgeInsets.only(left: 30),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
    child: TextField(
      controller: myController,
      decoration: InputDecoration(
        hintText: "podcasts",
        // hintStyle: TextStyle(color: .withOpacity(.5)),
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.search,
          ),
          onPressed: () {
            loading = true;
            checkData = true;
            print(myController.text);
            getHttpPodcastByEmission(myController.text);
            myController.clear();
            loading = false;
          },
        ),
      ),
    ),
  );
}

Widget searchResult(context, _myData) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    padding: EdgeInsets.all(10),
    child: ListView.builder(
      // scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _myData == null ? 0 : _myData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GestureDetector(
            // onTap: () {
            //   print("Container was tapped");
            //   Navigator.pushNamed(context, '/detail', arguments: {
            //     'image': _myData[index]['photo'],
            //     'streamUrl': _myData[index]['streamUrl'],
            //   });
            // },
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
                          margin: EdgeInsets.only(top: 20),
                          height: 80,
                          width: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              _myData[index]['photo'],
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 160,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _myData[index]['description'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Text(_myData[index]['createdAt'])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //text podcast
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
        //   width: 120,
        //   height: 120,
        // );
      },
    ),
  );

  // return Container(
  //   margin: EdgeInsets.only(left: 10, bottom: 5),
  //   child: Row(
  //     children: [
  //       //image podcast
  //       Container(
  //         margin: EdgeInsets.only(top: 20),
  //         height: 80,
  //         width: 80,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage("assets/images/affiche10.jpg"),
  //               fit: BoxFit.cover),
  //           // borderRadius: BorderRadius.only(
  //           //     bottomLeft: Radius.circular(10),
  //           //     bottomRight: Radius.circular(10))
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),

  //       //text podcast
  //       Container(
  //         child: Row(
  //           children: [
  //             Container(
  //               padding: EdgeInsets.all(10),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     "U News",
  //                     style: Theme.of(context).textTheme.headline6.copyWith(
  //                           color: Colors.black,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                   ),
  //                   Padding(padding: EdgeInsets.only(bottom: 10)),
  //                   Text("01 Nov 2020")
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // );
}

Widget drawerMenu(context, size) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, bottom: 20),
          height: 150,
          decoration: BoxDecoration(
              color: Color(0xFFFFEB3B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              )),
          child: Column(
            children: [],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.only(top: 20, left: 10),
          height: size.height,
          decoration: BoxDecoration(
              color: Color(0xFFdadada).withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
              )),
          child: Column(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/site.svg",
                  width: 30,
                  height: 20,
                ),
                title: new Text(
                  'Site Web',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {},
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/note.svg",
                  width: 20,
                  height: 20,
                ),
                title: new Text(
                  "Noter l'application",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  // _launchURL();
                },
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/page.svg",
                  width: 20,
                  height: 20,
                ),
                title: new Text(
                  'Nos pages',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {},
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/apropos.svg",
                  width: 20,
                  height: 20,
                ),
                title: new Text(
                  'A propos',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {},
              ),
              new ListTile(
                leading: SvgPicture.asset(
                  "assets/icons/parametre.svg",
                  width: 20,
                  height: 20,
                ),
                title: new Text(
                  'Paramètre',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF19232F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 41,
                    width: 239,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Se déconnecter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Container(
                            child: SvgPicture.asset(
                              "assets/icons/share-arrow.svg",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
