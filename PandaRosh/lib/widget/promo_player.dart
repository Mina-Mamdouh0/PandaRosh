import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pandarosh/Bloc/cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/states.dart';
import '../models/book_in_row.dart';
import 'package:http/http.dart' as http;

class promoPlayer extends StatefulWidget {
  const promoPlayer({Key? key}) : super(key: key);

  @override
  State<promoPlayer> createState() => _promoPlayerState();
}

class _promoPlayerState extends State<promoPlayer> with SingleTickerProviderStateMixin{

  late AnimationController controller;



  final player = AudioPlayer();

  bool showPlayerGlobal = false;

  //late AnimationController controller;

  bool playing = false;


  void initPlayer() async{

    final prefs = await SharedPreferences.getInstance();

    player.playerStateStream.listen((playerState) async{
      var isPlaying = playerState.playing;
      var processingState = playerState.processingState;

      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {


        setState((){
          playing = false;
          loading = true;
        });

        log("loading");

      }
      else if(processingState == ProcessingState.completed){

        log("complettteedd");

      }
      else if (!isPlaying) {

        setState((){
          playing = false;
          loading = false;
          //emit(PandaroshTestState());
        });
        log("!isPlaying");


      }
      else {

        setState((){
          playing = true;
          loading = false;
          prefs.setBool('alreadyPlaying', true);
        });



        //emit(PandaroshTestState());
        log("else");

      }
    });


    player.positionStream.listen((timeNow) {

      setState((){
        newTime = timeNow.inMicroseconds.toDouble();
        newTime2 = timeNow.inMicroseconds.toDouble();
      });

      // emit(PandaroshTestState());
    });


    player.durationStream.listen((totalDuration) {

      setState((){
        episodeTime = totalDuration?.inMicroseconds.toDouble() ?? Duration.zero.inMicroseconds.toDouble();
      });
      //player.play();
      //emit(PandaroshTestState());
    });

    //showPlayerGlobal = false;
    //prefs.setBool('showPlayerGlobal', false);
    //emit(PandaroshTestState());


  }

  bool loading = true;
  bool isMute=true;
  bool isCopy=false;


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
  String episode = "";


