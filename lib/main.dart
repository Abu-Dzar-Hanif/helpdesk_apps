import 'package:flutter/material.dart';
import 'package:helpdesk_apps/view/SearchTeknisi.dart';
import 'package:helpdesk_apps/SplashScreen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
    // home: SearchTeknisi(),
    home: SplashScreen(),
  ));
}
