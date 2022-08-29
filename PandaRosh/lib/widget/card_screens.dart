import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/unit/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CardScreen extends StatefulWidget {
  bool isMovies = true;
  bool isBook = false;
  bool isFav = false;
  bool isLib = false;

  CardScreen(
      {Key? key,
      this.isMovies: false,
      this.isBook: false,
      this.isFav: false,
      this.isLib: false})
      : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  String email = "";

  @override
  void initState() {
    super.initState();

    checkLogged();
  }

  void checkLogged() async {
    final prefs = await SharedPreferences.getInstance();

    email = prefs.getString('email') ?? "";

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      color: Get.isDarkMode ? const Color(0XFF2B2D2F) : const Color(0XFFF8F8F8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
             // color: Colors.black12,
              child: InkWell(
                onTap: (){
                  Get.offNamed(Routes.homeScreen);
                },
                child: Image.asset(
                  'assets/images/logoi.png',
                  width: 70,
                  height: 90,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "s&m");

                Navigator.of(context).popAndPushNamed(Routes.categoryMovies);
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.clapperboard,
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'المسلسلات و الافلام',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.clapperboard,
                      color:
                          widget.isMovies ? Colors.deepOrange : Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'المسلسلات و الافلام',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: widget.isMovies
                              ? Colors.deepOrange
                              : Color(0xFFA1A5AC),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "books");

                Navigator.of(context).popAndPushNamed(Routes.categoryMovies);
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.bookMedical,
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'الكتب',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.bookMedical,
                      color:
                          widget.isBook ? Colors.deepOrange : Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'الكتب',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: widget.isBook
                              ? Colors.deepOrange
                              : Color(0xFFA1A5AC),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();

                prefs.setString('clicked', "libS&M");

                //Navigator.of(context).pop();
                Navigator.of(context).popAndPushNamed(Routes.categoryMovies);


                //book
                /*final prefs =
                          await SharedPreferences.getInstance();

                          await prefs.setString('clicked', "libBooks").then((value) {

                            Navigator.of(context).pop();
                            Navigator.of(context).popAndPushNamed(Routes.categoryMovies);

                          });*/
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      Icons.library_music,
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'مكتبتي',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.library_music,
                      color:
                          widget.isLib ? Colors.deepOrange : Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'مكتبتي',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: widget.isLib
                              ? Colors.deepOrange
                              : Color(0xFFA1A5AC),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
            final prefs = await SharedPreferences.getInstance();

            prefs.setString('clicked', "favS&M");

           // Navigator.of(context).pop();
            Navigator.of(context).popAndPushNamed(Routes.categoryMovies);

            //book
            //  final prefs =
            /*   await SharedPreferences.getInstance();

                          prefs.setString('clicked', "favBooks");

                          Navigator.of(context).pop();
                          Navigator.of(context).popAndPushNamed(Routes.categoryMovies);*/
            },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.heartCircleBolt,
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'المفضله',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 18),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.heartCircleBolt,
                      color:
                          widget.isFav ? Colors.deepOrange : Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'المفضله',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: widget.isFav
                              ? Colors.deepOrange
                              : Color(0xFFA1A5AC),
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: ()  {
                ThemeController().changeTheTheme();
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children:  [
                    Icon(
    Get.isDarkMode?FontAwesomeIcons.lightbulb:FontAwesomeIcons.moon,
                      color:   Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      Get.isDarkMode?'الوضع الفاتح':'الوضع الغامق',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
    Get.isDarkMode?FontAwesomeIcons.lightbulb:FontAwesomeIcons.moon,
                      color:
                       Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      Get.isDarkMode?'الوضع الفاتح':'الوضع الغامق',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color:  Color(0xFFA1A5AC),
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: ()  {
                Get.defaultDialog(
                  title: 'تواصل معنا',
                  barrierDismissible: false,
                  buttonColor:
                  Colors.deepOrange,
                  content: Column(
                    children: [
                      Text(
                          ':اذا كان لديك اقتراح او شكوي تواصل معنا عن طريق'),
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
                  cancelTextColor:Get.isDarkMode?Colors.white: Colors.black,
                  textCancel: 'العوده',
                );
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.faceGrinHearts,
                      color:   Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'تواصل معنا',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.faceGrinHearts,
                      color:   Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'تواصل معنا',
                      maxLines:2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color:
                          Color(0xFFA1A5AC),
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: ()  {
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
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Column(
                  children: const [
                    Icon(
                      FontAwesomeIcons.peoplePulling,
                      color:   Colors.deepOrange,
                      size: 50,
                    ),
                    Text(
                      'من نحن',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.deepOrange, fontSize: 16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.peoplePulling,
                      color:   Color(0xFFA1A5AC),
                      size: 50,
                    ),
                    Text(
                      'من نحن',
                      maxLines:2,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color:
                          Color(0xFFA1A5AC),
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),





            const SizedBox(
              height: 25,
            ),
            PopupMenuButton(
                child: HoverWidget(
                  onHover: (event) {},
                  hoverChild: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(
                          'الاعدادات',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        color: Color(0xFFA1A5AC),
                        size: 20,
                      ),
                      Expanded(
                        child: Text(
                          'الاعدادات',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xFFA1A5AC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) {

                  log("email: " + email);


                  if(email == ""){

                    return <PopupMenuEntry<Text>>[
                     /* PopupMenuItem<Text>(
                          child:  TextButton(onPressed: (){
                            ThemeController().changeTheTheme();
                            Get.back();
                          },
                            child:Row(
                              children: [
                                Icon(Get.isDarkMode?FontAwesomeIcons.lightbulb:FontAwesomeIcons.moon,
                                  size: 20,),
                                const SizedBox(width: 10,),
                                Text(Get.isDarkMode?'تفعيل الوضع الفاتح':'تفعيل الوضع الغامق',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),)
                      ),
                      PopupMenuItem<Text>(
                          child: TextButton(
                              onPressed: (){

                            Get.defaultDialog(
                              title: 'تواصل معنا',
                              barrierDismissible: false,
                              buttonColor:
                              Colors.deepOrange,
                              content: Column(
                                children: [
                                  Text(
                                      ':اذا كان لديك اقتراح او شكوي تواصل معنا عن طريق'),
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
                              cancelTextColor: Colors.black,
                              textCancel: 'العوده',
                            );

                          }, child:const Text('تواصل معنا'))
                      ),*/
                    ];

                  }
                  else{
                    return <PopupMenuEntry<Text>>[
                     /* PopupMenuItem<Text>(
                          child:  TextButton(onPressed: (){
                            ThemeController().changeTheTheme();
                            Get.back();
                          },
                            child:Row(
                              children: [
                                Icon(Get.isDarkMode?FontAwesomeIcons.lightbulb:FontAwesomeIcons.moon,
                                  size: 20,),
                                const SizedBox(width: 10,),
                                Text(Get.isDarkMode?'تفعيل الوضع الفاتح':'تفعيل الوضع الغامق',
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),)
                      ),
                      PopupMenuItem<Text>(
                          child: TextButton(onPressed: (){}, child:const Text('تواصل معنا'))
                      ),*/
                      PopupMenuItem<Text>(
                          child: TextButton(
                              onPressed: () async {
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
                              child: const Text('تسجيل الخروج')))
                    ];

                  }


                }),
          ],
        ),
      ),
    );
  }
}