  void playPause(){
    if(playing){

      setState((){
        playing = false;
        player.pause();
      });

      //emit(PandaroshTest2State());

    }else {


      setState((){
        playing = true;
        player.play();
      });

      // emit(PandaroshTest3State());

    }

    // emit(PandaroshTestState());

  }


/*
  Future<void> addToFav() async {

    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/fav.json');

      await http
          .post(
        url,
        body: json.encode({
          //'userID': userID,
          'info': clicked,
          //'loggedWith': loggedWith,
        }),
      )
          .then((value) async {

       // showToast("تم الإضافة الي المفضلة");

      });
    } catch (err) {
      log(err.toString());
    }

  }
*/


  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    player.stop();
    initPlayer();
    startAud();

  }

  @override
  void dispose() {
    controller.dispose();
    player.dispose();
    super.dispose();
  }



  //bool playing = false;

  void startAud() async{

    log("startAud");

    // Try to load audio from a source and catch any errors.
    try {

      final prefs = await SharedPreferences.getInstance();




      await player.setAudioSource(AudioSource.uri(Uri.parse(prefs.getString('promo') ?? ""))
      ).then((value) {
        log("startAud 2");
        player.play();
        //emit(PandaroshTestState());
      });

    } catch (e) {
      print("Error loading audio source: $e");
    }


  }

  double newTime = 0;
  double newTime2 = 0;
  double episodeTime = 0;
  //double shownTime = 0;



  String formatedTime(int secTime) {

    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(sec.toString()) + " : " + getParsedTime(min.toString());

    return parsedTime;
  }








  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return /*BlocProvider(
      create: (BuildContext context) => PandaroshCubit()*//*..initAlter()*//*,
      child: BlocConsumer<PandaroshCubit, PandaroshStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = PandaroshCubit.get(context);
          return*/ Card(
      color: context.theme.backgroundColor,
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Row(
              children:  [


                //button here

                MaterialButton(
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
                  color: Colors.deepOrange,
                  child:  Text('اشتري ب 1 دولار ',
                    style: TextStyle(
                        fontFamily: 'aribic',
                        fontSize: size.width*0.012,color: Colors.white
                    ),),
                  /*padding: const EdgeInsets.only(top:10, right: 12,
                                      left: 12,
                                      bottom: 20),*/
                ),



                /*const Spacer(),*/
                /*(size.width>710)? InkWell(
                        onTap: (){

                          addToFav();

                        },
                          child: Icon(FontAwesomeIcons.heartCircleBolt,color: Colors.red,)
                      ):Container(),*/
/*              SizedBox( width: size.width*0.012,),
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

                                            // await launchUrl(Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$urlToShare&quote=$textToShare'));
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

                                            //  await launchUrl(Uri.parse('https://twitter.com/intent/tweet?url=$urlToShare&text=$textToShare'));
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

                                            //await launchUrl(Uri.parse('https://api.whatsapp.com/send?text=$textToShare\n$urlToShare'));
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


                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        cancelTextColor:
                        Colors.black,
                        textCancel: 'العوده',
                      );
                    },
                    child: Icon(
                      Icons.share,
                      color: Colors.deepOrange,
                      size: size.width * 0.025,
                    )),*/
                VerticalDivider(color: Colors.grey.shade300,
                  thickness: 2,
                  indent: 10,endIndent: 10,),



                //middle part
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:  [

                          Text(formatedTime(episodeTime ~/ 1000000).toString().toString(),style: TextStyle(color: Colors.blueAccent,fontSize: 15),),

                          //Text(formatedTime(newTime2 ~/ 1000000).toString(),style: TextStyle(color: Colors.blueAccent,fontSize: 15),),

                          const Spacer(),
                          //const  Icon(Icons.loop_sharp,color: Colors.grey,size: 20,),
                          const Spacer(),

                          loading? RotationTransition(
                            turns: Tween(begin: 0.0, end: 1.0).animate(controller),
                            child: Icon(Icons.play_circle_filled_sharp,color: Colors.blue,size: 40,),
                          )
                              :InkWell(
                              onTap: (){

                                setState((){
                                  playPause();
                                });

                              },
                              child: playing ? Icon(Icons.pause_circle_filled,color: Colors.blue,size: 40,) : Icon(Icons.play_circle_filled_sharp,color: Colors.blue,size: 40,)
                          ),



                          const Spacer(),
                          // const Icon(Icons.audiotrack,color: Colors.grey,size: 20,),
                          const Spacer(),

                          Text(formatedTime(newTime2 ~/ 1000000).toString(),style: TextStyle(color: Colors.blueAccent,fontSize: 15),),

                          //Text(formatedTime(episodeTime ~/ 1000000).toString().toString(),style: TextStyle(color: Colors.blueAccent,fontSize: 15),)
                        ],
                      ),

                      //slider
                      Expanded(
                        child:

                        /*ValueListenableBuilder<ProgressBarState>(
                              valueListenable: progressNotifier,
                              builder: (_, value, __) {
                                return ProgressBar(
                                  progress: value.current,
                                  buffered: value.buffered,
                                  total: value.total,
                                );
                              },
                            ),*/

                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Slider(
                            value: newTime,
                            min: 0.0,
                            max: episodeTime,
                            thumbColor: Colors.blueAccent,
                            label: "sda",
                            inactiveColor: Colors.grey.shade300,
                            activeColor: Colors.grey.shade300,
                            onChanged: (value){
                              setState((){
                                newTime = value;
                                //shownTime = value * episodeTime;
                                print(value);
                              });
                            },
                            onChangeEnd: (v){
                              //load in the AudioPlayer

                              player.seek(Duration(microseconds: v.toInt()));

                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),




                VerticalDivider(color: Colors.grey.shade300,
                  thickness: 2,
                  indent: 10,endIndent: 10,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.0),
                  child:  InkWell(
                      onTap: () async{
                        setState((){
                          isMute=! isMute;
                        });

                        if(isMute){
                          await player.setVolume(1);
                        }else{
                          await player.setVolume(0);
                        }

                      }
                      ,child: Icon(isMute?FontAwesomeIcons.volumeHigh:FontAwesomeIcons.volumeMute,color: Colors.deepOrange,)),
                ),
                VerticalDivider(color: Colors.grey.shade300,
                  thickness: 2,
                  indent: 10,endIndent: 10,),

              ],
            ),
          ),
        ),
      ),
    );
/*        },
      ),
    );*/

  }
}
