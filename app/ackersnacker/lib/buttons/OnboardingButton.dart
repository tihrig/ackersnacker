import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const OnboardingButton({@required this.title, @required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        onPressed: () {
          callback();
        },
        color: Color.fromRGBO(92, 212, 134, 1.0),
        child: Text(
          this.title,
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
