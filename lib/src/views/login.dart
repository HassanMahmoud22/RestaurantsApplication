import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobileproject/my_api.dart';
import 'package:mobileproject/src/views/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

import 'Menu.dart';
class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _errorMessage1 = '';
  String _errorMessage2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('Get Stores',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff001D6E),
                          )),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          if (emailController.text.isNotEmpty ||
                              passwordController.text.isNotEmpty) {
                            setState(() {
                              _errorMessage2 = "";
                            });
                          }
                          validateEmail(val);
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          if (emailController.text.isNotEmpty ||
                              passwordController.text.isNotEmpty) {
                            setState(() {
                              _errorMessage2 = "";
                            });
                          }
                          validatePassword(val);
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty &&
                              passwordController.text.isEmpty) {
                            setState(() {
                              _errorMessage2 =
                                  "please Write Email and Password right";
                            });
                          } else {
                            _login();
                          }
                        },
                        child: Text(
                          _isLoading ? "Logining .." : "LOGIN",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF001E6C)),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 106, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          _errorMessage1,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          _errorMessage2,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Forgot Password ?',
                          style: TextStyle(color: Color(0xff001D6E))),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an accout? "),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => signup()));
                              },
                              child: const Text(
                                " SIGNUP",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff001D6E)),
                              )),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  void validatePassword(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage1 = "password can not be empty";
      });
    } else if (val.length < 8) {
      setState(() {
        _errorMessage1 = "Invalid Password";
      });
    } else {
      setState(() {
        _errorMessage1 = "";
      });
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      "email": emailController.text,
      "password": passwordController.text
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);
    if (body['message'] == 'logged in successfully') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
          //context, MaterialPageRoute(builder: (context) => MainAllProducts()));
    } else {
      _errorMessage = body['message'];
    }

    setState(() {
      _isLoading = false;
    });
  }
}
