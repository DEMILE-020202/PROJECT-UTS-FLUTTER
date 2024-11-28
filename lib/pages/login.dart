import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assigner/pages/signup.dart';
import 'package:assigner/pages/homepage_student.dart';
import 'package:assigner/pages/homepage_teacher.dart';
import 'package:assigner/models/user_model.dart';
import 'package:assigner/models/database_conn.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DbConn dbConn = DbConn.instance;

  void popUp(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(
            fontSize: 24,
          ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
              children: <Widget>[
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
    return Column(children: [
      Image.asset('assets/logo.png', width: 200, height: 200),
    ]);
  }

  _headerSection(context) {
    return const Column(
      children: [
        Text(
          "Welcome",
          style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue),
        ),
        Text("Please log in to continue",
            style: TextStyle(fontSize: 15, color: Colors.blue)),
      ],
    );
  }

  _inputFieldSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 36),
        TextFormField(
          controller: _emailController,
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
        TextFormField(
          controller: _passwordController,
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
          onPressed: () async {
            String email = _emailController.text;
            String password = _passwordController.text;
            Map<String, dynamic>? user = await dbConn.getUser(email, password);

            if (user != null) {
              String prof = user['profession'];

              if (prof == 'Student') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageStu(userData: user)),
                );
              } else if (prof == 'Teacher') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageTea(userData: user, creator: user['username'],)),
                );
              }
            } else {
              popUp(context, 'Invalid credentials'
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            "Login",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        )
      ],
    );
  }

  _forgotPassSection(context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot your password?",
        style: TextStyle(color: Colors.indigo),
      ),
    );
  }

  _signUpSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(fontSize: 15, color: Colors.blue)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupScreen()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
