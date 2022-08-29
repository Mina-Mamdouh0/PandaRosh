import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../models/book_in_row.dart';
import '../models/main.dart';
import '../widget.dart';
import 'home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditButtonMoviess extends StatefulWidget {
  const EditButtonMoviess({Key? key}) : super(key: key);

  @override
  _EditButtonMoviessState createState() => _EditButtonMoviessState();
}

class _EditButtonMoviessState extends State<EditButtonMoviess> {
  var formKey = GlobalKey<FormState>();

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
  }

  String idToEdit = "";

  final TextEditingController name = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController price = TextEditingController();

  List<mainL> categoriesList = [];
  List<mainL> writersList = [];

  String dropdownCategoryValue = 'اختر اسم الCategory.....';
  String dropdownWritersValue = 'اختر اسم الكاتب.....';

  bool loading = false;

  String movieID = "";
  String movieIDBara = "";

  String urlB = "";
  String urlP = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    categoriesList = [];
    writersList = [];

    setState(() {
      loading = true;
    });

    try {
      //show indicator

      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/categories.json');

      await http.get(url).then((value) async {
        if (value.body == "{}") {
        } else {
          final List<mainL> loadData = [];

          final extractedData = json.decode(value.body);

          loadData.add(mainL(
            idToEdit: "",
            name: 'اختر اسم الCategory.....',
            num: "",
            urlB: "",
            urlP: "",
            infoID: "",
          ));

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
            categoriesList = loadData;
          });

          final urll = Uri.parse(
              'https://pandarosh-91270-default-rtdb.firebaseio.com/writers.json');

          await http.get(urll).then((value) async {
            if (value.body == "{}") {
            } else {
              final List<mainL> loadData = [];

              final extractedData = json.decode(value.body);

              loadData.add(mainL(
                idToEdit: "",
                name: 'اختر اسم الكاتب.....',
                num: "",
                urlB: "",
                urlP: "",
                infoID: "",
              ));

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
                writersList = loadData;
              });

              await getDataa();
            }
          });
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> getDataa() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      movieID = prefs.getString('movieID').toString();

      movieIDBara = prefs.getString('movieIDBara').toString();

      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo/$movieID.json');

      await http.get(url).then((value) async {
        if (value.body == "{}") {
          log("error loading");
        } else {
          final extractedData = json.decode(value.body);

          final urlCat = Uri.parse(
              '${'https://pandarosh-91270-default-rtdb.firebaseio.com/categories/' + extractedData['category']}/name.json');

          //get category name
          await http.get(urlCat).then((valueCat) async {
            //get writer name
            final urlWrit = Uri.parse(
                '${'https://pandarosh-91270-default-rtdb.firebaseio.com/writers/' + extractedData['writer']}/name.json');

            await http.get(urlWrit).then((valueWrit) async {
              setState(() {
                name.text = extractedData['name'];

                dropdownCategoryValue = json.decode(valueCat.body);
                dropdownWritersValue = json.decode(valueWrit.body);

                about.text = extractedData['about'];
                price.text = extractedData['price'];
                urlB = extractedData['urlB'];
                urlP = extractedData['urlP'];


                secondURL = extractedData['urlB'];
                firstURL = extractedData['urlP'];

                firstRef = extractedData['refP'];
                secondRef = extractedData['refB'];

                loading = false;
              });
            });
          });
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  String iddd = "";

  void uploadN() async {
    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&m.json?orderBy="info"&equalTo="$movieID"');

      Uri urll = Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
          '/s&mInfo/$movieID.json');

      await http
          .get(url)
          .then((value) async{


        final extractedData = json.decode(value.body);

        String idd = "";

        extractedData?.forEach((Key, value) {
          idd = Key;
        });

        final urlToPatch = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&m/$idd.json');

        await http
            .patch(
          urlToPatch,
          body: json.encode((pickedP || pickedB) ?
          {
            'name': name.text,
            'urlB': secondURL,
            'urlP': firstURL,
          }
              : {
            'name': name.text,
          }
          ),

        )
            .then((value) async {
          await http
              .patch(
            urll,
            body: json.encode((pickedP || pickedB) ?
            {
              'name': name.text,
              'about': about.text,
              'price': price.text,
              'urlB': secondURL,
              'urlP': firstURL,
              'refB': secondRef,
              'refP': firstRef,
            }
                :{
              'name': name.text,
              'about': about.text,
              'price': price.text,
            }),
          )
              .then((value) async {
            Get.back();
          });
        });


      });



    } catch (e) {
      log(e.toString());
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  File _fileP = File("zz");
  Uint8List webImageP = Uint8List(10);

  File _fileB = File("zz");
  Uint8List webImageB = Uint8List(10);

  bool pickedP = false;
  bool pickedB = false;

  uploadImageP() async {
    var permissionStatus = requestPermissions();

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _fileP = selected;
        });
      } else {
        showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _fileP = File("a");
          webImageP = f;
          pickedP = true;
        });
      } else {
        showToast("No file selected");
        pickedP = false;
      }
    } else {
      showToast("Permission not granted");
    }
  }

  uploadImageB() async {
    var permissionStatus = requestPermissions();

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _fileB = selected;
        });
      } else {
        showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _fileB = File("a");
          webImageB = f;
          pickedB = true;
        });
      } else {
        showToast("No file selected");
        pickedB = false;
      }
    } else {
      showToast("Permission not granted");
    }
  }

  bool loadingP = false;

  double progress = 0;

  String firstURL = "";
  String secondURL = "";

  String firstRef = "";
  String secondRef = "";

  void uploadImage() async {
    if (pickedP) {
      setState(() {
        loadingP = true;
      });

      //delete current image first
      final desertRef = FirebaseStorage.instance.ref().child(firstRef);

      await desertRef.delete().then((value) {
        const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
        math.Random _rnd = math.Random();

        String getRandomString(int length) =>
            String.fromCharCodes(Iterable.generate(
                length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

        firstRef = 'Images/s&m/' '${getRandomString(10)}${DateTime.now()}.jpg';

        final ref = FirebaseStorage.instance.ref().child(firstRef);

        final uploadTask = ref.putData(
            webImageP,
            SettableMetadata(
              contentType: "image/jpeg",
            ));

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              setState(() {
                progress = 100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              });

              log("Upload is $progress% complete.");

              break;
            case TaskState.paused:
              log("Upload is paused.");
              break;
            case TaskState.canceled:
              log("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads

              setState(() {
                loadingP = false;
              });

              Widget okButton = TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Error"),
                content: Text("please try again"),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );

              break;
            case TaskState.success:
              log("uploadeedd");
              Uri url = Uri.parse(await ref.getDownloadURL());
              firstURL = url.toString();

              log(url.toString());

              uploadImage2();

              break;
          }
        });
      });
    } else {
      uploadImage2();
    }
  }



  void uploadImage2() async {

    if (pickedB) {

      setState(() {
        loadingP = true;
      });

      //delete current image first
      final desertRef = FirebaseStorage.instance.ref().child(secondRef);

      await desertRef.delete().then((value) {
        const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
        math.Random _rnd = math.Random();

        String getRandomString(int length) =>
            String.fromCharCodes(Iterable.generate(
                length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

        secondRef = 'Images/s&m/' '${getRandomString(10)}${DateTime.now()}.jpg';

        final ref = FirebaseStorage.instance.ref().child(secondRef);

        final uploadTask = ref.putData(
            webImageB,
            SettableMetadata(
              contentType: "image/jpeg",
            ));

        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              setState(() {
                progress = 100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
              });

              log("Upload is $progress% complete.");
              break;
            case TaskState.paused:
              log("Upload is paused.");
              break;
            case TaskState.canceled:
              log("Upload was canceled");
              break;
            case TaskState.error:
              // Handle unsuccessful uploads

              //delete first image
              final desertRef = FirebaseStorage.instance.ref().child(firstRef);

              await desertRef.delete();

              setState(() {
                loadingP = false;
              });

              Widget okButton = TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Error"),
                content: Text("please try again"),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );

              break;
            case TaskState.success:
              log("uploadeedd");
              Uri url = Uri.parse(await ref.getDownloadURL());
              secondURL = url.toString();

              uploadN();

              log(url.toString());

              break;
          }
        });
      });
    }
    else {
      uploadN();
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          elevation: 0.0,
          actions: [
            TextButton(
              onPressed: () {
                if (name.text.isEmpty ||
                    about.text.isEmpty ||
                    price.text.isEmpty) {
                  log("emptyy");
                } else {
                  if (pickedP || pickedB) {
                    uploadImage();
                  } else {
                    uploadN();
                  }
                }
              },
              child: Text(
                'حفظ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.03),
              ),
            )
          ],
        ),
        body: loadingP
            ? Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Upload is $progress% complete."),
                    ),
                  ],
                ),
              )
            : loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: size.width * 0.35,
                                  width: size.width * 0.35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: pickedP
                                      ? (kIsWeb)
                                          ? Image.memory(webImageP)
                                          : Image.file(_fileP)
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            urlP,
                                            fit: BoxFit.fill,
                                          )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () => uploadImageP(),
                                    child: const Text('تعديل '),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: size.width * 0.35,
                                  width: size.width * 0.35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: pickedB
                                      ? (kIsWeb)
                                          ? Image.memory(webImageB)
                                          : Image.file(_fileB)
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            urlB,
                                            fit: BoxFit.fill,
                                          )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () => uploadImageB(),
                                    child: const Text('تعديل '),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomTextFiled(
                                  controller: name,
                                  hintText: 'اسم المسلسل او الفليم الجديد',
                                  icons: Icons.email,
                                  inputType: TextInputType.text,
                                  focusNode: FocusNode(),
                                  obscure: false,
                                  onEditCom: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'ادخل البيانات المطلوبه';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InputField(
                                  title: 'اسم المجموعه',
                                  hint: dropdownCategoryValue,
                                  /* widget: DropdownButton<String>(
                          //branch
                          value: dropdownCategoryValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownCategoryValue = newValue!;
                            });
                          },

                          items: categoriesList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),*/
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                InputField(
                                  title: 'اسم الكاتب',
                                  hint: dropdownWritersValue,
                                  /* widget: DropdownButton<String>(
                          //branch
                          value: dropdownWritersValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownWritersValue = newValue!;
                            });
                          },

                          items: writersList.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.name,
                              child: Text(value.name),
                            );
                          }).toList(),
                        ),*/
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                Container(
                                  color: Colors.grey.shade200,
                                  child: TextField(
                                      controller: about,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'عن المسلسل او الفليم الجديد',
                                        prefixIcon:  Icon(Icons.email, color: Colors.deepOrange,),
                                        fillColor: Colors.grey.shade200,
                                      )
                                  ),
                                ),

/*
                                CustomTextFiled(
                                  controller: about,
                                  numberOfLines: 10,
                                  hintText: 'عن المسلسل او الفليم الجديد',
                                  icons: Icons.email,
                                  inputType: TextInputType.text,
                                  focusNode: FocusNode(),
                                  obscure: false,
                                  onEditCom: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'ادخل البيانات المطلوبه';
                                    }
                                  },
                                ),
*/


                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextFiled(
                                  controller: price,
                                  hintText: 'ادخل سعر الكتاب',
                                  icons: Icons.email,
                                  inputType: TextInputType.number,
                                  focusNode: FocusNode(),
                                  obscure: false,
                                  onEditCom: () {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'ادخل البيانات المطلوبه';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
