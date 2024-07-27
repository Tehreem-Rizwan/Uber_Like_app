import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_like_app/screens/home_screen.dart';
import '../components/my_textfield.dart';
import '../models/UIHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void checkValues() {
    String fullName = fullNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      UIHelper.showAlertDialog(
          context, "Incomplete Data", "Please fill all the fields");
    } else if (password != confirmPassword) {
      UIHelper.showAlertDialog(context, "Password Mismatch",
          "The password and confirm password do not match");
    } else {
      signUp(fullName, email, password);
    }
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }),
    );
  }

  void signUp(String fullName, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email,
        'uid': uid,
      });

      // Registration successful, navigate to HomePage
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
      UIHelper.showAlertDialog(context, "Sign Up Failed", e.message!);
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
                    "Create a new account",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 50),
                  MyTextfield(
                    controller: fullNameController,
                    hintText: "Full Name",
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 10),
                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  CupertinoButton(
                    onPressed: () {
                      checkValues();
                    },
                    color: Colors.black,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Log In",
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
