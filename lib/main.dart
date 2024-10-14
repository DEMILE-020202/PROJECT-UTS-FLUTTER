import 'package:assigner/pages/login.dart';
import 'package:assigner/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:assigner/pages/main-page.dart';
import 'package:assigner/splash-screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Cabin",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const LoginScreen(),
      },
    );
  }
}

