import 'package:absensi/views/homePage.dart';
import 'package:absensi/views/login.dart';
import 'package:flutter/material.dart';
import 'package:absensi/views/map.dart';
import 'package:absensi/utils/sharedPref.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final SharedPref _sp = SharedPref();

  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    Map.tag: (context) => Map(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: _sp.isLogin() == true ? HomePage() : LoginPage(),
      routes: routes,
    );
  }
}
