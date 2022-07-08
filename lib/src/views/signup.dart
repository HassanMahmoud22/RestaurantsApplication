import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobileproject/src/views/Menu.dart';
import 'package:mobileproject/src/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobileproject/my_api.dart';

class signup extends StatefulWidget {
  @override
  State<signup> createState() => _signupState();
}

enum gender { male, female, nuls }

enum Level { one, two, three, four, nuls }

class _signupState extends State<signup> {
  gender _site = gender.nuls;
  Level _site1 = Level.nuls;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var fullnameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var confirmpassController = TextEditingController();
  var genderController = TextEditingController();
  var levelController = TextEditingController();
  var mess = "";
  String _errorMessage = '';
  String _errorMessage1 = '';
  String _errorMessage2 = '';

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Get Stores',
                        style: TextStyle(
                          color: Color(0xff001D6E),
                          fontSize: 40,
                          fontFamily: 'myfonts',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: fullnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            if (emailController.text.isNotEmpty ||
                                passwordController.text.isNotEmpty ||
                                fullnameController.text.isNotEmpty) {
                              setState(() {
                                _errorMessage2 = "";
                              });
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          if (emailController.text.isNotEmpty ||
                              passwordController.text.isNotEmpty ||
                              fullnameController.text.isNotEmpty) {
                            setState(() {
                              _errorMessage2 = "";
                            });
                          }
                          validateEmail(val);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            if (emailController.text.isNotEmpty ||
                                passwordController.text.isNotEmpty ||
                                fullnameController.text.isNotEmpty) {
                              setState(() {
                                _errorMessage2 = "";
                              });
                            }
                            validatePassword(val);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: confirmpassController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(
                              Icons.lock,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            if (emailController.text.isNotEmpty ||
                                passwordController.text.isNotEmpty ||
                                fullnameController.text.isNotEmpty) {
                              setState(() {
                                _errorMessage2 = "";
                              });
                            }
                            validatePassword(val);
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Gender"),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text('male'),
                        leading: Radio(
                          value: gender.male,
                          groupValue: _site,
                          onChanged: (gender? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('female'),
                        leading: Radio(
                          value: gender.female,
                          groupValue: _site,
                          onChanged: (gender? value) {
                            setState(() {
                              _site = value!;
                            });
                          },
                        ),
                      ),
                      Text("Level"),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text('1'),
                        leading: Radio(
                          value: Level.one,
                          groupValue: _site1,
                          onChanged: (Level? value) {
                            setState(() {
                              _site1 = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('2'),
                        leading: Radio(
                          value: Level.two,
                          groupValue: _site1,
                          onChanged: (Level? value) {
                            setState(() {
                              _site1 = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('3'),
                        leading: Radio(
                          value: Level.three,
                          groupValue: _site1,
                          onChanged: (Level? value) {
                            setState(() {
                              _site1 = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('4'),
                        leading: Radio(
                          value: Level.four,
                          groupValue: _site1,
                          onChanged: (Level? value) {
                            setState(() {
                              _site1 = value!;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              fullnameController.text.isEmpty ||
                              confirmpassController.text.isEmpty) {
                            setState(() {
                              _errorMessage2 =
                                  "please Write Email and Password";
                            });
                          } else {
                            if (_errorMessage.isEmpty &&
                                _errorMessage1.isEmpty &&
                                _errorMessage2.isEmpty) {
                              _register();
                            } else {
                              setState(() {
                                _errorMessage2 = "please follow error message";
                              });
                            }
                          }
                        },
                        child: Text(
                          "SIGNUP",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an accout? "),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => login()));
                              },
                              child: const Text(
                                " LOGIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff001D6E)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
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

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    var x, x1;
    if (_site == gender.female) {
      x = "female";
    } else if (_site == gender.male) {
      x = "male";
    } else {
      x = "";
    }
    if (_site1 == Level.one) {
      x1 = "1";
    } else if (_site1 == Level.two) {
      x1 = "2";
    } else if (_site1 == Level.three) {
      x1 = "3";
    } else if (_site1 == Level.four) {
      x1 = "4";
    } else {
      x1 = "";
    }
    var data = {
      'name': fullnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'gender': x,
      'level': x1
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);
    if (body['message'] == 'The account is created successfully') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      //  localStorage.setString('user', json.encode(body['user']));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu()));
    } else {
      _errorMessage = body['message'];
    }

    setState(() {
      _isLoading = false;
    });
  }
}
