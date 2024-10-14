import 'dart:io';

import 'package:flutter/material.dart';
import 'package:assigner/pages/signup.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white70,
        body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _logoSection(context),
              _headerSection(context),
              const Padding(padding: EdgeInsets.all(8)),
              _inputFieldSection(context),
              const Padding(padding: EdgeInsets.all(8)),
              _forgotPassSection(context),
              const Padding(padding: EdgeInsets.all(12)),
              _signUpSection(context),
            ],
          ),
        ),
       ),
      ),
    );
  }
  _logoSection(context) {
    return Column(
        children: [
        Image.asset('assets/logo.png', width: 250, height: 250),
        ]
    );
  }

  _headerSection(context) {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,
          color: Colors.lightBlue),
        ),
        Text("Please sign in to continue", style: TextStyle(fontSize: 15,
        color: Colors.blue)),
      ],
    );
  }

  _inputFieldSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        TextField(
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide.none
              ),
              fillColor: Colors.blue.withOpacity(0.1),
              filled: true,
              ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {

          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        )
      ],
    );
  }

  _forgotPassSection(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("Forgot your password?",
        style: TextStyle(color: Colors.indigo),
      ),
    );
  }

  _signUpSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?", style: TextStyle(fontSize: 15,
            color: Colors.blue)),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
            child: const Text("Sign Up", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold),
            ),
        )
      ],
    );
  }
}