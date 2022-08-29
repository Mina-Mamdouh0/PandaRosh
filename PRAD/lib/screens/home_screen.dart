import 'dart:convert';
import 'dart:developer';

import 'package:prad/screens/edit_books.dart';
import 'package:prad/screens/edit_movies.dart';
import 'package:prad/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/main.dart';
import 'edit_category.dart';
import 'edit_reader.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isReaders = false;
  bool category = false;
  bool books = false;
  bool movies = false;
  bool logout = false;
  bool reload = false;

  var formKey = GlobalKey<FormState>();

  List<mainL> theList = [];

  String clicked = "writers";

  @override
  void initState() {
    super.initState();

    loadList();
  }



  String moviesPrice = "";
  String booksPrice = "";


  void updateMoviesPrice() async{

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: CircularProgressIndicator()));
        });

    try{

      final urll = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/moviesPrice.json');

      await http
          .patch(
        urll,
        body: json.encode({
          'price': double.parse(moviesPrice),

        }),
      ).then((value) {

        Navigator.of(context).pop();
        Navigator.of(context).pop();

      });

    }catch(e){
      log(e.toString());
    }

  }


  void updateBooksPrice() async{

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(child: Center(child: CircularProgressIndicator()));
        });

    try{

      final urll = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/booksPrice.json');

      await http
          .patch(
        urll,
        body: json.encode({
          'price': double.parse(booksPrice),

        }),
      ).then((value) {

        Navigator.of(context).pop();
        Navigator.of(context).pop();

      });

    }catch(e){
      log(e.toString());
    }

  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.deepOrange,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            clicked = "writers";
                            loadList();
                          },
                          color: isReaders ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'الكاتبون',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            clicked = "categories";
                            loadList();
                          },
                          color: category ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'المجموعات',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            clicked = "s&m";
                            loadList();
                          },
                          color: movies ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'مسلسلات وافلام',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            clicked = "books";
                            loadList();
                          },
                          color: books ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'كتب',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {

                            Get.defaultDialog(
                              title: 'احصائيات',
                              barrierDismissible: false,
                              buttonColor: Colors.deepOrange,
                              content: Form(
                                key: formKey,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {


                                          Get.back();

                                          Get.defaultDialog(
                                            title: 'عدد الافراد والزوار',
                                            barrierDismissible: false,
                                            buttonColor: Colors.deepOrange,
                                            content: Form(
                                              key: formKey,
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Column(
                                                  children: [

                                                    RichText(
                                                        text: const TextSpan(children: [
                                                          TextSpan(
                                                              text: 'الافراد الذين دخلوا الى الموقع: ',
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black)),
                                                          TextSpan(
                                                              text: "0",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent)),
                                                        ])),



                                                  ],
                                                ),
                                              ),
                                            ),
                                            cancelTextColor: Colors.black,
                                            textCancel: 'خروج',
                                          );


                                        },
                                        child:
                                        const Text('عدد الافراد والزوار '),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {


                                          Get.back();

                                          Get.defaultDialog(
                                            title: 'مواعيد عمليات الشراء',
                                            barrierDismissible: false,
                                            buttonColor: Colors.deepOrange,
                                            content: Form(
                                              key: formKey,
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Column(
                                                  children: [

                                                    RichText(
                                                        text: const TextSpan(children: [
                                                          TextSpan(
                                                              text: "20/6/2022",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent)),
                                                        ])),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),

                                                    RichText(
                                                        text: const TextSpan(children: [
                                                          TextSpan(
                                                              text: "20/6/2022",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent)),
                                                        ])),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),

                                                    RichText(
                                                        text: const TextSpan(children: [
                                                          TextSpan(
                                                              text: "20/6/2022",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent)),
                                                        ])),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            cancelTextColor: Colors.black,
                                            textCancel: 'خروج',
                                          );


                                        },
                                        child:
                                        const Text('مواعيد عمليات الشراء '),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {


                                          Get.back();

                                          Get.defaultDialog(
                                            title: 'البلاد',
                                            barrierDismissible: false,
                                            buttonColor: Colors.deepOrange,
                                            content: Form(
                                              key: formKey,
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Column(
                                                  children: [

                                                    RichText(
                                                        text: const TextSpan(children: [
                                                          TextSpan(
                                                              text: 'مصر: ',
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black)),
                                                          TextSpan(
                                                              text: "0",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blueAccent)),
                                                        ])),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),
                                            cancelTextColor: Colors.black,
                                            textCancel: 'خروج',
                                          );


                                        },
                                        child:
                                        const Text('البلاد التي تم الشراء منها '),
                                      ),




                                    ],
                                  ),
                                ),
                              ),
                              cancelTextColor: Colors.black,
                              textCancel: 'خروج',
                            );


                          },
                          color: logout ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'احصائيات',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {

                            Get.defaultDialog(
                              title: 'تعديل الاسعار',
                              barrierDismissible: false,
                              buttonColor: Colors.deepOrange,
                              content: Form(
                                key: formKey,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () {

                                            Get.back();

                                            moviesPrice = "";

                                            Get.defaultDialog(
                                              title: 'اسعار المسلسلات والافلام',
                                              barrierDismissible: false,
                                              buttonColor: Colors.deepOrange,
                                              content: Form(
                                                key: formKey,
                                                child: Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: Column(
                                                    children: [

                                                      TextField(
                                                        decoration: const InputDecoration(
                                                          hintText: "اسعار المسلسلات والافلام (ادخل الرقم فقط)",
                                                        ),
                                                        onChanged: (x) {
                                                          moviesPrice = x;
                                                        },

                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                                textConfirm: 'حفظ',
                                                confirmTextColor: Colors.white,
                                                cancelTextColor: Colors.black,
                                                textCancel: 'خروج',
                                                onConfirm: () {

                                                if(moviesPrice.isNotEmpty){
                                                  updateMoviesPrice();
                                                }

                                                });

                                          },
                                          child: const Text('اسعار المسلسلات والافلام '),
                                        ),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {

                                          Get.back();

                                          booksPrice = "";

                                          Get.defaultDialog(
                                              title: 'اسعار الكتب(ادخل الرقم فقط)',
                                              barrierDismissible: false,
                                              buttonColor: Colors.deepOrange,
                                              content: Form(
                                                key: formKey,
                                                child: Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: Column(
                                                    children: [

                                                      TextField(
                                                        decoration: const InputDecoration(
                                                          hintText: "اسعار الكتب",
                                                        ),
                                                        onChanged: (x) {
                                                          booksPrice = x;
                                                        },

                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                              textConfirm: 'حفظ',
                                              confirmTextColor: Colors.white,
                                              cancelTextColor: Colors.black,
                                              textCancel: 'خروج',
                                              onConfirm: () {

                                                if(booksPrice.isNotEmpty){
                                                  updateBooksPrice();
                                                }

                                              });


                                        },
                                        child: const Text('اسعار الكتب '),
                                      )



                                    ],
                                  ),
                                ),
                              ),
                              cancelTextColor: Colors.black,
                              textCancel: 'خروج',
                            );

                          },
                          color: logout ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'تعديل الاسعار',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              await preferences.clear().then((value) {
                                Get.off(LoginScreen());
                              });
                            });
                          },
                          color: logout ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'logout',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child: MaterialButton(
                          onPressed: () {
                            loadList();
                          },
                          color: reload ? Colors.blueAccent : Colors.grey,
                          padding: const EdgeInsets.all(12),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'reload',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              Center(
                child: isReaders
                    ? Readers()
                    : category
                        ? Category()
                        : movies
                            ? Movies()
                            : books
                                ? Books()
                                : Container(
                                    width: 500,
                                    height: 500,
                                    color: Colors.white,
                                    child: const CircularProgressIndicator(),
                                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadList() {
    setState(() {
      isReaders = false;
      category = false;
      books = false;
      movies = false;
    });

    try {
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

            if (clicked == "writers") {
              isReaders = true;
              category = false;
              books = false;
              movies = false;
            } else if (clicked == "categories") {
              isReaders = false;
              category = true;
              books = false;
              movies = false;
            } else if (clicked == "s&m") {
              isReaders = false;
              category = false;
              books = false;
              movies = true;
            } else if (clicked == "books") {
              isReaders = false;
              category = false;
              books = true;
              movies = false;
            } else {
              log("Error");
            }
          });
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  void uploadN(text) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      Uri url = Uri.https(
          'pandarosh-91270-default-rtdb.firebaseio.com', '/$clicked.json');

      if (clicked == "s&m" || clicked == "books") {
        Uri urll = Uri();

        if (clicked == "s&m") {
          urll = Uri.https(
              'pandarosh-91270-default-rtdb.firebaseio.com', '/s&mInfo.json');
        } else if (clicked == "books") {
          urll = Uri.https(
              'pandarosh-91270-default-rtdb.firebaseio.com', '/booksInfo.json');
        }

        await http
            .post(
          urll,
          body: json.encode({
            'name': text,
            'num': "0",
            'urlB': "",
            'urlP': "",
            'category': "",
            'writer': "",
            'about': "",
            'profits': "0",
            'time': "0",
            'episodes': "0",
            'cID': "",
            'price': "0",
            'urlID': "",
          }),
        )
            .then((value) async {
          await http
              .post(
            url,
            body: json.encode({
              'name': text,
              'num': "0",
              'urlB': "",
              'urlP': "",
              'info': json.decode(value.body)['name'].toString(),
            }),
          )
              .then((value) {
            Get.back(); //pull
            Get.back();

            loadList();
          });
        });
      } else {
        await http
            .post(
          url,
          body: json.encode({
            'name': text,
            'num': "0",
            'urlB': "",
            'urlP': "",
            'info': "",
            'money': "0",
          }),
        )
            .then((value) {
          Get.back();
          Get.back();

          loadList();
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Widget Readers() {
    final TextEditingController text = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return Container(
      width: 500,
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' الكاتبون',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 35),
              ),
              IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                        title: 'اضافه كاتب',
                        barrierDismissible: false,
                        buttonColor: Colors.deepOrange,
                        content: Form(
                          key: formKey,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextFiled(
                              controller: text,
                              hintText: 'اسم الكاتب',
                              icons: Icons.email,
                              inputType: TextInputType.text,
                              focusNode: FocusNode(),
                              obscure: false,
                              onEditCom: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'ادخل اسم الكاتب';
                                }
                              },
                            ),
                          ),
                        ),
                        textConfirm: 'حفظ',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.black,
                        textCancel: 'خروج',
                        onConfirm: () {
                          if (formKey.currentState!.validate()) {
                            uploadN(text.text);
                          }
                        });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.deepOrange,
                    size: 30,
                  ))
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: theList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          theList[index].name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        trailing: Text(
                          theList[index].num,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              'writerID', theList[index].idToEdit.toString());

                          Get.to(EditReader());
                        },
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget Category() {
    final TextEditingController text = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return Container(
      width: 500,
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' المجموعات',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 35),
              ),
              IconButton(
                  onPressed: () {
                    Get.defaultDialog(
                        title: 'اضافه مجموعه',
                        barrierDismissible: false,
                        buttonColor: Colors.deepOrange,
                        content: Form(
                          key: formKey,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: CustomTextFiled(
                              controller: text,
                              hintText: 'اسم المجموعه',
                              icons: Icons.email,
                              inputType: TextInputType.text,
                              focusNode: FocusNode(),
                              obscure: false,
                              onEditCom: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'ادخل اسم المجموعه';
                                }
                              },
                            ),
                          ),
                        ),
                        textConfirm: 'حفظ',
                        confirmTextColor: Colors.white,
                        cancelTextColor: Colors.black,
                        textCancel: 'خروج',
                        onConfirm: () {
                          if (formKey.currentState!.validate()) {
                            uploadN(text.text);
                          }
                        });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.deepOrange,
                    size: 30,
                  ))
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: theList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              'categoryID', theList[index].idToEdit.toString());

                          Get.to(EditCategory());
                        }, //push
                        title: Text(
                          theList[index].name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        trailing: Text(
                          theList[index].num,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget Movies() {
    final TextEditingController text = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return Container(
      width: 500,
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مسلسلات وافلام',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 35),
              ),
              IconButton(
                  onPressed: () {
                    Get.to(const EditButtonMovies());
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.deepOrange,
                    size: 30,
                  ))
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: theList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              'movieID', theList[index].infoID.toString());

                          Get.to(EditMovies());
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(theList[index].urlP),
                        ),
                        title: Text(
                          theList[index].name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        trailing: Text(
                          theList[index].num,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget Books() {
    final TextEditingController text = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return Container(
      width: 500,
      height: 500,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الكتب',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 35),
              ),
              IconButton(
                  onPressed: () {
                    Get.to(const EditButtonBooks());
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.deepOrange,
                    size: 30,
                  ))
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: theList.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(theList[index].urlP),
                        ),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();

                          prefs.setString('bookID', theList[index].infoID.toString());

                          Get.to(EditBooks());
                        },
                        title: Text(
                          theList[index].name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        trailing: Text(
                          theList[index].num,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 25),
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
