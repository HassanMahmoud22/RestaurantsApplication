
import 'package:flutter/material.dart';

class levelselect extends StatelessWidget {
  const levelselect({
    Key? key,
    required this.levelController,
  }) : super(key: key);

  final TextEditingController levelController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Levels:",
              style: TextStyle(
                color: Color(0xFF001E6C),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Radio(
                value: "1",
                groupValue: levelController,
                onChanged: (var value) {
                  var levelController= value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(
                    Color(0xFF001E6C)),
              ),
              const Text(
                '1',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          ),
          SizedBox(width: 25,),
          Row(
            children: [
              Radio(
                value: "2",
                groupValue: levelController,
                onChanged: (var value) {
                  var levelController = value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(
                    Color(0xFF001E6C)),
              ),
              const Text(
                '2',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          Row(
            children: [
              Radio(
                value: "3",
                groupValue: levelController,
                onChanged: (var value) {
                  var levelController= value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(
                    Color(0xFF001E6C)),
              ),
              const Text(
                '3',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          Row(
            children: [
              Radio(
                value: "4",
                groupValue: levelController,
                onChanged: (var value) {
                  var levelController= value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(
                    Color(0xFF001E6C)),
              ),
              const Text(
                '4',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}