import 'package:flutter/material.dart';
import 'DoubleTextField.dart';

class BauernContactForm extends StatelessWidget {
  final GlobalKey<FormState> globalKey;

  final TextEditingController firstNameFieldController;
  final TextEditingController lastNameFieldController;
  final TextEditingController farmNameFieldController;
  final TextEditingController streetFieldController;
  final TextEditingController streetNumberFieldController;
  final TextEditingController cityFieldController;
  final TextEditingController plzFieldController;

  const BauernContactForm(
      {@required this.globalKey,
      @required this.firstNameFieldController,
      @required this.lastNameFieldController,
      @required this.farmNameFieldController,
      @required this.streetFieldController,
      @required this.streetNumberFieldController,
      @required this.cityFieldController,
      @required this.plzFieldController});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalKey,
      child: Column(
        children: <Widget>[
          DoubleTextField(
            firstHint: "Vorname",
            secondHint: "Nachname",
            firstController: firstNameFieldController,
            secondController: lastNameFieldController,
          ),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: farmNameFieldController,
                decoration: InputDecoration(
                    hintText: "Bauernhofname",
                    hintStyle:
                        TextStyle(color: Color.fromRGBO(201, 201, 201, 1.0))),
              ),
            )
          ]),
          DoubleTextField(
            firstController: streetFieldController,
            secondController: streetNumberFieldController,
            firstHint: "Straße",
            secondHint: "Nummer",
          ),
          DoubleTextField(
            firstController: cityFieldController,
            secondController: plzFieldController,
            firstHint: "Ort",
            secondHint: "PLZ",
          )
        ],
      ),
    );
  }
}
