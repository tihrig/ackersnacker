import 'package:ackersnacker/pages/BoardingPage/Sections/OnboardingText.dart';
import 'package:ackersnacker/pages/BoardingPage/Sections/UserTypeSelection.dart';
import 'package:ackersnacker/pages/OpenStreetMapPage.dart';
import 'package:flutter/material.dart';
import '../BauerPage.dart';
import '../MapPage.dart';
import '../../buttons/OnboardingButton.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
        children: <Widget>[
          // Logo
          Image.asset('assets/logo.png'),
          // Onboarding Text
          OnboardingText(
              mainTitle: "Ackersnacker",
              description:
                  "Biete Arbeit auf deinem Feld an oder  hilf den Bauernhöfen in deiner Nähe beim Ernten!",
              margin: 32.0),
          // User Selection
          Align(
            alignment: Alignment.bottomCenter,
            child: UserTypeSelection(
              hookText: "Du bist...",
              firstTitle: "Arbeitsuchende/r",
              secondTitle: "Landwirt",
              margin: 32.0,
              spacing: 16.0,
              navigateFirst: () {
                navigateToMapPage(context);
              },
              navigateSecond: () {
                navigateToBauerPage(context);
              },
            ),
          )
        ],
      ))),
    );
  }

  Future navigateToBauerPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BauerPage()));
  }

  Future navigateToMapPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
  }
}
