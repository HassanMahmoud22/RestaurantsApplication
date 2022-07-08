

import 'package:flutter/material.dart';
import 'package:mobileproject/src/views/home.dart';
import 'package:mobileproject/src/views/login.dart';
import 'package:mobileproject/src/views/signup.dart';
import 'package:mobileproject/src/views/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLoggedIn = null;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        _isLoggedIn = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff001D6E)),
              borderRadius: BorderRadius.circular(25),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff001D6E)),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff001D6E)),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        initialRoute: _isLoggedIn != null ? "/home" : "/",
        routes: {
          "/": (context) => welcomescreen(),
          "/login": (context) => login(),
          "/signup": (context) => signup(),
          "/home": (context) => MainPage(),
        });
  }
}
