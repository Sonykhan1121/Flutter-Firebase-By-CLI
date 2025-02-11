import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cli_firebase/CRUD/readdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'database.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {

  File? _image;
  final ImagePicker _picker = ImagePicker();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final _firstNametextcontroller = TextEditingController();
  final _lastNametextcontroller = TextEditingController();
  final _agetextcontroller = TextEditingController();




  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _image = File(selectedImage.path);  // Convert XFile to File
      });
    }
  }
  void _uploadData() async {
    Map<String,dynamic> uploadData ={
      "firstName":_firstNametextcontroller.text,
      "lastName":_lastNametextcontroller.text,
      "age":_agetextcontroller.text,
      "image": _image!.path,
    };
    DatabaseMethods().addUserDetails(uploadData);

    Fluttertoast.showToast(
        msg: " Data Added Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );



  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "CRUD operations",

          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? Icon(Icons.camera_alt, size: 50, color: Colors.white) : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _firstNametextcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Your First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _lastNametextcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Your Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _agetextcontroller,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Your Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                        }
                        _uploadData();
                        _formKey.currentState?.reset();

                      },
                      child: Text('Create'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),// 'primary' is used for background color
                      ),
                    )

                  ),
                  SizedBox(width: 15,),
                  Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadDataPage(),),);

                        },
                        child: Text('Read Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),// 'primary' is used for background color
                        ),
                      )

                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
