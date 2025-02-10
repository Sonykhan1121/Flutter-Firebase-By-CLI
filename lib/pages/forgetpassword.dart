import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isloading = false;

  void Reset_password() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isloading = true);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset email sent. Check your inbox to continue.')));
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Make sure to pop the dialog in case of an error too
        String errorMessage = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else {
          errorMessage = e.message ?? errorMessage; // Use the default error message if message is null
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Recovery"),
        backgroundColor: Colors.orange,

      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Password Recovery' ,style: TextStyle(fontSize: 36),),

            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: TextFormField(
                controller: _emailController,
                validator: (value){
                  if(value==null || value!.isEmpty)
                    {
                      return "Please Enter Email";
                    }
                  else
                    {
                      return null;
                    }
                },
                decoration: InputDecoration(
                  labelText: 'Enter your registered email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),

                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_isloading)
                  {
                    return;
                  }
                else
                  {
                    Reset_password();
                  }
              },
              child: Text('Send Reset Link'),
            ),
            SizedBox(height: 16),
            Text('Already have an account?'),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
