
import 'dart:convert';
import 'dart:developer';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:just_audio/just_audio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/widget/audio_sound.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../models/book_in_row.dart';
import 'package:http/http.dart' as http;

import '../../models/book_in_row_m.dart';
import '../../models/main.dart';
import '../../widget/player_mobile.dart';

import 'dart:html' as html;

import 'package:encrypt/encrypt.dart' as encrypt;


class ShowMoviesMobile extends StatefulWidget {
  const ShowMoviesMobile({Key? key}) : super(key: key);

  @override
  _ShowMoviesState createState() => _ShowMoviesState();
}

class _ShowMoviesState extends State<ShowMoviesMobile> {
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

      if(URLId == ""){

        movieID = prefs.getString('movieID').toString();
        clicked = prefs.getString('clicked').toString();

      }
      else{

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


      }



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
                Text('استمع الي البرومو الان'),
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
      textConfirm: "شراء",
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
                Text('استمع الي البرومو الان'),
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
      textConfirm: "شراء",
      /*onConfirm: (){

                                                    }*/

    );


  }

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Title(
      title: name,
      color: Colors.white,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar:  AppBar(
            foregroundColor: Colors.deepOrange,
            elevation: 0.0,
            backgroundColor:  Get.isDarkMode?const Color(0XFF2B2D2F): const Color(0XFFF8F8F8),
          ),
          backgroundColor: context.theme.backgroundColor,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width*0.4,
                        height: size.height*0.45,
                        margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.isDarkMode?Colors.white:const Color(0XFFEAF5F8),
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
                                  image: urlP,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5,),
                            Padding(
                              padding:const  EdgeInsets.symmetric(horizontal: 8.0),
                              child:  Text(name,style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.isDarkMode?Colors.black:const Color(0XFF215480),
                                fontSize: 20,                              ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,),
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 8.0 ,vertical: 5),
                              child:  Text(writerName,style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                fontSize: 18,
                              ),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child:   Text(about
                          ,textAlign: TextAlign.start,

                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: size.width*0.05,
                              fontWeight: FontWeight.normal,
                              color: Get.isDarkMode?Colors.white:Colors.black
                          ),
                        ),
                      ),
                       Divider(color: Get.isDarkMode?Colors.white:Colors.grey,height: 2,),

                      Container(
                        width: double.infinity,
                        height: 350,
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                        child: ListView.builder(
                          itemCount: firstList.length,
                             scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              return InkWell(
                                onTap: () async {
                                  //on tap episode

                                  final prefs =
                                  await SharedPreferences.getInstance();

                                  prefs.setString(
                                      'lastClickedMovie', movieID.toString());
                                  prefs.setString('lastClickedEpisode',
                                      firstList[index].idToEdit.toString());
                                  prefs.setString('lastClicked', clicked);

/*                                setState(() {
                                    if(showPlayer){

                                    }else{
                                      prefs.setBool('showPlayerGlobal', true);

                                      showPlayer = true;
                                    }

                                  });*/
                                },
                                child: Container(
                                  width: size.width*0.55,
                                  height: size.height*0.35,
                                  margin: const EdgeInsets.only(top: 10,bottom: 10,left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:Get.isDarkMode?Colors.white: const Color(0XFFEAF5F8),
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
                                        padding:  EdgeInsets.symmetric(horizontal: 10.0,
                                            vertical: 8),
                                        child:  Text(firstList[index].name,style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0XFF215480),
                                          fontSize: 20,
                                        ),
                                          textAlign: TextAlign.center,),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                       Divider(color: Get.isDarkMode?Colors.white:Colors.grey,height: 2,),
                      Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                      20,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {

                                  startPromo();

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
                                  'استمع الي البرومو الان',
                                  style: TextStyle(
                                      fontFamily: 'aribic',
                                      fontSize:
                                      20,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
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
                                        : FontAwesomeIcons.heart,color: Colors.red,size: 30,)),

                              SizedBox(
                                width: 5,
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
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 5,
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
                                      20,
                                      color: Colors.white),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                      /*showPlayer?const SizedBox(  height: 80,):Container(),*/
                    ],
                  ),
                ),
                /*showPlayer?MusicPlayer():Container()*/
              ],
            ),
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
