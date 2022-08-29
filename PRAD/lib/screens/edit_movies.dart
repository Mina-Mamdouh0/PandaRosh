import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
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
import '../models/book_in_row_m.dart';
import '../models/main.dart';
import '../widget.dart';
import 'edit_moviess.dart';
import 'home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';

class EditMovies extends StatefulWidget {
  EditMovies({Key? key}) : super(key: key);

  @override
  State<EditMovies> createState() => _EditMoviesState();
}

class _EditMoviesState extends State<EditMovies> {
  final TextEditingController text = TextEditingController();

  var formKey = GlobalKey<FormState>();

  File _file = File("zz");
  Uint8List webImage = Uint8List(10);


  bool notPicked = true;

  uploadImage() async {
    var permissionStatus = requestPermissions();

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _file = selected;
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
          _file = File("a");
          webImage = f;
          notPicked = false;
        });

        Get.back();

        Get.defaultDialog(
            title: 'اضافه',
            barrierDismissible: false,
            buttonColor: Colors.deepOrange,
            content: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: notPicked
                            ? InkWell(
                          onTap: (){
                            uploadImage();
                          },
                          child: Image.network(
                            'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                            fit: BoxFit.fill,
                          ),
                        )
                            : (kIsWeb)
                            ? InkWell(
                            onTap: (){
                              uploadImage();
                            },
                            child: Image.memory(webImage))
                            : InkWell(
                            onTap: (){
                              uploadImage();
                            },
                            child: Image.file(_file)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () => pickAudio(),
                      child: const Text('اضافه المقطع '),
                    ),
/*                                      CustomTextFiled(
                                        controller: text,
                                        hintText: 'اسم الحلقه الجديد',
                                        icons: Icons.email,
                                        inputType: TextInputType.text,
                                        focusNode: FocusNode(),
                                        obscure: false,
                                        onEditCom: () {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'ادخل البيانات ';
                                          }
                                        },
                                      ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(fileName),
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

            });

      } else {
        showToast("No file selected");
      }
    } else {
      showToast("Permission not granted");
    }
  }

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
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

  List<bookInRowM> firstList = [];

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

  @override
  void initState() {
    super.initState();

    getData();
  }

  IconData icons = Icons.play_circle_fill;

  String fileName = "";

  void pickAudio() async {
    fileName = "";

    FilePickerCross myFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.audio,
    );

    fileName = myFile.fileName!;
    //log("file length: ${myFile.length}");

    Get.back();

    Get.defaultDialog(
        title: 'اضافه',
        barrierDismissible: false,
        buttonColor: Colors.deepOrange,
        content: Form(
          key: formKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: notPicked
                        ? Image.network(
                          'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                          fit: BoxFit.fill,
                        )
                        : (kIsWeb)
                        ? Image.memory(webImage)
                        : Image.file(_file),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => pickAudio(),
                  child: const Text('اضافه المقطع '),
                ),
/*                                      CustomTextFiled(
                                        controller: text,
                                        hintText: 'اسم الحلقه الجديد',
                                        icons: Icons.email,
                                        inputType: TextInputType.text,
                                        focusNode: FocusNode(),
                                        obscure: false,
                                        onEditCom: () {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'ادخل البيانات ';
                                          }
                                        },
                                      ),*/

                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "اسم الحلقة او الفيلم",
                  ),
                  onChanged: (x) {
                    episName = x;
                  },

                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fileName),
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

            if(fileName.isNotEmpty){
              uploadEpisode(myFile.toUint8List());
            }

        });
    //startAudio();
  }


  String fileNamePromo = "";

  void pickAudioPromo() async {
    fileNamePromo = "";

    FilePickerCross myFilePromo = await FilePickerCross.importFromStorage(
      type: FileTypeCross.audio,
    );

    fileNamePromo = myFilePromo.fileName!;
    //log("file length: ${myFile.length}");

    Get.back();

    Get.defaultDialog(
        title: 'اضافه',
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
                  onPressed: () => pickAudioPromo(),
                  child: const Text('اضافه برومو '),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fileNamePromo),
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

          if(fileNamePromo.isNotEmpty){
            uploadEpisodePromo(myFilePromo.toUint8List());
          }

        });

    //startAudio();
  }


  void pickAudio2(index) async {
    fileName = "";

    FilePickerCross myFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.audio,
    );

    fileName = myFile.fileName!;

    Get.back();

    Get.defaultDialog(
        title: 'تعديل',
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
                  onPressed: () => uploadImage(),
                  child: const Text('تعديل المقطع '),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(fileName),
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
          uploadEpisode2(myFile.toUint8List(), index);
        });
  }

  double progress = 0;

  String audioURL = "";
  String audioRef = "";

  String audioURLPromo = "";
  String audioRefPromo = "";

  void uploadEpisode(myFile) {

    Get.back();

    setState((){
      loadingP = true;
    });

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random _rnd = math.Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    audioRef = 'Episodes/s&m/' '${getRandomString(10)}${DateTime.now()}.mp3';

    final ref = FirebaseStorage.instance.ref().child(audioRef);

    final uploadTask = ref.putData(
      myFile,
      /*SettableMetadata(
          contentType: "image/jpeg",
        )*/
    );

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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
          audioURL = url.toString();

          log(url.toString());

          if(notPicked){
            uploadEpis();
          }else{
            uploadEpisImage();
          }


          break;
      }
    });
  }

  void uploadEpisodePromo(myFile) async{

    Get.back();

    setState((){
      loadingP = true;
    });


    if(audioRefPromo.isNotEmpty){

      final desertRef =
      FirebaseStorage.instance.ref().child(audioRefPromo);

      // Delete the file
      await desertRef.delete();

    }

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random _rnd = math.Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    audioRefPromo = 'Episodes/s&m/' '${getRandomString(10)}${DateTime.now()}.mp3';

    final ref = FirebaseStorage.instance.ref().child(audioRefPromo);

    final uploadTask = ref.putData(
      myFile,
      /*SettableMetadata(
          contentType: "image/jpeg",
        )*/
    );

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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
          audioURLPromo = url.toString();

          log(url.toString());

            uploadEpisPromo();

          break;
      }
    });
  }

  void uploadEpisPromo() async {
    try {


      Uri urll = Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
          '/s&mInfo/$movieID.json');


        await http
            .patch(
          urll,
          body: json.encode({
            'promoURL': audioURLPromo,
            'promoRef': audioRefPromo,

          }),
        )
            .then((value) {

          setState((){
            loadingP = false;
          });

          getData();
        });
    } catch (e) {
      log(e.toString());
    }
  }


  void getCountries(){

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


  }


  void getDates(){

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


  }




  String episImageUrl = "";
  String episImageRef = "";

  void uploadEpisImage() {

    setState((){
      loadingP = true;
    });

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random _rnd = math.Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    episImageRef = 'Episodes/s&m/''${getRandomString(10)}${DateTime.now()}.jpg';

    final ref = FirebaseStorage.instance.ref().child(episImageRef);

    final uploadTask = ref.putData(
        webImage,
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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
          episImageUrl = url.toString();

          log(url.toString());

          uploadEpis();

          break;
      }
    });
  }

  void uploadEpisode2(myFile, index) {

    Get.back();

    setState((){
      loadingP = true;
    });

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random _rnd = math.Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    audioRef = 'Episodes/s&m/' '${getRandomString(10)}${DateTime.now()}.mp3';

    final ref = FirebaseStorage.instance.ref().child(audioRef);

    final uploadTask = ref.putData(
      myFile,
      /*SettableMetadata(
          contentType: "image/jpeg",
        )*/
    );

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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
          audioURL = url.toString();

          log(url.toString());

          uploadEpis2(index);

          break;
      }
    });
  }

  void uploadEpis() async {
    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis.json');

      await http
          .post(
        url,
        body: json.encode( notPicked
            ?{
          'name': episName.isEmpty?"الحلقة رقم ${(firstList.length + 1)}" : episName,
          'url': audioURL,
          'ref': audioRef,
          'movie': movieID,
          'EpisodeNum': getNewEpisodeNum(firstList.length + 1),
          'imageRef': "",
          'imageUrl': "",


        }
        :{

          'name': episName.isEmpty?"الحلقة رقم ${(firstList.length + 1)}" : episName,
          'url': audioURL,
          'ref': audioRef,
          'movie': movieID,
          'EpisodeNum': getNewEpisodeNum(firstList.length + 1),

          'imageRef': episImageRef,
          'imageUrl': episImageUrl,

        }),
      )
          .then((value) async {
        final urll = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo/$movieID.json');

        await http
            .patch(
          urll,
          body: json.encode({
            'episodes': (int.parse(episodesNum) + 1).toString(),
          }),
        )
            .then((value) {

          setState((){
            loadingP = false;
          });

          getData();
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void uploadEpis2(index) async {
    try {
      final desertRef =
      FirebaseStorage.instance.ref().child(firstList[index].ref);

      // Delete the file
      await desertRef.delete().then((value) async {
        final url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[index].idToEdit}.json');

        await http
            .patch(
          url,
          body: json.encode({
            'url': audioURL,
            'ref': audioRef,
          }),
        )
            .then((value) {

          setState((){
            loadingP = false;
          });

          getData();
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }


  void updateEpisNum(index, num) async {


    try {


      if(firstList.indexWhere((f) => f.EpisodeNum == num) == -1){

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            });

        final url = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[index].idToEdit}.json');

        await http
            .patch(
          url,
          body: json.encode({
            'EpisodeNum': num,
          }),
        )
            .then((value) {

          Navigator.of(context).pop();

          getData();

        });

      }else{

        Get.defaultDialog(
            title: 'رقم مكرر',
            barrierDismissible: false,
            buttonColor: Colors.deepOrange,
            content: Form(
              key: formKey,
              child: const Text("يوجد حلقة بهذا الرقم بالفعل"),
            ),
            cancelTextColor: Colors.black,
            textCancel: 'خروج',
            );

      }


    } catch (e) {
      log(e.toString());
    }
  }


  int getNewEpisodeNum(int num){

    log("num:$num");

    if(firstList.indexWhere((f) => f.EpisodeNum == num) == -1){

      log("1");

      return num;
    }else{

      log("2");
      return getNewEpisodeNum(num + 1);

    }


  }


  void deleteEpis(index) async {
    try {
      //show dialouge

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                    ],
                  ));
            });
          });

      final desertRef =
      FirebaseStorage.instance.ref().child(firstList[index].ref);

      // Delete the file
      await desertRef.delete().then((value) async {

        deleteTheData(index);

      });
    } catch (e) {
      log(e.toString());

      if(e.toString() == "[firebase_storage/object-not-found] No object exists at the desired reference."){
        deleteTheData(index);
      }

    }
  }


  void deleteTheData(index) async{
    try{

      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[index].idToEdit}.json');

      await http.delete(url).then((value) async {
        final urll = Uri.parse(
            'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo/$movieID.json');

        await http
            .patch(
          urll,
          body: json.encode({
            'episodes': (int.parse(episodesNum) - 1).toString(),
          }),
        )
            .then((value) {
          Get.back();
          Get.back();

          getData();
        });
      });

    }catch(e){
      log(e.toString());
    }

  }



  void deleteM() async {
    try {
      //show dialouge

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                    ],
                  ));
            });
          });

      final refBack = FirebaseStorage.instance.ref().child(refB);
      log("refB: $refB");
      final refProfile = FirebaseStorage.instance.ref().child(refP);

      // Delete first ref
      await refBack.delete().then((value) async {
        log("deleted refBack: $refB");

        // Delete second ref
        await refProfile.delete().then((value) async {
          log("deleted refBack: $refP");

          final url = Uri.parse(
              'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mInfo/$movieID.json');

          // Delete s&mInfo
          await http.delete(url).then((value) async {
            log("deleted s&mInfo: $movieID");

            final url = Uri.parse(
                'https://pandarosh-91270-default-rtdb.firebaseio.com/s&m.json?orderBy="info"&equalTo="$movieID"');

            //get s&m id
            await http.get(url).then((value) async {
              final extractedData = json.decode(value.body);

              String idd = "";

              extractedData?.forEach((Key, value) {
                idd = Key;
              });

              log("get s&m id: $idd");

              final url = Uri.parse(
                  'https://pandarosh-91270-default-rtdb.firebaseio.com/s&m/$idd.json');

              // Delete s&m
              await http.delete(url).then((value) async {
                log("deleted s&m: $idd");

                //decrease num in categ and writer
                final urlCat = Uri.parse(
                    '${'https://pandarosh-91270-default-rtdb.firebaseio.com/categories/$categoryID'}/num.json');

                //get category name
                await http.get(urlCat).then((valueCat) async {
                  //get writer name
                  final urlWrit = Uri.parse(
                      '${'https://pandarosh-91270-default-rtdb.firebaseio.com/writers/$writerNameID'}/num.json');

                  await http.get(urlWrit).then((valueWrit) async {
                    //json.decode(valueCat.body);
                    //json.decode(valueWrit.body);

                    //decrease writer
                    await http
                        .patch(
                      Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
                          '/writers/$writerNameID.json'),
                      body: json.encode({
                        'num':
                        (int.parse(json.decode(valueWrit.body).toString()) -
                            1)
                            .toString(),
                      }),
                    )
                        .then((value) async {
                      log("${"decreased writers: $writerNameID from: " + json.decode(valueWrit.body)} to: ${int.parse(json.decode(valueWrit.body).toString()) - 1}");

                      await http
                          .patch(
                        Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
                            '/categories/$categoryID.json'),
                        body: json.encode({
                          'num': (int.parse(
                              json.decode(valueCat.body).toString()) -
                              1)
                              .toString(),
                        }),
                      )
                          .then((value) async {
                        log("${"decreased categories: $categoryID from: " + json.decode(valueCat.body)} to: ${int.parse(json.decode(valueCat.body).toString()) - 1}");

                        //delete all episodes ref and episodes itself

                        if (firstList.isEmpty) {
                          Get.back();
                          Get.back();
                          Get.back();
                        } else {
                          for (int i = 0; i < firstList.length; i++) {
                            //last loop
                            if (i == firstList.length - 1) {
                              final desertRef = FirebaseStorage.instance
                                  .ref()
                                  .child(firstList[i].ref);

                              // Delete the file
                              await desertRef.delete().then((value) async {
                                log("deleted audio ref: ${firstList[i].ref}");

                                final url = Uri.parse(
                                    'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[i].idToEdit}.json');

                                await http.delete(url).then((value) {
                                  log("deleted s&mEpis: ${firstList[i].idToEdit}");

                                  Get.back();
                                  Get.back();
                                  Get.back();

                                });
                              });
                            } else {
                              final desertRef = FirebaseStorage.instance
                                  .ref()
                                  .child(firstList[i].ref);

                              // Delete the file
                              await desertRef.delete().then((value) async {
                                log("deleted audio ref: ${firstList[i].ref}");

                                final url = Uri.parse(
                                    'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[i].idToEdit}.json');

                                await http.delete(url).then((value) {
                                  log("deleted s&mEpis: ${firstList[i].idToEdit}");
                                });
                              });
                            }
                          }
                        }
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  final assetsAudioPlayer = AssetsAudioPlayer();

  void startAudio() async {
    try {
      await assetsAudioPlayer
          .open(
        Audio.network(
            "https://firebasestorage.googleapis.com/v0/b/pandarosh-91270.appspot.com/o/Episodes%2Fs%26m%2FXCsWemPqdW2022-05-22%2001%3A00%3A43.032.mp3?alt=media&token=61fece43-fc56-4bcc-87db-095b375df2ec"),
      )
          .then((value) {
        log("audio duration: ${assetsAudioPlayer.current.value?.audio.duration}");
      });

      /* final PlayingAudio playing = assetsAudioPlayer.current.value as PlayingAudio;

      assetsAudioPlayer.current.listen((playingAudio){
        //final asset = playingAudio.assetAudio;
        //final songDuration = playingAudio.duration;
      });

      //retrieve directly the current song position
      final Duration position = assetsAudioPlayer.currentPosition.value;

      StreamBuilder(
          stream: assetsAudioPlayer.currentPosition,
          builder: (context, asyncSnapshot) {
            final Object? duration = asyncSnapshot.data;
            return Text(duration.toString());
          });

      //final duration = assetsAudioPlayer.current.value.duration;
*/

    } catch (t) {
      //mp3 unreachable
      log(t.toString());
    }
  }

  bool loadingP = false;

  bool playing = false;
  final player = AudioPlayer();


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

  void loadAudio(urlll) async{

    log("startAud");

    // Try to load audio from a source and catch any errors.
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(
          urlll))
      ).then((value) {
        log("startAud 2");
        player.play();
        //emit(PandaroshTestState());
      });

    } catch (e) {
      print("Error loading audio source: $e");
    }


  }


  String episName = "";


  void editAudioEpis(index){

    Get.back();

    Get.defaultDialog(
        title: 'تعديل',
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
                  onPressed: () =>
                      pickAudio2(index),
                  child:
                  const Text('تعديل المقطع '),
                ),
              ],
            ),
          ),
        ),
        textConfirm: 'حفظ',
        confirmTextColor: Colors.white,
        cancelTextColor: Colors.black,
        textCancel: 'خروج',
        onConfirm: () {});

  }

  void uploadEpisEdit(index) async {
    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[index].idToEdit}.json');

      await http
          .patch(
        url,
        body: json.encode({
          'imageRef': episImageRef,
          'imageUrl': episImageUrl,

        }),
      )
          .then((value) async {

        setState((){
          loadingP = false;
        });

          getData();

      });
    } catch (e) {
      log(e.toString());
    }
  }


  void uploadEditImage(index) {

    Get.back();

    setState((){
      loadingP = true;
    });

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    math.Random _rnd = math.Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    episImageRef = 'Episodes/s&m/''${getRandomString(10)}${DateTime.now()}.jpg';

    final ref = FirebaseStorage.instance.ref().child(episImageRef);

    final uploadTask = ref.putData(
        webImage,
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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
          episImageUrl = url.toString();

          log(url.toString());

          //delete first image
          final desertRef = FirebaseStorage.instance.ref().child(firstList[index].ref);

          await desertRef.delete().then((value) {
            uploadEpisEdit(index);
          });


          break;
      }
    });
  }

  void uploadImageEdit(index) async {
    var permissionStatus = requestPermissions();

    // MOBILE
    if (!kIsWeb && await permissionStatus.isGranted) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _file = selected;
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
          _file = File("a");
          webImage = f;
          notPicked = false;
        });

        Get.back();

        Get.defaultDialog(
            title: 'تعديل الصورة',
            barrierDismissible: false,
            buttonColor: Colors.deepOrange,
            content: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.all(10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: notPicked
                            ? InkWell(
                          onTap: (){
                            uploadImageEdit(index);
                          },
                          child: Image.network(
                            'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                            fit: BoxFit.fill,
                          ),
                        )
                            : (kIsWeb)
                            ? InkWell(
                            onTap: (){
                              uploadImageEdit(index);
                            },
                            child: Image.memory(webImage))
                            : InkWell(
                            onTap: (){
                              uploadImageEdit(index);
                            },
                            child: Image.file(_file)),
                      ),
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
              uploadEditImage(index);
            });

      } else {
        showToast("No file selected");
      }
    } else {
      showToast("Permission not granted");
    }
  }

  void editImageEpis(index){

    Get.back();

    notPicked = true;

    Get.defaultDialog(
        title: 'تعديل الصورة',
        barrierDismissible: false,
        buttonColor: Colors.deepOrange,
        content: Form(
          key: formKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [

                Container(
                  margin: const EdgeInsets.all(10),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: notPicked
                        ? InkWell(
                      onTap: (){
                        uploadImageEdit(index);
                      },
                      child: Image.network(
                        'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                        fit: BoxFit.fill,
                      ),
                    )
                        : (kIsWeb)
                        ? InkWell(
                        onTap: (){
                          uploadImageEdit(index);
                        },
                        child: Image.memory(webImage))
                        : InkWell(
                        onTap: (){
                          uploadImageEdit(index);
                        },
                        child: Image.file(_file)),
                  ),
                ),


              ],
            ),
          ),
        ),
        cancelTextColor: Colors.black,
        textCancel: 'خروج',
        );

  }



  void EditEpisName(index) async {

    Get.back();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        });

    try {
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis/${firstList[index].idToEdit}.json');

      await http
          .patch(
        url,
        body: json.encode({
          'name': episName.isEmpty?"الحلقة رقم ${(index + 1)}" : episName,

        }),
      )
          .then((value) async {

          setState((){
            loadingP = false;
          });

          Get.back();

          getData();

      });
    } catch (e) {
      log(e.toString());
    }
  }


  void EpisNameEdit(index){

    Get.back();

    episName = "";

    Get.defaultDialog(
      title: 'تعديل الاسم',
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
                  hintText: "الاسم الجديد للحلقة او للفيلم",
                ),
                onChanged: (x) {
                  episName = x;
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
          EditEpisName(index);
        });

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
            'المسلسلات و الافلام',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.03),
          ),
        ),
        body: loadingP
            ? Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Upload is $progress% complete."),
              ),

            ],
          ),
        )
            : SingleChildScrollView(
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
                          text: 'اسم المسلسل او الفليم : ',
                          style: const TextStyle(
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
                          text: 'اسم المجموعه : ',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: category,
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
                          text: 'اسم الكاتب : ',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: writerName,
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
                          text: 'عن : ',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: about,
                          style: const TextStyle(
                              fontSize: 25,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                    ])),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'الارباح  : ',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: profits,
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
/*
                RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'كم الوقت  : ',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: time,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent)),
                    ])),
*/
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: 'عدد الحلقات  : ',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: episodesNum,
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
                          text: 'عدد الشراء  : ',
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

                ElevatedButton(
                  onPressed: () =>
                      getCountries(),
                  child:
                  const Text('البلاد التي تم الشراء منها'),
                ),

                const SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  onPressed: () =>
                      getDates(),
                  child:
                  const Text('مواعيد عمليات الشراء'),
                ),




                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الصوره : ',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                      width: size.width * 0.40,
                      height: size.width * 0.30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(urlP))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'صوره الخلفيه : ',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                      width: size.width * 0.5,
                      height: size.width * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill, image: NetworkImage(urlB))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('movieID', movieID);

                          Get.to(const EditButtonMoviess());
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
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          //delete movie it self

                          Get.defaultDialog(
                              title: 'مسح',
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
                                      const Text(
                                          "سيتم مسح المسلسل بالكامل بكل تفاصيله وحلقاته"),
                                    ],
                                  ),
                                ),
                              ),
                              textConfirm: 'حذف',
                              confirmTextColor: Colors.white,
                              cancelTextColor: Colors.black,
                              textCancel: 'خروج',
                              onConfirm: () {
                                deleteM();
                              });
                        },
                        color: Colors.red[900],
                        padding: const EdgeInsets.all(12),
                        child: const Text(
                          'حذف',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    )
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الحلقات',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02),
                      ),
                      MaterialButton(
                        //new episode
                        onPressed: () {

                          fileNamePromo = "";

                          Get.defaultDialog(
                              title: 'اضافه',
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
                                        onPressed: () => pickAudioPromo(),
                                        child: const Text('اضافه برومو '),
                                      ),
/*                                      CustomTextFiled(
                                        controller: text,
                                        hintText: 'اسم الحلقه الجديد',
                                        icons: Icons.email,
                                        inputType: TextInputType.text,
                                        focusNode: FocusNode(),
                                        obscure: false,
                                        onEditCom: () {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'ادخل البيانات ';
                                          }
                                        },
                                      ),*/
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(fileNamePromo),
                                      ),

                                      InkWell(
                                        onTap: (){

                                          loadAudio(audioURLPromo);

                                        //  playPause();

                                        },
                                        child: const Icon(Icons.play_circle_filled_sharp,color: Colors.blue,size: 40,),
                                      ),


                                      InkWell(
                                        onTap: (){

                                          player.stop();

                                        },
                                        child: Icon(Icons.stop_circle,color: Colors.red[900],size: 40,),
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
                                if (formKey.currentState!.validate()) {
                                  //mean user clicked save without actually choosing an audio

                                }
                              });
                        },
                        color: Colors.deepOrange,
                        padding: const EdgeInsets.all(12),
                        child: const Text(
                          'اضافه برومو',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),


                      InkWell(
                        onTap: (){

                          player.stop();

                        },
                        child: Icon(Icons.stop_circle,color: Colors.red[900],size: 40,),
                      ),


                      MaterialButton(
                        //new episode
                        onPressed: () {

                          notPicked = true;
                          fileName = "";
                          episName = "";

                          Get.defaultDialog(
                              title: 'اضافه',
                              barrierDismissible: false,
                              buttonColor: Colors.deepOrange,
                              content: Form(
                                key: formKey,
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          child: notPicked
                                              ? InkWell(
                                            onTap: (){
                                              uploadImage();
                                            },
                                            child: Image.network(
                                              'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                              : (kIsWeb)
                                              ? InkWell(
                                              onTap: (){
                                                uploadImage();
                                              },
                                              child: Image.memory(webImage))
                                              : InkWell(
                                              onTap: (){
                                                uploadImage();
                                              },
                                              child: Image.file(_file)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () => pickAudio(),
                                        child: const Text('اضافه المقطع '),
                                      ),
/*                                      CustomTextFiled(
                                        controller: text,
                                        hintText: 'اسم الحلقه الجديد',
                                        icons: Icons.email,
                                        inputType: TextInputType.text,
                                        focusNode: FocusNode(),
                                        obscure: false,
                                        onEditCom: () {},
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'ادخل البيانات ';
                                          }
                                        },
                                      ),*/

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(fileName),
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
                                if (formKey.currentState!.validate()) {
                                  //mean user clicked save without actually choosing an audio

                                }
                              });
                        },
                        color: Colors.deepOrange,
                        padding: const EdgeInsets.all(12),
                        child: const Text(
                          'اضافه حلقه',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.width * 0.5,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.builder(
                      itemCount: firstList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(firstList[index].EpisodeNum.toString()),
                            ),


                                SizedBox(
                                  width:50,
                                  height:50,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'episode number',
                                      hintStyle: const TextStyle(
                                          color: Color(0XFF8F8F8F),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                    ),
                                    onFieldSubmitted: (v){

                                      try {
                                        int.parse(v);

                                        updateEpisNum(index, int.parse(v));

                                      }catch(e){
                                        log(e.toString());

                                      }

                                      log("firstList[index].EpisodeNum: ${firstList[index].EpisodeNum}");

                                    },
                                  ),
                                ),



                            InkWell(
                              onTap: (){

                                loadAudio(firstList[index].url);

                              },
                              child: HoverCrossFadeWidget(
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
                                      firstList[index].episImageUrl.isEmpty?
                                      firstList[index].urlP
                                      : firstList[index].episImageUrl,
                                      fit: BoxFit.fill,
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
                                            firstList[index].episImageUrl.isEmpty?
                                            firstList[index].urlP
                                                : firstList[index].episImageUrl,
                                            fit: BoxFit.fill,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () {

                                Get.defaultDialog(
                                    title: 'تعديل',
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
                                              onPressed: () =>
                                                  editAudioEpis(index),
                                              child:
                                              const Text('تعديل المقطع '),
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  editImageEpis(index),
                                              child:
                                              const Text('تعديل الصورة '),
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  EpisNameEdit(index),
                                              child:
                                              const Text('تعديل اسم المسلسل او الفليم '),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    cancelTextColor: Colors.black,
                                    textCancel: 'خروج',
                                );


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
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                              onPressed: () {
                                Get.defaultDialog(
                                    title: 'مسح',
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
                                            const Text(
                                                "سيتم مسح الحلقة بكل بياناتها ؟"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    textConfirm: 'حذف',
                                    confirmTextColor: Colors.white,
                                    cancelTextColor: Colors.black,
                                    textCancel: 'خروج',
                                    onConfirm: () {
                                      deleteEpis(index);
                                    });
                              },
                              color: Colors.red[900],
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'حذف',
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

    audioURLPromo = "";
    audioRefPromo = "";

    try {
      final prefs = await SharedPreferences.getInstance();

      movieID = prefs.getString('movieID').toString();

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

              getEpisodesRow();
            });
          });

          // await getBooksRow();

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

  Future<void> getEpisodesRow() async {
    firstList = [];

    try {
      //s&m
      final url = Uri.parse(
          'https://pandarosh-91270-default-rtdb.firebaseio.com/s&mEpis.json?orderBy="movie"&equalTo="$movieID"');

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

            episImageRef: value['imageRef'] ?? "",
            episImageUrl: value['imageUrl'] ?? "",

            url: value['url'],

          ));
        });


        loadData.sort((a, b) => a.EpisodeNum.compareTo(b.EpisodeNum));


        setState(() {
          firstList = loadData;
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }
}

class EditButtonMovies extends StatefulWidget {
  const EditButtonMovies({Key? key}) : super(key: key);

  @override
  _EditButtonMoviesState createState() => _EditButtonMoviesState();
}

class _EditButtonMoviesState extends State<EditButtonMovies> {
  var formKey = GlobalKey<FormState>();

  File _fileP = File("zz");
  Uint8List webImageP = Uint8List(10);

  File _fileB = File("zz");
  Uint8List webImageB = Uint8List(10);

  //String _selectRemind = 'اختر اسم الCategory.....';
  //String _selectRemind2 = 'اختر اسم الكاتب.....';

  //List<String> remindList = ['البطل', 'الفاجر', 'البرنس', 'الشبح'];

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
        });
      } else {
        showToast("No file selected");
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
        });
      } else {
        showToast("No file selected");
      }
    } else {
      showToast("Permission not granted");
    }
  }

  Future<PermissionStatus> requestPermissions() async {
    await Permission.photos.request();
    return Permission.photos.status;
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

  final TextEditingController name = TextEditingController();
  final TextEditingController about = TextEditingController();
  final TextEditingController price = TextEditingController();

  String firstURL = "";
  String secondURL = "";

  String firstRef = "";
  String secondRef = "";

  List<mainL> categoriesList = [];
  List<mainL> writersList = [];

  String dropdownCategoryValue = 'اختر اسم الCategory.....';
  String dropdownWritersValue = 'اختر اسم الكاتب.....';

  bool loading = false;
  bool loadingP = false;

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

          await http.get(urll).then((value) {
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
                loading = false;
              });
            }
          });
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }

  void uploadN() async {
    try {
      Uri url =
      Uri.https('pandarosh-91270-default-rtdb.firebaseio.com', '/s&m.json');

      Uri urll = Uri.https(
          'pandarosh-91270-default-rtdb.firebaseio.com', '/s&mInfo.json');

      await http
          .post(
        urll,
        body: json.encode({
          'name': name.text,
          'num': "0",
          'urlB': secondURL,
          'urlP': firstURL,
          'refB': secondRef,
          'refP': firstRef,
          'category': categoriesList[categoriesList
              .indexWhere((f) => f.name == dropdownCategoryValue)]
              .idToEdit,
          'writer': writersList[
          writersList.indexWhere((f) => f.name == dropdownWritersValue)]
              .idToEdit,
          'about': about.text,
          'profits': "0",
          'time': "0",
          'episodes': "0",
          'cID': "",
          'price': price.text,
          'urlID': "",
        }),
      )
          .then((value) async {
        await http
            .post(
          url,
          body: json.encode({
            'name': name.text,
            'num': "0",
            'urlB': secondURL,
            'urlP': firstURL,
            'info': json.decode(value.body)['name'].toString(),
          }),
        )
            .then((value) async {
          //get num of the writer

          String wirterID = writersList[
          writersList.indexWhere((f) => f.name == dropdownWritersValue)]
              .idToEdit;
          String categoryID = categoriesList[categoriesList
              .indexWhere((f) => f.name == dropdownCategoryValue)]
              .idToEdit;

          Uri urlwrit = Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
              '/writers/$wirterID/num.json');
          Uri urlcat = Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
              '/categories/$categoryID/num.json');

          await http.get(urlwrit).then((value) async {
            //update writer
            await http
                .patch(
              Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
                  '/writers/$wirterID.json'),
              body: json.encode({
                'num': (int.parse(json.decode(value.body).toString()) + 1)
                    .toString(),
              }),
            )
                .then((value) async {
              await http.get(urlcat).then((valuee) async {
                log("444444444: ${json.decode(valuee.body)}");

                log("55555555: ${int.parse(json.decode(valuee.body).toString())}");

                //update category
                await http
                    .patch(
                  Uri.https('pandarosh-91270-default-rtdb.firebaseio.com',
                      '/categories/$categoryID.json'),
                  body: json.encode({
                    'num': (int.parse(json.decode(valuee.body).toString()) + 1)
                        .toString(),
                  }),
                )
                    .then((value) {
                  setState((){
                    loadingP = false;
                  }); //pull

                  Get.off(const HomeScreen());
                });
              });
            });
          });

          //get num of category
          //update it
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  double progress = 0;

  void uploadImage() {

    setState((){
      loadingP = true;
    });

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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
  }

  void uploadImage2() {
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

          setState((){

            progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);

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

          setState((){
            loadingP = false;
          });

          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Error"),
            content: const Text("please try again"),
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
                    price.text.isEmpty ||
                    dropdownCategoryValue == 'اختر اسم الCategory.....' ||
                    dropdownWritersValue == 'اختر اسم الكاتب.....' ||
                    _fileP.path == "zz" ||
                    _fileB.path == "zz") {
                  log("emptyy");
                } else {
                  //upload Images
                  uploadImage();

                  // uploadN();

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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: const CircularProgressIndicator(),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _fileP.path == "zz"
                              ? Image.network(
                            'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                            fit: BoxFit.fill,
                          )
                              : (kIsWeb)
                              ? Image.memory(webImageP)
                              : Image.file(_fileP),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: () => uploadImageP(),
                          child: const Text('اضافه '),
                        ),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _fileB.path == "zz"
                              ? Image.network(
                            'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?s=612x612',
                            fit: BoxFit.fill,
                          )
                              : (kIsWeb)
                              ? Image.memory(webImageB)
                              : Image.file(_fileB),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0),
                        child: ElevatedButton(
                          onPressed: () => uploadImageB(),
                          child: const Text('اضافه '),
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
                        widget: DropdownButton<String>(
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
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InputField(
                        title: 'اسم الكاتب',
                        hint: dropdownWritersValue,
                        widget: DropdownButton<String>(
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
                        ),
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
