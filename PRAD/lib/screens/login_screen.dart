import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:prad/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget.dart';

import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  var formKey = GlobalKey<FormState>();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  bool _isConnectionSuccessful = false;

  @override
  void initState() {
    super.initState();

    checkifLogged();
  }

  bool obscure = true;


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
              'لوحه التحكم الخاصه بموقع بندا روش',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.03),
            ),
          ),
          body: SingleChildScrollView(
              child: Form(
            key: formKey,
            child: Center(
              child: SizedBox(
                height: 500,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFiled(
                      controller: _email,
                      hintText: 'البريد الالكتروني',
                      icons: Icons.email,
                      inputType: TextInputType.text,
                      focusNode: _emailFocus,
                      obscure: false,
                      onEditCom: () =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ادخل البريد الالكتروني';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFiled(
                      widget: IconButton(
                        onPressed: () {

                          setState(() {
                            obscure = !obscure;
                          });

                        },
                        icon: const Icon(
                          Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                      controller: _password,
                      hintText: 'كلمه السر',
                      icons: Icons.lock,
                      inputType: TextInputType.visiblePassword,
                      focusNode: _passwordFocus,
                      obscure: obscure,
                      onEditCom: () {},
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'ادخل كلمه السر';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {

                        if(_email.text.isEmpty || _password.text.isEmpty){
                          log("empty");
                        }else{

                          //_tryConnection();

                          if(true){
                            login();
                          }else{

                            // set up the button
                            Widget okButton = TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: const Text("No Internet"),
                              content: const Text("please check your Internet Connection"),
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

                          }

                        }

                      },
                      color: Colors.deepOrange,
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))),
    );
  }


  void checkifLogged() async{

    final prefs = await SharedPreferences.getInstance();


    if (prefs.containsKey('userData')) {

      //user already logged in
      final extractedUserData = json.decode(prefs.getString('userData').toString()) as Map<String, dynamic>;

      Get.off(const HomeScreen());

    }
    else {

      log("not logged");

    }


  }


  void login(){

    final url = Uri.parse(
        'https://pandarosh-91270-default-rtdb.firebaseio.com/admins.json?orderBy="email"&equalTo="'+ _email.text +'"');

    log(url.toString());

    try {
      http.get(url).then((value) async {

        String name = "";
        String email = "";
        String password = "";
        String role = "";


        if (value.body == "{}") {

          // set up the button
          Widget okButton = TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );

          // set up the AlertDialog
          AlertDialog alert = AlertDialog(
            title: const Text("Wrong Email"),
            content: const Text("please check your email"),
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

        }
        else {
          final extractedData = json.decode(value.body) as Map<String, dynamic>;

          extractedData.forEach((key, value) {
            name = value['name'].toString();
            email = value['email'].toString();
            password = value['password'].toString();
            role = value['role'].toString();
          });

          if (password == _password.text) {
            log("logged     " + name);


            final prefs = await SharedPreferences.getInstance();
            final userData = json.encode({
              'name': name,
              'email': email,
              'role': role,
            },);

            prefs.setString('userData', userData);

            Get.off(const HomeScreen()); //pullAndPush

          } else {

            // set up the button
            Widget okButton = TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: const Text("Wrong Email"),
              content: const Text("please check your email."),
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

          }

        }


      });


    } catch (error) {
      log(error.toString());
      throw(error);
    }

  }


/*
  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }
*/

}
