import 'package:flutter/material.dart';
import '../../../buttons/OnboardingButton.dart';

class UserTypeSelection extends StatelessWidget {
  final String hookText;
  final String firstTitle;
  final String secondTitle;
  final double margin;
  final double spacing;
  final VoidCallback navigateFirst;
  final VoidCallback navigateSecond;

  const UserTypeSelection(
      {@required this.hookText,
      @required this.firstTitle,
      @required this.secondTitle,
      @required this.margin,
      @required this.spacing,
      @required this.navigateFirst,
      @required this.navigateSecond});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, margin, 0),
      child: Column(children: <Widget>[
        Container(
          child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                this.hookText.toUpperCase(),
                style: TextStyle(
                    color: Color.fromRGBO(92, 212, 134, 1.0),
                    fontFamily: 'Roboto',
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              )),
          padding: EdgeInsets.fromLTRB(0, 0, 0, spacing),
        ),
        Container(
          child: OnboardingButton(title: firstTitle, callback: navigateFirst),
          padding: EdgeInsets.fromLTRB(0, 0, 0, spacing + 10),
        ),
        Container(
          child: OnboardingButton(
            title: secondTitle,
            callback: navigateSecond,
          ),
          padding: EdgeInsets.fromLTRB(0, 0, 0, spacing),
        ),
      ]),
    );
  }
}
