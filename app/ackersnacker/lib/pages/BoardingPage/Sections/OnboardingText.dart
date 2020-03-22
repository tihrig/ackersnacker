import 'package:flutter/material.dart';

class OnboardingText extends StatelessWidget {
  final String mainTitle;
  final String description;
  final double margin;

  const OnboardingText(
      {@required this.mainTitle,
      @required this.description,
      @required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(margin, 0, margin, 0),
        child: Column(
          children: <Widget>[
            Align(
              child: Text(
                this.mainTitle.toUpperCase(),
                style: TextStyle(
                    color: Color.fromRGBO(92, 212, 134, 1.0),
                    fontFamily: 'Raleway',
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.bottomLeft,
            ),
            Text(
              this.description,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Raleway',
                fontSize: 18.0,
              ),
            )
          ],
        ));
  }
}
