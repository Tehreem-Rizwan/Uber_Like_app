import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_like_app/screens/home_screen.dart';
import 'package:uber_like_app/screens/signup_screen.dart';
import '../components/my_textfield.dart';
import '../models/UIHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else {
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Login successful, navigate to HomePage
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      UIHelper.showAlertDialog(context, "Login Failed", e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Icon(
                    Icons.car_repair_rounded,
                    size: 80,
                    color: Colors.grey[800],
                  ),
                  SizedBox(height: 50),
                  const Text(
                    "Welcome Back, you have been missed!!",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 50),
                  MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  MyTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Colors.black,
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return RegisterPage();
                            }),
                          );
                        },
                        child: Text(
                          "Register now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
