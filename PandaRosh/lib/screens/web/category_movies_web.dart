import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/widget/card_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Bloc/states.dart';
import '../../models/main.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:video_player/video_player.dart';


import 'package:encrypt/encrypt.dart' as encrypt;


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandarosh/Bloc/cubit.dart';

class CategoryMoviesWeb extends StatefulWidget {
  const CategoryMoviesWeb({Key? key}) : super(key: key);

  @override
  State<CategoryMoviesWeb> createState() => _CategoryMoviesWebState();
}

class _CategoryMoviesWebState extends State<CategoryMoviesWeb> {
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

    getData();
  }

  List<mainL> theList = [];

  void getData() async {
    theList = [];

    _controller.initialize();

    final prefs = await SharedPreferences.getInstance();


/*    if(showPlayerGlobal){
      setState((){
        showPlayer = true;
      });
    }else{
      setState((){
        showPlayer = false;
      });
    }*/

    clicked = prefs.getString('clicked').toString();

    if(clicked == "libS&M" ||clicked == "libBooks"){
      clickMe = true;
    }else {
      clickMe = false;
    }


    log(clicked);

    try {

      getUserData();


    } catch (error) {
      log(error.toString());
    }
  }

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
                tempList = theList;
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
                tempList = theList;
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
                tempList = theList;
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
                      tempList = theList;
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
                      tempList = theList;
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
                      tempList = theList;
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
    var size = MediaQuery.of(context).size;
    return /*BlocProvider(
      create: (BuildContext context) => PandaroshCubit()..getLast(),
      child: BlocConsumer<PandaroshCubit, PandaroshStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PandaroshCubit.get(context);
          return */ Scaffold(
            backgroundColor: context.theme.backgroundColor,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                width: double.infinity,
                                color: context.theme.backgroundColor,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                   /* Text(
                                      'بانداروش',
                                      style: TextStyle(
                                        color: Colors.deepOrange,
                                        fontSize: size.width * 0.020,
                                        fontFamily: 'aribic',
                                        fontWeight: FontWeight.bold,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
*/
                                    InkWell(
                                      onTap: (){
                                        Get.offNamed(Routes.homeScreen);
                                      },
                                      child: Image.asset(
                                        "assets/images/name.png",
                                        fit: BoxFit.fill,
                                        width: size.width * 0.08,
                                        height: size.width * 0.05,
                                      ),
                                    ),

                                    VerticalDivider(
                                      color: Colors.grey.shade300,
                                      indent: 1,
                                      endIndent: 1,
                                      thickness: 2,
                                    ),

                                    CircleAvatar(
                                      radius: size.width * 0.015,
                                      backgroundColor: Colors.black,
                                      backgroundImage: userPicURL.isEmpty? NetworkImage('https://static.vecteezy.com/system/resources/thumbnails/001/840/612/small/picture-profile-icon-male-icon-human-or-people-sign-and-symbol-free-vector.jpg')
                                          : NetworkImage(userPicURL),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.010,
                                    ),
                                    Text(
                                      userName,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: size.width * 0.015,
                                      ),
                                    ),
                                    const Spacer(),

                                    Container(
                                      //search bar
                                      width: size.width*0.40,
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.grey.shade300
                                      ),
                                      child:  TextFormField(
                                        onChanged: (v) {

                                          filter(v);

                                        },
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.search),
                                          suffixIconColor: Colors.deepOrange,
                                          hintText: 'ابحث عن المزيد من المسلسلات والافلام والكتب',
                                          hintStyle: TextStyle(
                                              fontSize: size.width>=900?size.width*0.012:size.width*0.015,
                                              color: Colors.black
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300
                                              )
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade300
                                              )
                                          ),
                                        ),

                                      ),

                                      /*Row(
                                children:  [
                                  Text('ابحث عن المزيد من المسلسلات والافلام ',
                                    style: TextStyle(
                                      fontSize: size.width*0.01,
                                        color: Colors.black
                                    ),),
                                  const Spacer(),
                                  const Icon(Icons.search)
                                ],
                              ),*/
                                    ),

                                    const SizedBox(
                                      width: 15,
                                    ),
                                    (size.width>660)?MaterialButton(
                                      onPressed: () {

                                        Get.defaultDialog(
                                          title: 'انشر كتابك',
                                          barrierDismissible: false,
                                          buttonColor:
                                          Colors.deepOrange,
                                          content: Column(
                                            children: [
                                              Container(
                                                height: size.width * 0.32,
                                                width: size.width * 0.62,
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
                                                                  height: size.width * 0.32,
                                                                  width: size.width * 0.62,
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
                                          Colors.
                                          black,
                                          textCancel: 'العوده',
                                        );


                                      },
                                      color: Colors.deepOrange,
                                      child:  Text('انشر كتابك',
                                        style: TextStyle(
                                            fontFamily: 'aribic',
                                            fontSize: size.width*0.015,color: Colors.white
                                        ),),
                                      /*padding: const EdgeInsets.only(top:10, right: 12,
                                    left: 12,
                                    bottom: 20),*/
                                    ):Container(),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Divider(
                                  color: Colors.grey.shade300, //color of divider
                                  height: 2, //height spacing of divider
                                  thickness: 2, //thickness of divier line
                                  indent: 25, //spacing at the start of divider
                                  endIndent: 25, //spacing at the end of divider
                                ),
                              ),


                              //mn awl hnnnnaaaaaa
                              Container(
                                  child:
                                  clicked == "s&m" || clicked == "books" ? loading
                                      ? Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      ))
                                      : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                        child: GridView.builder(
                                            padding: const EdgeInsets.all(20),
                                            shrinkWrap: false,
                                            gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 250,
                                                mainAxisSpacing: 8,
                                                mainAxisExtent: 300,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 3 / 2),
                                            itemCount: theList.length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                onTap: () async{

                                                  final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
                                                  final iv = encrypt.IV.fromLength(16);

                                                  final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                                  final encrypted = encrypter.encrypt(theList[index].infoID.toString(), iv: iv);

                                                  log(encrypted.base64);

                                                  int x = 1;

                                                  if(clicked == "s&m"){
                                                    x = 1;
                                                  }else if(clicked == "books"){
                                                    x = 2;
                                                  }

                                                  String url = ("showMovies?id=" + encrypted.base64 + "&ss=" + x.toString()).toString();
                                                  //String url = ("http://localhost:1675/showMovies?id=" + Uri.decodeFull(encrypted.base64) + "&ss=" + x.toString()).toString();


                                                  html.window.open(url,"_blank");




                                                  //final prefs = await SharedPreferences.getInstance();

                                                  //prefs.setString('movieID', theList[index].infoID.toString());
                                                  print(url);

                                                  //Get.toNamed(Routes.showMovies);




                                                  //html.window.open('https://pandarosh.com/showMovies',"_blank");


                                                },
                                                child: HoverCrossFadeWidget(
                                                  duration:
                                                  Duration(milliseconds: 500),
                                                  firstChild: Container(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: 'assets/kk.gif',
                                                        image: theList[index].urlP,
                                                        height: 300,
                                                        width: 250, //kant 400
                                                        fit: BoxFit.fill,

                                                      ),
                                                    ),


                                                    /*Image.network(,
                                                    errorBuilder: ,
                                                    loadingBuilder: ,
                                                    placeholder: 'assets/images/logo.png',
                                                    height: size.width*0.050,
                                                    width: size.width*0.050,
                                                  ).image,*/
                                                  ) ,
                                                  secondChild: Container(
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.deepOrange,
                                                            width: 0.5)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                              child: FadeInImage.assetNetwork(
                                                                placeholder: 'assets/kk.gif',
                                                                image: theList[index].urlP,
                                                                height: 250,
                                                                width: 250,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            )
                                                            /* Image.network(
                                                    theList[index].urlP,
                                                    fit: BoxFit.cover,
                                                    width: 400,
                                                    height: 150,
                                                  )*/,
                                                            const Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Banner(
                                                                color: Colors.red,
                                                                message: 'الجديد',
                                                                location:
                                                                BannerLocation
                                                                    .topEnd,
                                                              ),
                                                            ),
                                                            /*Positioned(
                                                top: 10,
                                                  right: 10,
                                                  child:Container(
                                                    color: Colors.black38,
                                                    child: const Text('10:54',style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                      textAlign: TextAlign.start,),
                                                  )
                                                )*/
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Text(
                                                              theList[index].name,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                color: Get.isDarkMode
                                                                    ? Colors.white
                                                                    : const Color(
                                                                    0XFF215480),
                                                                fontSize: 20,
                                                              ),
                                                              textAlign:
                                                              TextAlign.start,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                    ),
                                  )
                                      : notLogged ? Expanded(
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.deepOrange,
                                            border: Border.all(color: Colors.deepOrange,
                                                width: 3),
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('يجب عليك تسجيل الدخول لرؤيه مكتبتك او المفضله',
                                              style: TextStyle(
                                                color: Get.isDarkMode?Colors.white:Colors.black,
                                                fontSize: 18,

                                              ),),
                                            const SizedBox(height: 20,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      signInWithFacebook();
                                                    },
                                                    child: Icon(FontAwesomeIcons.facebook,
                                                      color: Colors.blueAccent,size: 40,),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      signInWithGoogle();
                                                    },
                                                    child: Image.asset(
                                                      "assets/images/google.png",
                                                      fit: BoxFit.fill,
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      : loading
                                      ? Center(child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(),
                                      ))
                                      : Expanded(
                                    child: GridView.builder(
                                        padding: const EdgeInsets.all(20),
                                        shrinkWrap: false,
                                        gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 250,
                                            mainAxisSpacing: 8,
                                            mainAxisExtent: 300,
                                            crossAxisSpacing: 8,
                                            childAspectRatio: 3 / 2),
                                        itemCount: theList.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(

                                            onTap: () async{
                                              final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
                                              final iv = encrypt.IV.fromLength(16);

                                              final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                              final encrypted = encrypter.encrypt(theList[index].infoID.toString(), iv: iv);

                                              log(encrypted.base64);

                                              int x = 1;

                                              if(clicked == "s&m"){
                                                x = 1;
                                              }else if(clicked == "books"){
                                                x = 2;
                                              }

                                              String url = ("showMovies?id=" + encrypted.base64 + "&ss=" + x.toString()).toString();
                                              //String url = ("http://localhost:1675/showMovies?id=" + Uri.decodeFull(encrypted.base64) + "&ss=" + x.toString()).toString();

                                              print(url);

                                              html.window.open(url,"_blank");


                                              //final prefs = await SharedPreferences.getInstance();

                                             // prefs.setString('movieID', theList[index].infoID.toString());


                                              //Get.toNamed(Routes.showMovies);
                                              //html.window.open('https://pandarosh.com/showMovies',"_blank");
                                             // html.window.open('http://localhost:21654/showMovies',"_blank");


                                            },
                                            child: HoverCrossFadeWidget(
                                              duration:
                                              Duration(milliseconds: 500),
                                              firstChild: Container(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: 'assets/kk.gif',
                                                    image: theList[index].urlP,
                                                    height: 300,
                                                    width: 250, //kant 400
                                                    fit: BoxFit.fill,

                                                  ),
                                                ),


                                                /*Image.network(,
                                                    errorBuilder: ,
                                                    loadingBuilder: ,
                                                    placeholder: 'assets/images/logo.png',
                                                    height: size.width*0.050,
                                                    width: size.width*0.050,
                                                  ).image,*/
                                              ) ,
                                              secondChild: Container(
                                                width: 400,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.deepOrange,
                                                        width: 0.5)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                          child: FadeInImage.assetNetwork(
                                                            placeholder: 'assets/kk.gif',
                                                            image: theList[index].urlP,
                                                            height: 250,
                                                            width: 250,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                        /* Image.network(
                                                    theList[index].urlP,
                                                    fit: BoxFit.cover,
                                                    width: 400,
                                                    height: 150,
                                                  )*/,
                                                        const Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Banner(
                                                            color: Colors.red,
                                                            message: 'الجديد',
                                                            location:
                                                            BannerLocation
                                                                .topEnd,
                                                          ),
                                                        ),
                                                        /*Positioned(
                                                top: 10,
                                                  right: 10,
                                                  child:Container(
                                                    color: Colors.black38,
                                                    child: const Text('10:54',style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                      textAlign: TextAlign.start,),
                                                  )
                                                )*/
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 8.0),
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Text(
                                                          theList[index].name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Get.isDarkMode
                                                                ? Colors.white
                                                                : const Color(
                                                                0XFF215480),
                                                            fontSize: 20,
                                                          ),
                                                          textAlign:
                                                          TextAlign.start,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                              ),
                            ],
                          ),
                        ),
                        clicked == "books"
                            ? CardScreen(
                          isBook: true,
                          isFav: false,
                          isLib: false,
                          isMovies: false,
                        )
                            : clicked == "s&m"
                            ? CardScreen(
                          isBook: false,
                          isFav: false,
                          isLib: false,
                          isMovies: true,
                        )
                            : clickMe
                            ? CardScreen(
                          isBook: false,
                          isFav: false,
                          isLib: true,
                          isMovies: false,
                        )
                        /*: clickMe
                                  ? CardScreen(
                                      isBook: false,
                                      isFav: false,
                                      isLib: true,
                                      isMovies: false,
                                    )*/
                            : CardScreen(
                          isBook: false,
                          isFav: true,
                          isLib: false,
                          isMovies: false,
                        ),
                      ],
                    ),
                  ),

