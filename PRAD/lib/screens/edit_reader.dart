import 'dart:convert';
import 'dart:developer';

import 'package:prad/screens/edit_books.dart';
import 'package:prad/screens/edit_movies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_in_row.dart';
import '../models/info.dart';
import '../widget.dart';

import 'package:http/http.dart' as http;

class EditReader extends StatefulWidget {
  EditReader({Key? key}) : super(key: key);

  @override
  State<EditReader> createState() => _EditReaderState();
}

class _EditReaderState extends State<EditReader> {
  final TextEditingController text = TextEditingController();

  var formKey = GlobalKey<FormState>();

  String writerID = "";

  List<bookInRow> firstList = [];
  List<bookInRow> secondList = [];

  String name = "";
  String num = "";
  String money = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          title: Text(
            'الكاتبون',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.03),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'اسم الكاتب : ',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text: name,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ])),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'عدد الكتب : ',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text: num,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ])),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: 'الارباح: ',
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  TextSpan(
                      text: money + " ",
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                  const TextSpan(
                      text: 'جنيه مصري',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ])),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          Get.defaultDialog(
                              title: 'تعديل  اسم الكاتب',
                              barrierDismissible: false,
                              buttonColor: Colors.deepOrange,
                              content: Form(
                                key: formKey,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: CustomTextFiled(
                                    controller: text,
                                    hintText: 'اسم الكاتب الجديد',
                                    icons: Icons.email,
                                    inputType: TextInputType.text,
                                    focusNode: FocusNode(),
                                    obscure: false,
                                    onEditCom: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'ادخل اسم الكاتب الجديد';
                                      }
                                    },
                                  ),
                                ),
                              ),
                              textConfirm: 'حفظ',
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.black,
                              textCancel: 'خروج',
                              onConfirm: () async{
                                if (formKey.currentState!.validate()) {
                                  //clicked on save

                                  //show Dialog

                                  final url = Uri.parse('https://pandarosh-91270-default-rtdb.firebaseio.com/writers/$writerID.json');

                                  await http
                                      .patch(
                                    url,
                                    body: json.encode({
                                      'name': text.text,
                                    }),
                                  ).then((value) {

                                    //hide dialog
                                    //Get.back();

                                    Get.back();

                                    getData();

                                  });


                                }
                              });
                        },
                        color: Colors.deepOrange,
                        padding: const EdgeInsets.all(12),
                        child: const Text(
                          'تعديل',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    //delete button
                    /*Expanded(child: MaterialButton(onPressed: () {



                       Widget okButton = TextButton(
                         child: const Text("OK"),
                         onPressed: () {
                           //delete pressed
                           Navigator.of(context).pop();
                           showDialog(
                               barrierDismissible: false,
                               context: context,
                               builder: (BuildContext context) {
                                 return Container(child: Center(child: CircularProgressIndicator()));
                               });

                          // Delete();

                         },
                       );

                       Widget cancelButton = TextButton(
                         child: Text("cancel"),
                         onPressed: () {
                           Navigator.of(context).pop();
                         },
                       );

                       // set up the AlertDialog
                       AlertDialog alert = AlertDialog(
                         title: Text("Alert !"),
                         content: Text("are you sure you want to delete " + booking[index].name),
                         actions: [
                           okButton,
                           cancelButton
                         ],
                       );

                       // show the dialog
                       showDialog(
                         barrierDismissible: false,
                         context: context,
                         builder: (BuildContext context) {
                           return alert;
                         },
                       );



                     },
                       color: Colors.red[900],
                       padding: const EdgeInsets.all(12),
                       child: const Text('حذف',
                         style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                         ),),),)*/
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'المسلسلات والافلام',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.02),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.builder(
                      itemCount: firstList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            HoverCrossFadeWidget(
                              duration: const Duration(milliseconds: 500),
                              firstChild: Container(
                                width: size.width * 0.15,
                                height: size.width * 0.2,
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : const Color(0XFFEAF5F8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    firstList[index].urlP,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              secondChild: Container(
                                width: size.width * 0.15,
                                height: size.width * 0.2,
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
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
                                        child: Image.network(
                                          firstList[index].urlP,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.006,
                                          vertical: 8),
                                      child: Text(
                                        firstList[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0XFF215480),
                                          fontSize: size.width * 0.013,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('movieID', firstList[index].idToEdit.toString());

                                Get.to(EditMovies());
                              },
                              color: Colors.deepOrange,
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'تعديل',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        );
                      }),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    'الكتب',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * 0.02),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.builder(
                      itemCount: secondList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            HoverCrossFadeWidget(
                              duration: const Duration(milliseconds: 500),
                              firstChild: Container(
                                width: size.width * 0.15,
                                height: size.width * 0.2,
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : const Color(0XFFEAF5F8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    secondList[index].urlP,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace,)=> Image.asset("assets/image/logo.png",
                                        fit: BoxFit.fill,
                                        width: double.infinity,)),
                                ),
                              ),
                              secondChild: Container(
                                width: size.width * 0.15,
                                height: size.width * 0.2,
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10),
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
                                        child: Image.network(
                                          secondList[index].urlP,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.006,
                                          vertical: 8),
                                      child: Text(
                                        secondList[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0XFF215480),
                                          fontSize: size.width * 0.013,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('bookID',
                                    secondList[index].idToEdit.toString());

                                Get.to(EditBooks());
                              },
                              color: Colors.deepOrange,
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'تعديل',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        );
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData() async {
/*    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        });


            Get.defaultDialog(
        barrierDismissible: false,
        content: const Center(child: CircularProgressIndicator())
        );

        */

    try {
      final prefs = await SharedPreferences.getInstance();

      writerID = prefs.getString('writerID').toString();

      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/writers/$writerID.json');

      http.get(url).then((value) async {
        if (value.body == "{}") {
        } else {
          final extractedData = json.decode(value.body);

          setState(() {
            name = extractedData['name'];
            num = extractedData['num'];
            money = extractedData['money'];
          });

          await getBooksRow();

/*          extractedData?.forEach((Key, value) {
            loadData.add(info(
              idToEdit: Key,
              name: value['name'],
              num: value['num'],
              urlB: value['urlB'],
              urlP: value['urlP'],
              category: value['category'],
              writer: value['writer'],
              about: value['about'],
              profits: value['profits'],
              time: value['time'],
              episodes: value['episodes'],
              cID: value['cID'],
              price: value['price'],
              urlID: value['urlID'],


            ));
          });

          setState(() {
            theList = loadData;

          });*/

        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> getBooksRow() async {
    firstList = [];
    secondList = [];

    try {
      //s&m
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo.json?orderBy="writer"&equalTo="$writerID"');

      await http.get(url).then((value) async {
        final extractedData = json.decode(value.body);

        final List<bookInRow> loadData = [];

        extractedData?.forEach((Key, value) {
          loadData.add(bookInRow(
            idToEdit: Key,
            name: value['name'],
            urlP: value['urlP'],
            ref: "",
            EpisodeNum: 0,


          ));

          log(value['urlP']);
        });



        setState(() {
          firstList = loadData;
        });

        //books
        final url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/booksInfo.json?orderBy="writer"&equalTo="$writerID"');

        await http.get(url).then((value) {
          final extractedData = json.decode(value.body);

          final List<bookInRow> loadData = [];

          extractedData?.forEach((Key, value) {
            loadData.add(bookInRow(
              idToEdit: Key,
              name: value['name'],
              urlP: value['urlP'],
              ref: "",
              EpisodeNum: 0,

            ));
          });

          setState(() {
            secondList = loadData;
          });
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
