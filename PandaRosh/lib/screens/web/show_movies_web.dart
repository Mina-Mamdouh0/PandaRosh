import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Bloc/states.dart';
import '../../models/book_in_row.dart';
import '../../models/book_in_row_m.dart';
import '../../models/main.dart';
import '../../unit/routes.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandarosh/Bloc/cubit.dart';

import 'dart:html' as html;

import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:oktoast/oktoast.dart';

import '../../widget/player.dart';

import 'package:video_player/video_player.dart';

import 'package:flutter/services.dart';

import '../../widget/promo_player.dart';

class ShowMoviesWeb extends StatefulWidget {
  const ShowMoviesWeb({Key? key}) : super(key: key);

  @override
  _ShowMoviesState createState() => _ShowMoviesState();
}

class _ShowMoviesState extends State<ShowMoviesWeb> {
  bool isSoundIcon = true;
  IconData icons = Icons.play_circle_fill;

  bool showOffers = true;

  List<bookInRowM> firstList = [];

  late VideoPlayerController _controller;


  String name = "";
  String category = "";
  String writerName = "";
  String about = "";
  String profits = "";
  String time = "";
  String episodesNum = "";
  String urlB = "";
  String urlP = "";
  String num = "";

  String refB = "";
  String refP = "";

  String categoryID = "";
  String writerNameID = "";

  String movieID = "";

  String clicked = "";

  bool loading = false;

  bool isCopy = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/videos/qqww.mp4');


