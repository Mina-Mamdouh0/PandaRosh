import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/widget/back_ground_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenMobile> {
  bool isLogin=false;
  bool isShowCategory=false;


  String userEmail = "";

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/qqww.mp4');


    getData();
  }

  void getData() async{

    _controller.initialize();

    final prefs = await SharedPreferences.getInstance();

    setState((){
      userEmail = prefs.getString('email') ?? "";
    });


  }
  
  void showDialogInstall(){
    Get.defaultDialog(
      title: 'طريقه الثبيت',
      barrierDismissible: false,
      buttonColor:
      Colors.deepOrange,
      content:  SingleChildScrollView(
        child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(
                'طريقه الثبيت علي الموبيل',
                style: TextStyle(
                    fontFamily: 'aribic',
                    fontSize:15,
                    color: Colors.white),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                child: Image.asset('',),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                child: Image.asset('',),
              ),
             
            ]

        ),
      ),
      cancelTextColor:Get.isDarkMode?Colors.white: Colors.black,
      textCancel: 'العوده',
    );
  }


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              const BackGroundImage(),
              Container(
                color: Colors.black54,
              ),
              Padding(
                padding:const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(

                            decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.fill,
                              width: size.width * 0.2,
                              height: size.width * 0.25,
                            ),
                          ),
                          userEmail.isEmpty ?
                          AnimatedSwitcher(
                            duration:  const Duration(milliseconds: 600),
                            switchInCurve: Curves.linear,
                            reverseDuration: const Duration(milliseconds: 600),
                            child: isLogin?
                            Container(
                              color: Colors.black26,
                              padding:  const EdgeInsets.all(22.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        signInWithFacebook();
                                      },
                                      child: Image.asset(
                                        "assets/images/facebook.png",
                                        fit: BoxFit.fill,
                                        width: size.height*0.030,
                                        height: size.height*0.030,
                                      ),
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
                                        width: size.height*0.030,
                                        height: size.height*0.030,
                                      ),
                                    )
                                  ]),
                            ):MaterialButton(onPressed: (){
                              setState(() {
                                isLogin=!isLogin;
                              });
                            },
                              child: Padding(
                                padding:  const EdgeInsets.all(8.0),
                                child:   Text('تسجيل الدخول',
                                  style: TextStyle(
                                      fontFamily: 'aribic',
                                      fontSize: size.width*0.025,color: Colors.white
                                  ),),
                              ),
                              shape: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 3
                                  )
                              ),
                              padding:  EdgeInsets.symmetric(vertical: size.height*0.015,horizontal: size.width*0.008),
                            ),

                          )
                              : Container(),

                        ],
                      ),
                      //SizedBox(height: size.height*0.02,),
/*
                      Text('باندا روش',style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: size.width*0.125,
                          fontFamily: 'aribic',
                          fontWeight: FontWeight.bold,
                          wordSpacing: 1.5,
                          letterSpacing: 0.5,
                          fontStyle: FontStyle.italic,
                          shadows: const [
                            Shadow(color: Colors.orangeAccent,offset: Offset(3, 3)),
                            Shadow(color: Colors.white,offset: Offset(4, 4)),
                          ]
                      ),),
*/


                      Image.asset(
                        "assets/images/name.png",
                        fit: BoxFit.fill,
                        width: size.width * 0.50,
                        height: size.width * 0.25,
                      ),
                      //SizedBox( height: size.height*0.01,),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          color: Colors.black54,
                          child: Text(
                            'كتب صوتية بطريقة سينمائية',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'aribic',
                              fontSize: size.width * 0.07,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black38,
                        child: Text('استمع لاقوى واحلى المسلسلات المسموعه واستمتع بالكتب الصوتية',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'aribic',
                            fontSize: size.width*0.035,fontWeight: FontWeight.bold,
                          ),),
                      ),
                      SizedBox( height: size.height*0.01,),
                      AnimatedSwitcher(
                        duration:  const Duration(milliseconds: 600),
                        switchInCurve: Curves.linear,
                        reverseDuration: const Duration(milliseconds: 600),
                        child: isShowCategory?Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap:() async{

                                final prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString('clicked', "s&m");

                                Get.toNamed(Routes.categoryMovies);

                              },
                              child: SizedBox(
                                width: size.width*0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 2
                                          )
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset('assets/images/film.jpg',
                                          fit: BoxFit.fill,width: size.width*0.2,height: size.width*0.2,),
                                      ),
                                    ),
                                    const SizedBox( height: 10,),
                                    Container(
                                      color: Colors.black12,
                                      child:  Text(
                                        'المسلسلات والأفلام المسموعة',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'aribic',
                                          fontSize: size.width*0.03,fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.white,
                                                  offset: Offset(1, 1)),
                                              Shadow(
                                                  color: Colors.deepOrange,
                                                  offset: Offset(3, 3)),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox( width: 15,),
                            InkWell(
                              onTap:() async{
                                final prefs = await SharedPreferences.getInstance();

                                prefs.setString('clicked', "books");

                                Get.toNamed(Routes.categoryMovies);

                              },
                              child: SizedBox(
                                width: size.width*0.25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset('assets/images/book.jpg',
                                          fit: BoxFit.fill,width: size.width*0.2,
                                          height: size.width*0.2,),
                                      ),
                                    ),
                                    const SizedBox( height: 10,),
                                    Container(
                                      color:Colors.black12,
                                      child:  Text('الكتب',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'aribic',
                                          fontSize: size.width*0.04,fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                  color: Colors.white,
                                                  offset: Offset(1, 1)),
                                              Shadow(
                                                  color: Colors.deepOrange,
                                                  offset: Offset(3, 3)),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),



                          ],
                        ):Center(
                          child: MaterialButton(onPressed: (){
                            setState(() {
                              isShowCategory=!isShowCategory;
                            });
                          },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            color: Colors.deepOrange,
                            child: Padding(
                              padding:  const EdgeInsets.all(8.0),
                              child:   Text('بدا الاستخدام',
                                style: TextStyle(
                                    fontFamily: 'aribic',
                                    fontSize: size.width*0.045,color: Colors.white
                                ),),
                            ),
                            padding:EdgeInsets.symmetric(vertical: size.height*0.015,horizontal: size.width*0.024),
                          ),
                        ),),



                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(onPressed: (){

                    Get.defaultDialog(
                      title: 'انشر كتابك',
                      barrierDismissible: false,
                      buttonColor:
                      Colors.deepOrange,
                      content: Column(
                        children: [
                          Container(
                            height: size.width * 0.52,
                            width: size.width * 0.82,
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
                                              height: size.width * 0.52,
                                              width: size.width * 0.82,
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
                    color: Colors.deepOrange,
                    child: Text('انشر كتابك',
                      style: TextStyle(
                          fontFamily: 'aribic',
                          fontSize: size.width*0.04,color: Colors.white
                      ),),
                    padding:  EdgeInsets.symmetric(vertical: size.height*0.015,horizontal: size.width*0.024),
                  ),
                ),

              )

            ],
          ),
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    // Create a new provider

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: CircularProgressIndicator()));
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
          return Container(child: Center(child: CircularProgressIndicator()));
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

          Navigator.of(context).popAndPushNamed(Routes.homeScreen);

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

        Navigator.of(context).popAndPushNamed(Routes.homeScreen);

      });


    }catch(err){
      log(err.toString());
    }

  }



}