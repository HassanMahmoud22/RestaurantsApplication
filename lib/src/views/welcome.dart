import 'package:flutter/material.dart';


class welcomescreen extends StatefulWidget {
  @override
  State<welcomescreen> createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Stores',
                  style: TextStyle(
                    color: Color(0xff001D6E),
                    fontSize: 30,
                    fontFamily: 'myfonts',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Quickly! ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff001D6E),
                      fontFamily: 'myfonts',
                    )),
                SizedBox(
                  height: 5,
                ),
                Text('Choose your favourite store',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff001D6E),
                      fontFamily: 'myfonts',
                    )),
                SizedBox(
                  height: 10,
                ),
              //  Image.asset('images/one.jpg'),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF001E6C)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 106, vertical: 10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