    getData();
    getLast();
    BackButtonInterceptor.add(myInterceptor);
  }

  String userEmail = "";
  String userID = "";

  bool showPlayerGlobal = false;

  void getLast() async{

    final prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString('email') ?? "";


    if (userEmail == "") {


      setState((){
        showPlayerGlobal = false;
      });

      prefs.setBool('showPlayerGlobal', false);
      //emit(PandaroshTestState());

    }
    else {

      userID = prefs.getString('ID').toString();

      try {

        final url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/lastPlayed.json?orderBy="user"&equalTo="$userID"');

        await http.get(url).then((value) async {
          if (value.body == "{}") {

            setState((){
              showPlayerGlobal = false;
            });

            prefs.setBool('showPlayerGlobal', false);
            //
            // emit(PandaroshTestState());

          }
          else {
            //found data

            final extractedData = json.decode(value.body);


            showPlayerGlobal = true;
            prefs.setBool('showPlayerGlobal', true);

            //load last played Audio
            prefs.setString('lastClicked', extractedData['lastClickedMnBara'] ?? ""); //movie mn bara
            prefs.setString('lastClickedMovie', extractedData['lastClickedMovie'] ?? "");
            prefs.setString('lastClickedEpisode', extractedData['lastClickedEpisode'] ?? "");

            //getData();
            //nkml mn hna

          }
        });
      } catch (e) {
        log(e.toString());
      }
    }

  }


  Future<void> deleteFav() async {

    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/fav/$favIdToDelete.json');

      await http
          .delete(
        url,
      )
          .then((value) async {

        setState((){
          isFav = false;
        });
        getFav();
        showToast("تم الحذف من المفضلة");

      });
    } catch (err) {
      log(err.toString());
    }

  }

  Future<void> addToFav() async {

    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json');

      await http
          .post(
        url,
        body: json.encode({
          'userID': userID,
          'name': name,
          'num': "0",
          'urlB': urlB,
          'urlP': urlP,
          'info': movieID,
          'type': clicked,


        }),
      )
          .then((value) async {

            setState((){
              isFav = true;
            });
        showToast("تم الإضافة الي المفضلة");

      });
    } catch (err) {
      log(err.toString());
    }

  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


  String audioURLPromo = "";
  String audioRefPromo = "";

  final player = AudioPlayer();

  void PlayPromo() async{

    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(
          audioURLPromo))
      ).then((value) {
        log("startAud Promo");
        player.play();
        //emit(PandaroshTestState());
      });

    } catch (e) {
      print("Error loading audio source: $e");
    }

  }


  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    log("BACK BUTTON!");
    // Do some stuff.

    Get.offNamed(Routes.categoryMovies);

    return true;
  }

  //String myurl = Uri.base.toString(); //get complete url
  //String para1 = Uri.base.queryParameters["para1"];

  String URLId = "a";
  String URLClicked = "a";

  Future<void> getData() async {

    _controller.initialize();


    setState(() {
      loading = true;
    });

    name = "";

    category = "";
    writerName = "";

    about = "";
    profits = "";
    time = "";

    num = "";

    episodesNum = "";
    urlB = "";
    urlP = "";

    refB = "";
    refP = "";

    categoryID = "";
    writerNameID = "";

    clicked = "";

    audioURLPromo = "";
    audioRefPromo = "";

    try {
      final prefs = await SharedPreferences.getInstance();

      log("movieID: " + movieID);
      log("clicked: " + clicked);



      final uri = Uri.dataFromString(html.window.location.href);
      print(uri);

      URLId = Uri.decodeFull(uri.queryParameters["id"] ?? "");
      URLClicked = uri.queryParameters["ss"] ?? "";

      // print(URLId);
      //print(Uri.decodeFull(URLId));

      log("from url: " + URLId);
      log("from url clicked: " + URLClicked);



        final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
        final iv = encrypt.IV.fromLength(16);

        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        final decrypted = encrypter.decryptBytes(encrypt.Encrypted.fromBase64(URLId), iv: iv);
        final decryptedData = utf8.decode(decrypted);

        log(decryptedData);

        movieID = decryptedData;
        prefs.setString('movieID', movieID.toString());

        if(URLClicked == "1"){
          prefs.setString('clicked', "s&m");
        }else if(URLClicked == "2"){
          prefs.setString('clicked', "books");
        }

        clicked = prefs.getString('clicked').toString();




      log("movieID: " + movieID);
      log("clicked: " + clicked);

      var url = Uri.parse('');

      if (clicked == "s&m") {
        log("hhhheeeeeeerrrrrr");
        url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo/$movieID.json');
      } else if (clicked == "books") {
        log("555555555555");

        url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/booksInfo/$movieID.json');
      }

      log("url: " + url.toString());

      await http.get(url).then((value) async {
        if (value.body == "{}") {
          log("error loading");
        }
        else {
          final extractedData = json.decode(value.body);

          final urlCat = Uri.parse(
              '${'https://pandarosh-91270-default-rtdb.firebaseio.com/categories/' + extractedData['category']}/name.json');

          log("urlCat: " + urlCat.toString());

          //get category name
          await http.get(urlCat).then((valueCat) async {
            //get writer name
            final urlWrit = Uri.parse(
                '${'https://pandarosh-91270-default-rtdb.firebaseio.com/writers/' + extractedData['writer']}/name.json');
            log("77777777");

            await http.get(urlWrit).then((valueWrit) async {
              setState(() {
                name = extractedData['name'];

                category = json.decode(valueCat.body);
                writerName = json.decode(valueWrit.body);

                categoryID = extractedData['category'];
                writerNameID = extractedData['writer'];

                about = extractedData['about'];
                profits = extractedData['profits'];
                time = extractedData['time'];

                num = extractedData['num'];

                episodesNum = extractedData['episodes'];
                urlB = extractedData['urlB'];
                urlP = extractedData['urlP'];

                refB = extractedData['refB'];
                refP = extractedData['refP'];

                audioURLPromo = extractedData['promoURL'] ?? "";
                audioRefPromo = extractedData['promoRef'] ?? "";

              });

              log("heree");

              getUserData();
              getEpisodesRow();
              //getFav();

            });
          });
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }


  void getUserData(){

    final url = Uri.parse('https://pandarosh-91270-default-rtdb.firebaseio.com/users.json?orderBy="email"&equalTo="$userEmail"');

    log("loggeddd");

    http.get(url).then((value) {
      if (value.body == "{}") {

        log("hna");

      }
      else {

        final extractedData = json.decode(value.body);

        extractedData?.forEach((Key, value) {

          setState((){
            userID = Key;
            log(userID);
            getFav();
          });

        });


        }


    });

  }

  bool showPromo = false;


  Future<void> getEpisodesRow() async {
    firstList = [];

    try {
      //s&m
      var url = Uri.parse('');

      if (clicked == "s&m") {
        url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis.json?orderBy="movie"&equalTo="$movieID"');
      } else if (clicked == "books") {
        url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/booksEpis.json?orderBy="movie"&equalTo="$movieID"');
      }

      await http.get(url).then((value) async {
        log(movieID);
        final extractedData = json.decode(value.body);

        final List<bookInRowM> loadData = [];

        extractedData?.forEach((Key, value) {
          loadData.add(bookInRowM(
            idToEdit: Key,
            name: value['name'],
            urlP: urlP,
            ref: value['ref'],
            EpisodeNum: value['EpisodeNum'],
            url: value['url'],

            episImageRef: value['imageRef'] ?? "",
            episImageUrl: value['imageUrl'] ?? "",

          ));
        });

        setState(() {
          firstList = loadData;
          loading = false;
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }


  bool isFav = false;

  String favIdToDelete = "";

  void getFav(){
    try{

      log("userID: " + userID);


      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json?orderBy="userID"&equalTo="$userID"');


      http.get(url).then((value) {
        if (value.body == "{}") {

        }
        else {
          log(value.body);

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


          loadData.forEach((element) {

            log("element.infoID: " + element.infoID);

            if(element.infoID == movieID){

              setState((){
                isFav = true;
              });

              favIdToDelete = element.idToEdit;

            }
          });

        }
      });

    }catch(e){
      log(e.toString());
    }
  }

  String urlToShare = "www.google.com";
  String textToShare = "يمكنك الان الاستمتاع بمسلسل " ;


  void pausePromo(){

    Get.back();

    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      buttonColor: Colors
          .deepOrange,
      content: Stack(
        children: [
          Center(
            child:
            Column(
              children: [
                Text('اسمع البرومو'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){

                      player.pause();

                      Get.back();

                      startPromo();


                    },
                    child: Icon(
                      Icons.pause_circle_filled,
                      size: 40,
                      color:
                      Colors.deepOrange,
                    ),

                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      onConfirm: (){
        //buy from here

      },
      confirmTextColor: Get.isDarkMode? Colors.white:
      Colors.black,
      cancelTextColor: Get.isDarkMode? Colors.white:
      Colors.black,
      textCancel: 'رجوع',
      textConfirm: "اشتري الان",
      /*onConfirm: (){

                                                    }*/

    );

    PlayPromo();

  }



  void startPromo(){

    Get.defaultDialog(
      title: '',
      barrierDismissible: false,
      buttonColor: Colors
          .deepOrange,
      content: Stack(
        children: [
          Center(
            child:
            Column(
              children: [
                Text('اسمع البرومو'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){

                      pausePromo();

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

        ],
      ),
      onConfirm: (){
        //buy from here

      },
      confirmTextColor: Get.isDarkMode? Colors.white:
      Colors.black,
      cancelTextColor: Get.isDarkMode? Colors.white:
      Colors.black,
      textCancel: 'رجوع',
      textConfirm: "اشتري الان",
      /*onConfirm: (){

                                                    }*/

    );


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
                'طريقه الثبيت علي الجهاز',
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
    var size = MediaQuery.of(context).size;
    return /*BlocProvider(
      create: (BuildContext context) => PandaroshCubit()..getLast(),
      child: BlocConsumer<PandaroshCubit, PandaroshStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PandaroshCubit.get(context);
          return */Title(
      title: name,
      color: Colors.white,
            child: Scaffold(
              backgroundColor: context.theme.backgroundColor,
              body: loading
                  ? Center(child: CircularProgressIndicator())
                  : Directionality(
                textDirection: TextDirection.rtl,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ListView(
                      children: [
                        SizedBox(
                          height: size.width * 0.40,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      FadeInImage.assetNetwork(
                                        placeholder: 'assets/kk.gif',
                                        image: urlB,
                                        width: double.infinity,
                                        fit: BoxFit.fitHeight,
                                        height: size.width * 0.28,
                                      ),
                                      /*Positioned(
                                        //back arrow button
                                        left:  size.width*0.01,
                                        top:  size.width*0.01,
                                        child: Container(
                                          height: size.width*0.035,
                                          width:  size.width*0.035,
                                          decoration:const  BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle
                                          ),
                                          child: InkWell(
                                            onTap: (){
                                              Get.offNamed(Routes.categoryMovies);
                                            },
                                            child:  Center(
                                              child: Icon(Icons.arrow_forward,color: Colors.deepOrange,
                                                size:  size.width*0.03,),
                                            ),),
                                        ),
                                      ),*/
                                      Container(
                                        width: double.infinity,
                                        height: size.width * 0.028,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                                tileMode: TileMode.clamp,
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.white10,
                                                  Colors.white12,
                                                  Colors.white24,
                                                  Colors.white30,
                                                  Colors.white38,
                                                  Colors.white54,
                                                  Colors.white60,
                                                  Colors.white70,
                                                  Colors.white,
                                                ])),
                                      ),
                                      Positioned(
                                        left:  size.width*0.015,
                                        top:  size.width*0.015,
                                        child: Container(
                                          height: size.width*0.08,
                                          width:  size.width*0.05,
                                          decoration:const  BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle
                                          ),
                                          child: InkWell(
                                            onTap: (){
                                             Get.offNamed(Routes.categoryMovies);
                                            },
                                            child:    Container(

                                              decoration: BoxDecoration(
                                                  color: Colors.white30,
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
                                              child: Image.asset(
                                                "assets/images/logo.png",
                                                fit: BoxFit.fill,
                                                width: size.width * 0.35,
                                                height: size.width * 0.35,
                                              ),
                                            ),
                                        ),
                                      )),
                                      /* Positioned(
                                  left:  size.width*0.015,
                                  top:  size.width*0.015,
                                  child: Container(
                                    height: size.width*0.04,
                                    width:  size.width*0.04,
                                    decoration:const  BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        setState(() {
                                          isSoundIcon=!isSoundIcon;
                                        });
                                      },
                                      child:   Icon(isSoundIcon?Icons.volume_up:Icons.volume_off,color: Colors.deepOrange,
                                        size:  size.width*0.05,),),
                                  ),
                                ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.015,
                                              vertical: 10),
                                          child: Container(
                                            height: size.width * 0.05,
                                            width: size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle),
                                            child: InkWell(
                                              onTap: () async{
                                                  //play movie clicked

                                                  /*
                                                  //music palyer
                                                  isShowSoundPlay =
                                                      !isShowSoundPlay;
*/
                                                  /*icons = icons == Icons.pause
                                                      ? Icons.play_circle_fill
                                                      : Icons.pause;*/

                                                  final prefs = await SharedPreferences.getInstance();

                                                  String email = prefs.getString('email').toString();

                                                  if(email.isEmpty){
                                                    //not logged

                                                    Get.defaultDialog(
                                                      title: 'يجب تسجيل الدخول',
                                                      barrierDismissible: false,
                                                      buttonColor: Colors.deepOrange,
                                                      content: Container(
                                                        color: Colors.black26,
                                                        padding:  const EdgeInsets.all(22.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  //Login with facebook

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
                                                                  //Login with google

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
                                                      ),
                                                      confirmTextColor: Colors.white,
                                                      cancelTextColor: Colors.black,
                                                      textCancel: 'رجوع',
                                                      /*onConfirm: (){

                                                      }*/

                                                    );

                                                  }else{
                                                    //already LoggedIn

                                                    Get.defaultDialog(
                                                        title: 'بيانات',
                                                        barrierDismissible: false,
                                                        buttonColor: Colors.deepOrange,
                                                        content: Container(
                                                          color: Colors.black26,
                                                          padding:  const EdgeInsets.all(22.0),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    //Login with facebook

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
                                                                    //Login with google

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
                                                        ),
                                                        confirmTextColor: Colors.white,
                                                        cancelTextColor: Colors.black,
                                                        textConfirm: 'شراء',
                                                        textCancel: 'رجوع',
                                                        onConfirm: (){

                                                        }

                                                    );


                                                  }



                                                  },
                                              child: Icon(
                                                icons,
                                                color: Colors.deepOrange,
                                                size: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width * 0.1,
                                              vertical: 10),
                                          child: Container(
                                            height: size.width * 0.05,
                                            width: size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle),
                                            child: InkWell(
                                              onTap: () async{
                                                //play movie clicked

                                                /*
                                                  //music palyer
                                                  isShowSoundPlay =
                                                      !isShowSoundPlay;
*/
                                                /*icons = icons == Icons.pause
                                                      ? Icons.play_circle_fill
                                                      : Icons.pause;*/

                                                final prefs = await SharedPreferences.getInstance();

                                                String email = prefs.getString('email').toString();

                                                if(email.isEmpty){
                                                  //not logged

                                                  Get.defaultDialog(
                                                    title: 'يجب تسجيل الدخول',
                                                    barrierDismissible: false,
                                                    buttonColor: Colors.deepOrange,
                                                    content: Container(
                                                      color: Colors.black26,
                                                      padding:  const EdgeInsets.all(22.0),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                //Login with facebook

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
                                                                //Login with google

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
                                                    ),
                                                    confirmTextColor: Colors.white,
                                                    cancelTextColor: Colors.black,
                                                    textCancel: 'رجوع',
                                                    /*onConfirm: (){

                                                      }*/

                                                  );

                                                }else{
                                                  //already LoggedIn

                                                  Get.defaultDialog(
                                                      title: 'بيانات',
                                                      barrierDismissible: false,
                                                      buttonColor: Colors.deepOrange,
                                                      content: Container(
                                                        color: Colors.black26,
                                                        padding:  const EdgeInsets.all(22.0),
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  //Login with facebook

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
                                                                  //Login with google

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
                                                      ),
                                                      confirmTextColor: Colors.white,
                                                      cancelTextColor: Colors.black,
                                                      textConfirm: 'شراء',
                                                      textCancel: 'رجوع',
                                                      onConfirm: (){

                                                      }

                                                  );


                                                }



                                              },
                                              child: Icon(
                                                icons,
                                                color: Colors.deepOrange,
                                                size: size.width * 0.05,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )*/
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.20,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10, top: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {

                                                  Get.defaultDialog(
                                                    title: 'اشتري ب 1 دولار',
                                                    barrierDismissible: false,
                                                    buttonColor:
                                                    Colors.deepOrange,
                                                    content:  SingleChildScrollView(
                                                      child: Column(
                                                          crossAxisAlignment:CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children:[
                                                            const SizedBox(width: 5,),
                                                            Text(
                                                              '''جميع المعاملات المالية تتم عن طريق بنك مصر
تستطيع الدفع من خلال الطرق الاتية
- ماستر كارد
-فيزا
-ميزة
-اي محفظة الكترونية او اي كارت مسبق الدفع
(فودافون كاش - اورانج كاش - اتصالات كاش - محافظ البنوك بجميع انواعها)
طريقة الدفع:''',
                                                              style: TextStyle(
                                                                  fontFamily: 'aribic',
                                                                  fontSize:15,
                                                                  color: Colors.white),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ]

                                                      ),
                                                    ),
                                                    cancelTextColor:Get.isDarkMode?Colors.white: Colors.black,
                                                    textCancel: 'العوده',
                                                  );

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
                                                  'اشتري ب 1 دولار',
                                                  style: TextStyle(
                                                      fontFamily: 'aribic',
                                                      fontSize:
                                                      size.width * 0.014,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.020,
                                              ),
                                              ElevatedButton(
                                                onPressed: () async{

                                                 // startPromo();

                                                  final prefs = await SharedPreferences.getInstance();

                                                  prefs.setString('promo', audioURLPromo);

                                                  setState((){
                                                    showPromo = true;
                                                  });


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
                                                  'اسمع البرومو',
                                                  style: TextStyle(
                                                      fontFamily: 'aribic',
                                                      fontSize:
                                                      size.width * 0.014,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.width * 0.020,
                                              ),
                                              InkWell(onTap:() async {


                                                final prefs = await SharedPreferences.getInstance();

                                                userEmail = prefs.getString('email') ?? "";

                                                if(userEmail == "") {
                                                  //not logged

                                                  Get.defaultDialog(
                                                    title: 'يجب تسجيل الدخول',
                                                    barrierDismissible: false,
                                                    buttonColor: Colors
                                                        .deepOrange,
                                                    content: Container(
                                                      color: Colors.black26,
                                                      padding: const EdgeInsets
                                                          .all(22.0),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                //Login with facebook

                                                                signInWithFacebook();
                                                              },
                                                              child: Image.asset(
                                                                "assets/images/facebook.png",
                                                                fit: BoxFit.fill,
                                                                width: size
                                                                    .height *
                                                                    0.030,
                                                                height: size
                                                                    .height *
                                                                    0.030,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                //Login with google

                                                                signInWithGoogle();
                                                              },
                                                              child: Image.asset(
                                                                "assets/images/google.png",
                                                                fit: BoxFit.fill,
                                                                width: size
                                                                    .height *
                                                                    0.030,
                                                                height: size
                                                                    .height *
                                                                    0.030,
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                    confirmTextColor: Colors
                                                        .white,
                                                    cancelTextColor: Colors.black,
                                                    textCancel: 'رجوع',
                                                    /*onConfirm: (){

                                                      }*/

                                                  );
                                                }
                                                else{


                                                  if(isFav){
                                                    //delete from fav

                                                    Get.defaultDialog(
                                                      title: 'سيتم الحذف من المفضلة',
                                                      barrierDismissible: false,
                                                      buttonColor: Colors
                                                          .deepOrange,
                                                      content: Container(
                                                        color: Colors.black26,
                                                        padding: const EdgeInsets
                                                            .all(22.0),
                                                        child: Text("هل انت متأكد ؟"),
                                                      ),
                                                      onConfirm: (){
                                                        Get.back();
                                                        deleteFav();
                                                        },
                                                      confirmTextColor: Colors
                                                          .white,
                                                      cancelTextColor: Colors.black,
                                                      textCancel: 'رجوع',
                                                      textConfirm: "حذف",
                                                      /*onConfirm: (){

                                                      }*/

                                                    );


                                                  }else{

                                                    addToFav();

                                                  }

                                                }

                                              },
                                                  child: Icon(
                                                    isFav? FontAwesomeIcons.solidHeart
                                                        : FontAwesomeIcons.heart,color: Colors.red,size: size.width*0.025,)),
                                              SizedBox(
                                                width: size.width * 0.020,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    isCopy = false;

                                                    Get.defaultDialog(
                                                      title: 'مشاركه',
                                                      barrierDismissible: false,
                                                      buttonColor:
                                                      Colors.deepOrange,
                                                      content: Column(
                                                        children: [
                                                          // Text('انسخ الرابط'),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                  ':شارك هذا المسلسل او الكتاب مع اصدقائك'),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),

                                                  Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      color: Colors.grey.shade300,
                                                      height: 30,
                                                      width: 220,
                                                      child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Center(child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text(html.window.location.href,
                                                                  style: TextStyle(color: Colors.black),),
                                                              ))
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    !isCopy? IconButton(onPressed: (){
                                                      setState((){
                                                        isCopy=true;

                                                        //copy text
                                                        Clipboard.setData(ClipboardData(text: html.window.location.href));

                                                      });
                                                    },
                                                        icon: Icon(Icons.copy,color: Colors.grey,
                                                              size: 30,)) : Container()
                                                  ],
                                                ),
                                                isCopy?SizedBox(height: 10,):Container(),
                                                isCopy?Text('تم النسح بنجاح',style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 15
                                                ),):Container(),


                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: InkWell(
                                                                        onTap: () async {

                                                                          textToShare = "يمكنك الان الاستمتاع بمسلسل " + name;

                                                                          final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
                                                                          final iv = encrypt.IV.fromLength(16);

                                                                          final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                                                          final encrypted = encrypter.encrypt(movieID, iv: iv);

                                                                          log(encrypted.base64);

                                                                          int x = 1;

                                                                          if(clicked == "s&m"){
                                                                            x = 1;
                                                                          }else if(clicked == "books"){
                                                                            x = 2;
                                                                          }

                                                                          urlToShare = "pandarosh.com/showMovies?id=" + encrypted.base64 + "&ss=" + x.toString();

                                                                          String theEnd = 'https://www.facebook.com/sharer/sharer.php?u=$urlToShare&quote=$textToShare';

                                                                          log(Uri.encodeFull(theEnd).toString());
                                                                          log(Uri.parse(Uri.encodeFull(theEnd)).toString());

                                                                          await launchUrl(Uri.parse(Uri.encodeFull(theEnd)));

                                                                          },
                                                                        child: Icon(
                                                                          FontAwesomeIcons
                                                                              .facebook,
                                                                          size: 40,
                                                                          color: Colors
                                                                              .blue,
                                                                        )
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: InkWell(
                                                                        onTap: () async {

                                                                          textToShare = "يمكنك الان الاستمتاع بمسلسل " + name;

                                                                          final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
                                                                          final iv = encrypt.IV.fromLength(16);

                                                                          final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                                                          final encrypted = encrypter.encrypt(movieID, iv: iv);

                                                                          log(encrypted.base64);

                                                                          int x = 1;

                                                                          if(clicked == "s&m"){
                                                                            x = 1;
                                                                          }else if(clicked == "books"){
                                                                            x = 2;
                                                                          }

                                                                          urlToShare = "pandarosh.com/showMovies?id=" + encrypted.base64 + "&ss=" + x.toString();

                                                                          await launchUrl(Uri.parse('https://twitter.com/intent/tweet?url=$urlToShare&text=$textToShare'));
                                                                        },
                                                                        child: Icon(
                                                                          FontAwesomeIcons
                                                                              .twitter,
                                                                          size: 40,
                                                                          color: Colors
                                                                              .blue,
                                                                        )
                                                                    ),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: InkWell(
                                                                        onTap: () async {

                                                                          textToShare = "يمكنك الان الاستمتاع بمسلسل " + name;

                                                                          final key = encrypt.Key.fromUtf8('aswdrfetgyqwertyuftgredsertyuhty');
                                                                          final iv = encrypt.IV.fromLength(16);

                                                                          final encrypter = encrypt.Encrypter(encrypt.AES(key));

                                                                          final encrypted = encrypter.encrypt(movieID, iv: iv);

                                                                          log(encrypted.base64);

                                                                          int x = 1;

                                                                          if(clicked == "s&m"){
                                                                            x = 1;
                                                                          }else if(clicked == "books"){
                                                                            x = 2;
                                                                          }

                                                                          urlToShare = ("pandarosh.com/showMovies?id=" + encrypted.base64 + "&ss=" + x.toString()).toString();

                                                                          await launchUrl(Uri.parse('https://api.whatsapp.com/send?text=$textToShare\n$urlToShare'));

                                                                          //html.window.open('https://api.whatsapp.com/send?text="$textToShare\n$urlToShare"', '_blank');
                                                                        },
                                                                        child: Icon(
                                                                          FontAwesomeIcons
                                                                              .whatsapp,
                                                                          size: 40,
                                                                          color: Colors
                                                                              .green,
                                                                        )
                                                                    ),
                                                                  )




/*                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      color: Colors.grey.shade300,
                                                      height: 30,
                                                      width: 220,
                                                      child: SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Center(child: Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: Text("gthtsdgbdrfg",
                                                                  style: TextStyle(color: Colors.black),),
                                                              ))
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10,),
                                                    !isCopy? IconButton(onPressed: (){
                                                      setState((){
                                                        isCopy=true;



                                                        Get.back();
                                                        Get.defaultDialog(
                                                              title: 'مشاركه',
                                                              barrierDismissible: false,
                                                              buttonColor: Colors.deepOrange,
                                                              content: Column(
                                                                children: [
                                                                  Text('انسخ الرابط'),
                                                                  const SizedBox(height: 10,),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            color: Colors.grey.shade300,
                                                                            height: 30,
                                                                            width: 220,
                                                                            child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Center(child: Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Text("gthtsdgbdrfg",
                                                                                    style: TextStyle(color: Colors.black),),
                                                                                ))
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10,),
                                                                          !isCopy? IconButton(onPressed: (){
                                                                            setState((){
                                                                              isCopy=!isCopy;

                                                                              Get.back();


                                                                            });
                                                                          },
                                                                              icon: Icon(Icons.copy,color: Colors.grey,
                                                                                size: 30,)): Container()
                                                                        ],
                                                                      ),
                                                                      isCopy?SizedBox(height: 10,):Container(),
                                                                      isCopy?Text('تم النسح بنجاح',style: TextStyle(
                                                                          color: Colors.deepOrange,
                                                                          fontSize: 15
                                                                      ),):Container()
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              cancelTextColor: Colors.black,
                                                              textCancel: 'العوده',
                                                        );

                                                      });
                                                    },
                                                        icon: Icon(Icons.copy,color: Colors.grey,
                                                              size: 30,)) : Container()
                                                  ],
                                                ),
                                                isCopy?SizedBox(height: 10,):Container(),
                                                isCopy?Text('تم النسح بنجاح',style: TextStyle(
                                                    color: Colors.deepOrange,
                                                    fontSize: 15
                                                ),):Container()*/
                                                                ],
                                                              ),


                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      cancelTextColor:
                                                      Get.isDarkMode? Colors.white:
                                                      Colors.black,
                                                      textCancel: 'العوده',
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.share,
                                                    color: Colors.deepOrange,
                                                    size: size.width * 0.025,
                                                  )),
                                              SizedBox(
                                                width: size.width * 0.020,
                                              ),
                                              ElevatedButton(
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
                                                                                ':اذا اعجبك هذا الكتاب يمكنك الأن التواصل معنا لتحويل كتابك'),
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
                                                                      Get.isDarkMode? Colors.white:
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
                                                              ':اذا اعجبك هذا الكتاب يمكنك الأن التواصل معنا لتحويل كتابك'),
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
                                                    Get.isDarkMode? Colors.white:
                                                    Colors.black,
                                                    textCancel: 'العوده',
                                                  );

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
                                                  'انشر كتابك',
                                                  style: TextStyle(
                                                      fontFamily: 'aribic',
                                                      fontSize:
                                                      size.width * 0.014,
                                                      color: Colors.white),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: size.width * 0.80,
                                          height: size.width * 0.09,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              about,
                                              textAlign: TextAlign.start,
                                              //maxLines: 3,
                                              //softWrap: true,
                                              //overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: size.width * 0.020,
                                                  fontWeight: FontWeight.normal,
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                        //const Spacer(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: size.width * 0.15,
                                  height: size.width * 0.25,
                                  margin: EdgeInsets.symmetric(
                                      vertical: size.width * 0.025,
                                      horizontal: 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : const Color(0XFFEAF5F8),
                                      border: Border.all(
                                          color: Colors.deepOrange, width: 0.5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/kk.gif',
                                            image: urlP,
                                            width: double.infinity,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Get.isDarkMode
                                                ? Colors.black
                                                : const Color(0XFF215480),
                                            fontSize: size.width * 0.015,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5),
                                        child: Text(
                                          writerName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:  Colors.deepOrange,
                                            fontSize: size.width * 0.013,
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Get.isDarkMode ? Colors.white : Colors.grey,
                          height: 2,
                        ),

                        Container(
                            width: double.infinity,
                            height: size.width*0.25,
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            //color:  Get.isDarkMode?const Color(0XFF182430):Colors.white,
                            child: ListView.builder(
                                itemCount: firstList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context,index){
                                  return InkWell(
                                    onTap: () async{
                                      //on tap episode

                                      final prefs =
                                      await SharedPreferences.getInstance();

                                      prefs.setString('lastClickedMovie', movieID.toString());
                                      prefs.setString('lastClickedEpisode', firstList[index].idToEdit.toString());
                                      prefs.setString('lastClicked', clicked);

                                      setState((){
                                        showPlayerGlobal = true;
                                      });

                                      //cubit.getData();
                                      //cubit.initPlayer();
                                    },
                                    child: HoverCrossFadeWidget(
                                      duration: const Duration(milliseconds: 500),
                                      firstChild: Container(
                                        width: size.width*0.15,
                                        height: size.width*0.2,
                                        margin: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color:Get.isDarkMode?
                                          const Color(0XFFEAF5F8):Colors.white
                                          ,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:  BorderRadius.circular(10),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/kk.gif',
                                            image: firstList[index].episImageUrl.isEmpty?
                                            firstList[index].urlP
                                                : firstList[index].episImageUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholderFit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      secondChild:  Container(
                                        color:  Get.isDarkMode?
                                        const Color(0XFF182430):Colors.white,
                                        child: Container(
                                          width: size.width*0.15,
                                          height: size.width*0.2,
                                          margin: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color:Get.isDarkMode?const Color(0XFFEAF5F8):
                                              Colors.white
                                              ,
                                              border: Border.all(
                                                  color: Colors.deepOrange,
                                                  width: 0.5
                                              )
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(10),topLeft: Radius.circular(10)),
                                                  child: FadeInImage.assetNetwork(
                                                    placeholder: 'assets/kk.gif',
                                                    image: firstList[index].episImageUrl.isEmpty?
                                                    firstList[index].urlP
                                                        : firstList[index].episImageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.symmetric(horizontal: size.width*0.006,
                                                    vertical: 8),
                                                child:  Text(firstList[index].name,style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color(0XFF215480),
                                                  fontSize: size.width*0.013,
                                                ),
                                                  textAlign: TextAlign.center,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        showPlayerGlobal
                            ? SizedBox(
                          height: size.width * 0.07,
                        )
                            : Container(),


                        Center(
                            child: Text("جميع الحقوق محفوظة ويمنع بقوة القانون التسجيل والتنزيل والنشر لاي عمل على المنصة",
                            style: TextStyle(
                                color: Get.isDarkMode? Colors.white:
                                Colors.black
                            ),),
                        )

                      ],
                    ),
                    /*showOffers
                        ? Positioned(
                            bottom: 0,
                            right: 10,
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.deepOrange,
                                  height: 150,
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'احدث العروض',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'اشتري كتاب ومعه كتاب هديه',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showOffers = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ))
                        : Container(),*/
                    showPlayerGlobal
                        ? thePlayer()
                        : showPromo?
                        promoPlayer()
                    :Container()
                  ],
                ),
              ),
            ),
          );
/*        },
      ),
    );*/
  }

  void signInWithGoogle() async {
    // Create a new provider

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: CircularProgressIndicator()));
        });

    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithPopup(googleProvider).then((value) {
        checkIfFirstTime(
            value.user?.displayName ?? "error",
            value.user?.email ?? "error",
            value.user?.photoURL ?? "error",
            "google");
      });
    } catch (error) {
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

    try {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance
          .signInWithPopup(facebookProvider)
          .then((value) {
        checkIfFirstTime(
            value.user?.displayName ?? "error",
            value.user?.email ?? "error",
            value.user?.photoURL ?? "error",
            "facebook");
      });
    } catch (error) {
      Navigator.of(context).pop();
      log("error here:" + error.toString());
    }

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
  }

  void checkIfFirstTime(name, email, picURL, loggedWith) async {
    //checkDataBase
    try {
      //s&m
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/users.json?orderBy="email"&equalTo="$email"');

      await http.get(url).then((value) async {
        if (value.body == "{}") {
          //first time
          newAccount(name, email, picURL, loggedWith);
        } else {
          //logged before

          final prefs = await SharedPreferences.getInstance();

          prefs.setString('email', email);

          Navigator.of(context).pop();

          Navigator.of(context).pushNamed(Routes.showMovies);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void newAccount(name, email, picURL, loggedWith) async {
    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/users.json');

      await http
          .post(
        url,
        body: json.encode({
          'name': name,
          'email': email,
          'picURL': picURL,
          'loggedWith': loggedWith,
        }),
      )
          .then((value) async {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('email', email);

        Navigator.of(context).pop();

        Navigator.of(context).pushNamed(Routes.showMovies);
      });
    } catch (err) {
      log(err.toString());
    }
  }
}
