import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  String name;
   Homepage({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Hi , $name Welcome to the home page!'),
      ),
    );
  }
}
