import 'package:flutter/material.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:home_layout(),
    );
  }

}
