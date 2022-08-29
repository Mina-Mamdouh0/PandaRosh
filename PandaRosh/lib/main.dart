
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pandarosh/unit/routes.dart';
import 'package:pandarosh/unit/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Bloc/cubit.dart';
import 'Bloc/states.dart' ;
import 'firebase_options.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:oktoast/oktoast.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setUrlStrategy(PathUrlStrategy());
  runApp(

      OKToast(
        position: ToastPosition.bottom,
      child: const MyApp()
      )

  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*BlocProvider(
      create: (BuildContext context) => PandaroshCubit()..initPlayer(),
      child: BlocConsumer<PandaroshCubit, PandaroshStates>(
        listener: (context, state) {},
        builder: (context, state) {
         // var cubit = PandaroshCubit.get(context);

          return */GetMaterialApp(
            scrollBehavior:MaterialScrollBehavior().copyWith( dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown}, ),
            debugShowCheckedModeBanner: false,
            title: 'باندا روش',
            theme: Themes.dark,
            darkTheme: Themes.light,
            themeMode: ThemeController().themeMode,
            getPages: RoutesPage.routes,
            initialRoute: RoutesPage.initScreen,
          );
/*        },
      ),
    );*/

  }
}

