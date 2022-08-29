
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/unit/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../models/main.dart';

import 'package:http/http.dart' as http;


class BuildDrawer extends StatefulWidget {
  const BuildDrawer({Key? key}) : super(key: key);

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {

  String email = "";


  bool loading = true;
  String clicked = "books";
  bool notLogged = true;
  bool isLogin = false;
  bool clickMe = true;

  String userID = "";
  String userName = "";
  String userEmail = "";
  String userPicURL = "";

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/qqww.mp4');

    checkLogged();
  }

  void checkLogged() async {

    _controller.initialize();

    final prefs = await SharedPreferences.getInstance();

    email = prefs.getString('email') ?? "";

    getUserData();

  }

  List<mainL> theList = [];

  Future<void> getUserData() async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )));
        });


    final prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString('email') ?? "";

    try {

      if (userEmail == "") {

        log("not logged");

        Navigator.of(context).pop();

        setState((){
          notLogged = true;
        });

        if (clicked == "s&m" || clicked == "books") {
          final url = Uri.parse(
              'https://pandarosh-91270-default-rtdb.firebaseio.com/' +
                  clicked +
                  '.json');

          http.get(url).then((value) {
            if (value.body == "{}") {
            } else {
              final List<mainL> loadData = [];

              final extractedData = json.decode(value.body);

              extractedData?.forEach((Key, value) {
                loadData.add(mainL(
                  idToEdit: Key,
                  name: value['name'],
                  num: value['num'],
                  urlB: value['urlB'],
                  urlP: value['urlP'],
                  infoID: value['info'],
                ));
              });

              setState(() {
                theList = loadData;
                loading = false;
                //tempList = theList;
              });


            }
          });
        }

        else if(clicked == "favS&M"){
          final url = Uri.parse(
              'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json?orderBy="userID"&equalTo="$userID"');

          http.get(url).then((value) {
            if (value.body == "{}") {

              setState(() {
                loading = false;
              });

            } else {
              log(value.body);

              final List<mainL> loadData = [];

              final extractedData = json.decode(value.body);

              extractedData?.forEach((Key, value) {

                if(value['type'] == "s&m"){
                  loadData.add(mainL(
                    idToEdit: Key,
                    name: value['name'],
                    num: value['num'],
                    urlB: value['urlB'],
                    urlP: value['urlP'],
                    infoID: value['info'],

                  ));
                }

              });

              setState(() {
                theList = loadData;
                loading = false;
                //tempList = theList;
              });


            }
          });
        }
        else if(clicked == "favBooks"){
          final url = Uri.parse(
              'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json?orderBy="userID"&equalTo="$userID"');

          log("userID: " + userID);

          http.get(url).then((value) {
            if (value.body == "{}") {

              setState(() {
                loading = false;
              });

            }
            else {
              log(value.body);

              final List<mainL> loadData = [];

              final extractedData = json.decode(value.body);

              extractedData?.forEach((Key, value) {

                if(value['type'] == "books"){
                  loadData.add(mainL(
                    idToEdit: Key,
                    name: value['name'],
                    num: value['num'],
                    urlB: value['urlB'],
                    urlP: value['urlP'],
                    infoID: value['info'],

                  ));
                }

              });

              setState(() {
                theList = loadData;
                loading = false;
                //tempList = theList;
              });


            }
          });
        }

      }
      else {

        final url = Uri.parse('https://pandarosh-91270-default-rtdb.firebaseio.com/users.json?orderBy="email"&equalTo="$userEmail"');

        log("loggeddd");

        http.get(url).then((value) {
          if (value.body == "{}") {

            Navigator.of(context).pop();
            log("a7a");

          }
          else {

            final extractedData = json.decode(value.body);

            extractedData?.forEach((Key, value) {

              setState((){
                userID = Key;
                log(userID);
                userName = value['name'];
                userEmail = value['email'];
                userPicURL = value['picURL'];
              });

            });


            //user data
            prefs.setString('ID', userID);
            prefs.setString('email', userEmail);
            prefs.setString('name', userName);
            prefs.setString('picURL', userPicURL);

            Navigator.of(context).pop();

            setState(() {
              notLogged = false;
            });

            {

              if (clicked == "s&m" || clicked == "books") {
                final url = Uri.parse(
                    'https://pandarosh-91270-default-rtdb.firebaseio.com/' +
                        clicked +
                        '.json');

                http.get(url).then((value) {
                  if (value.body == "{}") {
                  } else {
                    final List<mainL> loadData = [];

                    final extractedData = json.decode(value.body);

                    extractedData?.forEach((Key, value) {
                      loadData.add(mainL(
                        idToEdit: Key,
                        name: value['name'],
                        num: value['num'],
                        urlB: value['urlB'],
                        urlP: value['urlP'],
                        infoID: value['info'],
                      ));
                    });

                    setState(() {
                      theList = loadData;
                      loading = false;
                      //tempList = theList;
                    });


                  }
                });
              }

              else if(clicked == "favS&M"){
                final url = Uri.parse(
                    'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json?orderBy="userID"&equalTo="$userID"');

                http.get(url).then((value) {
                  if (value.body == "{}") {

                    setState(() {
                      loading = false;
                    });

                  } else {
                    log(value.body);

                    final List<mainL> loadData = [];

                    final extractedData = json.decode(value.body);

                    extractedData?.forEach((Key, value) {

                      if(value['type'] == "s&m"){
                        loadData.add(mainL(
                          idToEdit: Key,
                          name: value['name'],
                          num: value['num'],
                          urlB: value['urlB'],
                          urlP: value['urlP'],
                          infoID: value['info'],

                        ));
                      }

                    });

                    setState(() {
                      theList = loadData;
                      loading = false;
                      //tempList = theList;
                    });


                  }
                });
              }
              else if(clicked == "favBooks"){
                final url = Uri.parse(
                    'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json?orderBy="userID"&equalTo="$userID"');

                log("userID: " + userID);

                http.get(url).then((value) {
                  if (value.body == "{}") {

                    setState(() {
                      loading = false;
                    });

                  }
                  else {
                    log(value.body);

                    final List<mainL> loadData = [];

                    final extractedData = json.decode(value.body);

                    extractedData?.forEach((Key, value) {

                      if(value['type'] == "books"){
                        loadData.add(mainL(
                          idToEdit: Key,
                          name: value['name'],
                          num: value['num'],
                          urlB: value['urlB'],
                          urlP: value['urlP'],
                          infoID: value['info'],

                        ));
                      }

                    });

                    setState(() {
                      theList = loadData;
                      loading = false;
                      //tempList = theList;
                    });


                  }
                });
              }



            }

          }
        });

      }

    } catch (error) {
      log(error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    backgroundImage: userPicURL.isEmpty? NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/001/840/612/small/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg')
                        : NetworkImage(userPicURL),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),),
                ],
              ),
            ),
            Divider(height: 3,
              color: Get.isDarkMode?Colors.white:Colors.black,),
            const SizedBox(height: 5,),
            ListTile(
              title: Text('المسلسلات و الافلام',

                textAlign: TextAlign.start,
                style: TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(FontAwesomeIcons.clapperboard,
                color: Colors.deepOrange,size: 30,),
              onTap: () async{

                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "s&m");

                Navigator.of(context).popAndPushNamed(Routes.categoryMovies);

              },
            ),
            ListTile(
              title: Text('الكتب',
                textAlign: TextAlign.start,
                style: TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(FontAwesomeIcons.bookMedical,
                color: Colors.deepOrange,size: 30,),
              onTap: ()async {
                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "books");

                Navigator.of(context).popAndPushNamed(Routes.categoryMovies);
              },
            ),
            ListTile(
              title: Text('مكتبتي',

                textAlign: TextAlign.start,
                style: TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(Icons.library_music,
                color: Colors.deepOrange,size: 30,),
              onTap: ()=>Get.offAndToNamed(Routes.library),
            ),
            ListTile(
              title: Text('المفضله',

                textAlign: TextAlign.start,
                style: TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(FontAwesomeIcons.heartCircleBolt,
                color: Colors.deepOrange,size: 30,),
              onTap: () async{
                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "favS&M");

                Navigator.of(context).popAndPushNamed(Routes.fav);

              },
            ),
            ListTile(
              title: Text(Get.isDarkMode?'الوضع الغامق':'الوضع الفاتح',

                softWrap: true,

                style:  TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:   Icon(Get.isDarkMode?FontAwesomeIcons.moon:FontAwesomeIcons.lightbulb,
                color: Colors.deepOrange,size: 30,),
              onTap: () {

                ThemeController().changeTheTheme();

                Get.back();

              },
            ),

            ListTile(
              title: Text('انشر كتابك',
                textAlign: TextAlign.start,
                style: TextStyle(color:  Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(Icons.volunteer_activism,
                color: Colors.deepOrange,size: 30,),
              onTap: (){


                Get.defaultDialog(
                  title: 'انشر كتابك',
                  barrierDismissible: false,
                  buttonColor:
                  Colors.deepOrange,
                  content: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.52,
                        width: MediaQuery.of(context).size.width * 0.82,
                        child: Stack(
                          children: [
                            VideoPlayer(_controller),

                            Container(
                              color: Colors.black54,
                            ),

                            Center(
                              child: InkWell(
                                onTap: (){

                                  Get.back();

                                  Get.defaultDialog(
                                    title: 'انشر كتابك',
                                    barrierDismissible: false,
                                    buttonColor:
                                    Colors.deepOrange,
                                    content: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.width * 0.52,
                                          width: MediaQuery.of(context).size.width * 0.82,
                                          child: Stack(
                                            children: [
                                              VideoPlayer(_controller),

                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              ':يمكنك الأن التواصل معنا لتحويل كتابك'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await launchUrl(
                                                      Uri.parse(
                                                          'https://wa.me/message/XJFNP7N7WYRBJ1'));
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .whatsapp,
                                                  size: 40,
                                                  color: Colors
                                                      .green,
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                                onTap: () async {
                                                  await launchUrl(
                                                      Uri.parse(
                                                          'https://www.facebook.com/KITABAKMASMO3'));
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .facebook,
                                                  size: 40,
                                                  color:
                                                  Colors.blue,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    cancelTextColor: Get.isDarkMode? Colors.white:
                                    Colors.black,
                                    textCancel: 'العوده',
                                  );

                                  _controller.play();
                                },
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 40,
                                  color:
                                  Colors.deepOrange,
                                ),

                              ),
                            ),

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            ':يمكنك الأن التواصل معنا لتحويل كتابك'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: [
                          InkWell(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse(
                                        'https://wa.me/message/XJFNP7N7WYRBJ1'));
                              },
                              child: Icon(
                                FontAwesomeIcons
                                    .whatsapp,
                                size: 40,
                                color: Colors
                                    .green,
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                              onTap: () async {
                                await launchUrl(
                                    Uri.parse(
                                        'https://www.facebook.com/KITABAKMASMO3'));
                              },
                              child: Icon(
                                FontAwesomeIcons
                                    .facebook,
                                size: 40,
                                color:
                                Colors.blue,
                              )),
                        ],
                      )
                    ],
                  ),
                  cancelTextColor: Get.isDarkMode? Colors.white:
                  Colors.black,
                  textCancel: 'العوده',
                );

              },
            ),
            ListTile(
              title: Text('من نحن',
                textAlign: TextAlign.start,
                style: TextStyle(color:  Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(Icons.volunteer_activism,
                color: Colors.deepOrange,size: 30,),
              onTap: (){


                Get.defaultDialog(
                  title: 'من نحن',
                  barrierDismissible: false,
                  buttonColor:
                  Colors.deepOrange,
                  content:  Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {

                              },
                              style: ButtonStyle(
                                  shape:
                                  MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(10)),
                                  ),
                                  backgroundColor:
                                  MaterialStateProperty.all(
                                    Colors.deepOrange,
                                  )),
                              child: Text(
                                'الدفع',
                                style: TextStyle(
                                    fontFamily: 'aribic',
                                    fontSize:15,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              'اذا اعجبتك الفكرة ادعمنا',
                              style: TextStyle(
                                  fontFamily: 'aribic',
                                  fontSize:15,
                                  color: Colors.white),
                            ),

                          ],
                        ),
                      ]

                  ),
                  cancelTextColor:Get.isDarkMode?Colors.white: Colors.black,
                  textCancel: 'العوده',
                );

              },
            ),

            email == "" ? Container(): ListTile(
              title: Text('تسجيل الخروج',
                textAlign: TextAlign.start,
                style: TextStyle(color: Get.isDarkMode?Colors.grey:Colors.black,
                    fontSize: 20),) ,
              leading:  const Icon(Icons.logout,
                color: Colors.deepOrange,size: 30,),
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          child: Center(
                              child:
                              CircularProgressIndicator()));
                    });

                try {
                  await FirebaseAuth.instance
                      .signOut()
                      .then((value) async {
                    final prefs =
                    await SharedPreferences.getInstance();

                    prefs.setString('ID', "");
                    prefs.setString('email', "");
                    prefs.setString('name', "");
                    prefs.setString('picURL', "");

                    Navigator.of(context).pop();

                    Navigator.of(context).popAndPushNamed(Routes.homeScreen);

                  });
                } catch (e) {
                  log(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
