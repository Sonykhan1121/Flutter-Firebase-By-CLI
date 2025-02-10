import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'homepage.dart';
import 'loginpage.dart';

class Signuppage extends StatefulWidget {
  Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void registration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Successfully registered')));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Homepage(
                      name: _nameController.text,
                    )));
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please Enter a Strong Password')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Email already in use')));
        }
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isProcessing = true; // Show loading indicator
    });
    try {
      // 1. Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // 2. Get the Google Auth Credentials
        final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

        // 3. Create a new Firebase credential with the Google Auth Credentials
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // 4. Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to the home page (or wherever you want to go)
        Navigator.pushReplacement( // Use pushReplacement to avoid going back to signup
            context,
            MaterialPageRoute(
                builder: (context) => Homepage(
                  name: userCredential.user?.displayName ?? "User", // Provide a default name
                )));


      }
    } catch (e) {
      print("Google Sign-in Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google')),
      );
    } finally {
      setState(() {
        _isProcessing = false; // Hide loading indicator
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/tht.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Image.asset(
                        'assets/fb.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Image.asset(
                        'assets/insta.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Image.asset(
                        'assets/you.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Create a ",
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      TextSpan(
                          text: "Wowomart ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: 'account',
                          style: TextStyle(
                            color: Colors.black,
                          ))
                    ]),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value!.isEmpty) {
                        return "Please Enter Name";
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value!.isEmpty) {
                        return "Please Enter Email";
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value!.isEmpty) {
                        return "Please Enter Password";
                      }
                      return null;
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _isProcessing
                          ? null
                          : () {
                              registration();
                            },
                      child: Text('Create'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Loginpage()));
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _isProcessing ? null : _signInWithGoogle, // Disable button while processing
                  child: _isProcessing // Show indicator if processing
                      ? CircularProgressIndicator()
                      : Image.asset(
                    "assets/google.jpg",
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
