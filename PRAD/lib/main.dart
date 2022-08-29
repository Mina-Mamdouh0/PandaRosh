import 'dart:ui';

import 'package:prad/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        scrollBehavior:MaterialScrollBehavior().copyWith( dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown}, ),
      debugShowCheckedModeBanner: false,
      title: 'ادمن بندا روش',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  LoginScreen()
    );
  }
}

