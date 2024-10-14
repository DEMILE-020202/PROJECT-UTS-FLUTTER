import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 8),
          () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/logo.png', width: 300, height: 300),
            const Padding(padding: EdgeInsets.all(6)),
            const CircularProgressIndicator(color: Colors.white,
                strokeWidth: 8),
          ],
        ),
      ),
    );
  }
}
