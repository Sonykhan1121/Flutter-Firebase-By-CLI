import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli_firebase/pages/homepage.dart';
import 'package:flutter_cli_firebase/pages/signuppage.dart';

import 'forgetpassword.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _emailtextController = TextEditingController();
  final _passwordtextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _emailtextController.dispose();
    _passwordtextController.dispose();
    super.dispose();
  }
  String extractUsername(String email) {
    String username = email.split('@')[0];
    return username;
  }
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailtextController.text.trim(),
          password: _passwordtextController.text.trim(),
        );
        if (result.user != null) {
          Navigator.pop(context); // Ensure dialog is popped in success case
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage(name: extractUsername(_emailtextController.text))),
          );
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Always pop the dialog on error
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'user-disabled':
            errorMessage = "This account has been disabled.";
            break;
          case 'user-not-found':
            errorMessage = "No user found with this email address.";
            break;
          case 'wrong-password':
            errorMessage = "Incorrect password, please try again.";
            break;
          case 'too-many-requests':
            errorMessage = "Too many attempts. Please try again later.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Signing in with email and password is not enabled.";
            break;
          default:
            errorMessage = "An unexpected error occurred. Please try again.";
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/login_logo.png',
                height: 120,
                width: 120,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login to Your Account',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: TextFormField(
                  controller: _emailtextController,
                  validator: (value)
                  {
                    if(value==null || value!.isEmpty)
                      {
                        return "Please Enter Email";
                      }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: " Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: TextFormField(
                  validator: (value){
                    if(value==null || value!.isEmpty)
                    {
                      return "Please Enter Password";
                    }
                    return null;
                  },
                  controller: _passwordtextController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    
                    onPressed: () {
                      _isProcessing?null:_login();

                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Signuppage()));

                    },
                    child: Text('Create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                  ),

                ],
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Forgetpassword()));
                },
                child: Text(
                  "I forgot my password!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}