/*
                  //bottom
                  showPlayerGlobal //here
                      ? thePlayer()
                      : Container()
*/

                ],
              ),
            ),
          );
/*        },
      ),
    );*/
  }

  List<mainL> tempList = [];

  void filter(String enteredKeyword) {
    List<mainL> results = [];


    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users

      setState((){
        theList = tempList;
      });

    } else {

      results = theList.where((name) => name.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      setState((){
        theList = results;
      });

        // we use the toLowerCase() method to make it case-insensitive
    }


  }



  void signInWithGoogle() async {
    // Create a new provider

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )));
        });

    try{

      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
        checkIfFirstTime(value.user?.displayName ?? "error", value.user?.email ?? "error", value.user?.photoURL ?? "error", "google");
      });

    }catch(error){
      Navigator.of(context).pop();
      log("error here:" + error.toString());
    }

  }

  void signInWithFacebook() async {

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )));
        });

    try{

      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithPopup(facebookProvider).then((value) {
        checkIfFirstTime(value.user?.displayName ?? "error", value.user?.email ?? "error", value.user?.photoURL ?? "error", "facebook");
      });


    }catch(error){
      Navigator.of(context).pop();
      log("error here:" + error.toString());
    }


    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
  }


  void checkIfFirstTime(name, email, picURL, loggedWith) async{

    //checkDataBase
    try {
      //s&m
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/users.json?orderBy="email"&equalTo="$email"');

      await http.get(url).then((value) async {

        if (value.body == "{}") {
          //first time
          newAccount(name, email, picURL, loggedWith);
        }
        else {
          //logged before

          final prefs = await SharedPreferences.getInstance();

          prefs.setString('email', email);

          Navigator.of(context).pop();

          Navigator.of(context).popAndPushNamed(Routes.categoryMovies);

        }

      });
    } catch (e) {
      log(e.toString());
    }

  }

  void newAccount(name, email, picURL, loggedWith) async {

    try{


      final url = Uri.parse('https://pandarosh-91270-default-rtdb.firebaseio.com/users.json');

      await http
          .post(
        url,
        body: json.encode({
          'name': name,
          'email': email,
          'picURL': picURL,
          'loggedWith': loggedWith,

        }),
      ).then((value) async{

        final prefs = await SharedPreferences.getInstance();

        prefs.setString('email', email);

        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(Routes.categoryMovies);

      });


    }catch(err){
      log(err.toString());
    }

  }



}
