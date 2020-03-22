import 'package:flutter/material.dart';

class NewJobButton extends StatelessWidget {
  final VoidCallback callback;

  const NewJobButton({this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(42, 60, 0, 0),
      color: Colors.transparent,
      width: 146,
      height: 60,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(26.0),
        ),
        onPressed: () {
          callback();
        },
        color: Color.fromRGBO(92, 212, 134, 1.0),
        child: Text(
          "+ Neuer Job",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
