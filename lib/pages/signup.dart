import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assigner/pages/login.dart';
import 'package:assigner/models/user_model.dart';
import 'package:assigner/models/database_conn.dart';
import 'package:sqflite/sqflite.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<String> items = [
    'Student',
    'Teacher',
  ];
  bool _obscure = true;
  bool _obscureConf = true;
  String? selectedValue;
  final dbConn = DbConn.instance;

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
          Image.asset('assets/logo.png', width: 200, height: 200),
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


  //Class input Sign up/Registration
  _inputSection(context) {
    return Form(
      key: _formKey,
      child: Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a username';
            }
            if (value.length < 4) {
              return 'Username must at least have 4 characters';
            }
            if (value.length > 20) {
              return 'Username must contain no more than 20 characters';
            }
            return null;
          },
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

        TextFormField(
          controller: _emailController,
          validator: (value) {
            final regExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

            if (value!.isEmpty) {
              return 'Please enter an email';
            } else if (!regExp.hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
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
          validator: (value) {
            final regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');

            if (value!.isEmpty) {
              return 'Please enter a password';
            }
            else if (!regExp.hasMatch(value)) {
              return 'Minimum of 6 characters using letters and numbers';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility : Icons.visibility_off
              ), color: Colors.black,
              onPressed: () {
                setState(() {
                  _obscure = !_obscure;
                });
              },
            ),
          ),
          obscureText: _obscure,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _confirmPasswordController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please confirm password';
            }
            if (value != _passwordController.text) {
              return 'Password does not match';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Confirm Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(36),
                borderSide: BorderSide.none),
            fillColor: Colors.blue.withOpacity(0.1),
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                  _obscureConf ? Icons.visibility : Icons.visibility_off
              ), color: Colors.black,
              onPressed: () {
                setState(() {
                  _obscureConf = !_obscureConf;
                });
              },
            ),
          ),
          obscureText: _obscureConf,
        ),

        const SizedBox(height: 16),

        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Profession',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 50,
              width: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 24,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.blue[100],
              ),
              offset: const Offset(25, 0),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
      ),
    );
  }

  //Class Sign Up Button
  _signUpButton(context) {
    return Container(
        padding: const EdgeInsets.only(top: 3, left: 3),
        child: ElevatedButton(
          onPressed: () async {
    if (_formKey.currentState!.validate()) {
            String username = _usernameController.text;
            String email = _emailController.text;
            String password = _passwordController.text;
            String? profession = selectedValue;
            User user = User(username: username,
                email: email,
                password: password,
                profession: profession!);

            if (profession == null) {
              popUp(context, 'Please select a profession'
              );
              return;
            }
            try {
              await dbConn.insertUser(user);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } catch (e) {
              if (e is DatabaseException && e.isUniqueConstraintError()) {
                popUp(context, 'Username or email already in use'
                );
              } else { popUp(context, 'Registration failed: $e'
              );
              }
            }
            }
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

  //Class
  _loginSection(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?", style: TextStyle(fontSize: 15,
            color: Colors.blue)),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text("Login", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold),)
        )
      ],
    );
  }
}
