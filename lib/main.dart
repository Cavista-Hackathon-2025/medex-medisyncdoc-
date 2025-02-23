import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../view/on_boarding/on_boarding_view.dart';
import '../common/color_extension.dart';
import '../common/locator.dart';
import '../common/service_call.dart';
import '../view/login/welcome_view.dart';
import '../view/main_tabview/main_tabview.dart';
import 'view/login/rest_password_view.dart';
import 'view/on_boarding/startup_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/globs.dart';
import 'common/my_http_overrides.dart';
import 'view/login/login_view.dart';

SharedPreferences? prefs;
void main() async {


  runApp( const MyApp(defaultHome:  StartupView(),));
}



class MyApp extends StatefulWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediSyncdoc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis",

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: const StartupView(),
    );
  }
}
