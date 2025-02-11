import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli_firebase/CRUD/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReadDataPage extends StatefulWidget {
  @override
  _ReadDataPageState createState() => _ReadDataPageState();
}

class _ReadDataPageState extends State<ReadDataPage> {
  final TextEditingController _firstNameController = TextEditingController();
  bool datafound = false;
  String fullName = '';
  String age = '';
  String imagePath = '';
  // Function for handling search action (can be linked to Firestore or any database logic)
  void _searchUser() async {
    String firstName = _firstNameController.text.trim().toLowerCase(); // Trim input to remove any extra spaces.

    if (firstName.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a first name");
      return;
    }

    try {
      QuerySnapshot querySnapshot = await DatabaseMethods().getthisUserInfo(firstName);
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        setState(() {
          fullName = userDoc['firstName'] + ' ' + userDoc['lastName'];
          age = userDoc['age'].toString(); // Ensuring age is a string, handle this depending on your data model
          imagePath = userDoc['image'];
          datafound = true;
        });
      } else {
        Fluttertoast.showToast(msg: "No user found with that name",backgroundColor: Colors.red,textColor: Colors.yellow);
        setState(() {
          datafound = false; // Reset the flag to hide previous user data
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to fetch data: ${e.toString()}");
      setState(() {
        datafound = false; // Ensure UI is consistent with error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Read Data")),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                "Write User First Name",

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'Enter First Name',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                // fillColor: Color(0xFF5C6BC0), // #5C6BC0 (Blue shade)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _searchUser,
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF42A5F5), // #42A5F5 (Light Blue)
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                  textStyle: TextStyle(fontSize: 16,),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),


            if (datafound) ...[
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Image.file(
                      File(imagePath),
                      width: 250,
                      height: 250,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    ),
                    Text(fullName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Age: $age', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],




          ],
        ),
      ),
    );
  }
}