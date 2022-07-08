import 'package:flutter/material.dart';

class genderselect extends StatelessWidget {
  const genderselect({
    Key? key,
    required this.genderController,
  }) : super(key: key);

  final TextEditingController genderController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Gender:",
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
                value: "Male",
                groupValue: genderController,
                onChanged: (var value) {
                  var genderController = value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(Color(0xFF001E6C)),
              ),
              const Text(
                'Male',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: "Female",
                groupValue: genderController,
                onChanged: (var value) {
                  var genderController = value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(Color(0xFF001E6C)),
              ),
              const Text(
                'Female',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF001E6C),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: "Others",
                groupValue: genderController,
                onChanged: (var value) {
                  var genderController = value;
                },
                activeColor: Color(0xFF001E6C),
                fillColor: MaterialStateProperty.all(Color(0xFF001E6C)),
              ),
              const Text(
                'Others',
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
