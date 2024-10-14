import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _logoSection(context),
                _headerSection(context),
                const Padding(padding: EdgeInsets.all(8)),
                _inputSection(context),
                const Padding(padding: EdgeInsets.all(8)),
                _signUpButton(context),
                const Padding(padding: EdgeInsets.all(8)),
                _loginSection(context),
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
          "Sign up",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.lightBlue,
          ),
        ),
        Text(
          "Create your account",
          style: TextStyle(fontSize: 15, color: Colors.blue),
        )
      ],
    );
  }

  _inputSection(context) {
    return Column(
      children: [
        const SizedBox(height: 16),
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
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide.none),
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

        const SizedBox(height: 16),

        TextField(
          decoration: InputDecoration(
            hintText: "Confirm Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
          ),
          obscureText: true,
        ),
      ],
    );
  }

  _signUpButton(context) {
    return Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        child: ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            "Sign up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
        )
    );
  }

  _loginSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?", style: TextStyle(fontSize: 15,
            color: Colors.blue)),
        TextButton(
            onPressed: () {
            },
            child: const Text("Login", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold),)
        )
      ],
    );
  }
}