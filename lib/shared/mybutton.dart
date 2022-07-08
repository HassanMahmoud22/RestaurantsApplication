import 'package:flutter/material.dart';
class mybutton extends StatelessWidget {
    mybutton({required this.title, required this.onPressed});

  
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed,
      child: Text(
        title,
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
    );
  }
}