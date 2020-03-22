import 'package:flutter/material.dart';

class DoubleTextField extends StatelessWidget {
  final String firstHint;
  final String secondHint;

  final TextEditingController firstController;
  final TextEditingController secondController;

  const DoubleTextField(
      {this.firstHint,
      this.secondHint,
      this.firstController,
      this.secondController});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: firstController,
          decoration: InputDecoration(
              hintText: firstHint,
              hintStyle: TextStyle(color: Color.fromRGBO(201, 201, 201, 1.0))),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Expanded(
        child: TextFormField(
          controller: secondController,
          decoration: InputDecoration(
              hintText: secondHint,
              hintStyle: TextStyle(color: Color.fromRGBO(201, 201, 201, 1.0))),
        ),
      )
    ]);
  }
}
