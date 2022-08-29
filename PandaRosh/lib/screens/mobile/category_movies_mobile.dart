import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/widget/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../models/main.dart';
import '../../widget/player_mobile.dart';
import 'package:http/http.dart' as http;

class CategoryMoviesMobile extends StatefulWidget {
  const CategoryMoviesMobile({Key? key}) : super(key: key);

  @override
  State<CategoryMoviesMobile> createState() => _CategoryMoviesMobileState();
}

class _CategoryMoviesMobileState extends State<CategoryMoviesMobile> {
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.deepOrange,
            elevation: 0.0,
            backgroundColor: Get.isDarkMode
                ? const Color(0XFF2B2D2F)
                : const Color(0XFFF8F8F8),
            title:  Row(
              children: [
                InkWell(
                  onTap: (){
                    Get.offNamed(Routes.homeScreen);
                  },
                  child: Image.asset(
                    "assets/images/name.png",
                    fit: BoxFit.fill,
                    width: 150,
                    height: 60,
                  ),
                ),

                const Spacer(),

                Container(
                  //search bar
                  width: size.width*0.50,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 15,),
                  //margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300
                  ),
                  child:  Center(
                    child: TextFormField(
                      onChanged: (v) {

                        filter(v);

                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        suffixIconColor: Colors.deepOrange,
                        hintText: 'ابحث عن المزيد',
                        hintStyle: TextStyle(
                            fontSize: size.width*0.035,
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


              ],
            ),
          ),
          backgroundColor: context.theme.backgroundColor,
          drawer: const BuildDrawer(),
          body: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              //mn awll hhnnaaaaaa
              Container(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.all(5),
                        shrinkWrap: false,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 300,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 2),
                        itemCount: theList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: ()  async{
                              final prefs = await SharedPreferences.getInstance();

                              prefs.setString('movieID', theList[index].infoID.toString());

                              Get.offNamed(Routes.showMovies);
                            },
                            child: Container(
                              width: 400,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrange, width: 0.5)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Stack(
                                      children: [
                                        FadeInImage.assetNetwork(
                                          placeholder: 'assets/kk.gif',
                                          image: theList[index].urlP,
                                          height: 280,
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                        const Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Banner(
                                            color: Colors.red,
                                            message: 'الجديد',
                                            location: BannerLocation.topEnd,
                                          ),
                                        ),
                                       /* Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              color: Colors.black38,
                                              child: const Text(
                                                '10:54',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ))*/
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6),
                                      child: Text(
                                        theList[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : const Color(0XFF215480),
                                          fontSize: size.width * 0.04,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
              ),
             /* const Align(
                alignment: Alignment.bottomCenter,
                child: MusicPlayer(),
              )*/
            ],
          ),
        ),
      ),
    );
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

