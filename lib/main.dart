import 'package:assigner/pages/login.dart';
import 'package:assigner/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:assigner/pages/homepage_student.dart';
import 'package:assigner/splash-screen.dart';
import 'package:assigner/models/dark_mode_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => LoginScreen(),
      },
    );
  }

}

