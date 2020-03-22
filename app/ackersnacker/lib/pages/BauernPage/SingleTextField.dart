import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SingleTextField extends StatelessWidget {
  final String hint;
  final TextInputType inputType;
  final bool mandatory;
  final TextEditingController controller;

  const SingleTextField(
      {@required this.hint,
      @required this.inputType,
      @required this.mandatory,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (mandatory) {
              if (value.isEmpty) {
                return 'Information wird benötigt.';
              }
              return null;
            }
            return null;
          },
          keyboardType: inputType,
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Color.fromRGBO(201, 201, 201, 1.0))),
        ),
      )
    ]);
  }
}
