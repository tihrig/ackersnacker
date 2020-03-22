import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback callback;

  const SubmitButton({@required this.callback});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Color.fromRGBO(92, 212, 134, 1.0))),
      child: Text(
        "Submit",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromRGBO(92, 212, 134, 1.0)),
      ),
      onPressed: callback,
    );
  }
}
