import 'package:flutter/material.dart';
import '../pages/BauernPage/DoubleTextField.dart';
import '../pages/BauernPage/SingleTextField.dart';


class FarmInfoMap extends StatelessWidget {
  final double top;
  final double searchBarHeight;

  final String title;
  final String date;
  final String time;

  final String street;
  final String city;
  final String plz;

  final String vegetable;
  final String slots;
  final String salary;
  final String duration;
  final String transport;

  FarmInfoMap({@required this.top, this.searchBarHeight, @required this.title, @required this.date, @required this.time, @required this.street, @required this.city, @required this.plz, @required this.vegetable, @required this.slots, @required this.duration, @required this.transport, @required this.salary});

  // Validates slots that can be created via new job
  final _sendKey = GlobalKey<FormState>();

  // Usercontact Form
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _mailController = TextEditingController();

  bool didContact = false;

  @override
  Widget build(BuildContext context) {
    print(top);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1.1,
        margin: EdgeInsets.only(top: this.top),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(
                10.0, // horizontal, move right 10
                10.0, // vertical, move down 10
              ),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Stack(
          children: <Widget>[
            ListView(children: <Widget>[
              Container(
                child: Text(title ?? "-",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text((date ?? "-") + ", " + (time ?? "-"),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal)),
                    Text(" - " + (salary ?? "-") + "€ / Stunde",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.normal))
                  ],
                ),
                margin: EdgeInsets.fromLTRB(32, 8, 0, 32),
              ),
              Container(
                child: Text("Adresse".toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
              ),
              Container(
                child: Text((street ?? "-"),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              Container(
                child: Text((plz ?? "-") + (city ?? "-"),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              Container(
                child: Text("Arbeit".toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
              ),
              Container(
                child: Text((vegetable ?? "-") + "-Ernte",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              Container(
                child: Text((slots ?? "-") + " verfügbare Plätze",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              Container(
                child: Text((duration ?? "-") + " Stunden",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              Container(
                child: Text("Transport".toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
              ),
              Container(
                child: Text((transport ?? "-"),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
              ),
              didContact
                  ? Container(
                      child: Text("Velen Dank für deine Kontaktaufnahme!",
                          style: TextStyle(
                              color: Color.fromRGBO(92, 212, 134, 1.0),
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      margin: EdgeInsets.fromLTRB(32, 8, 32, 0),
                    )
                  : Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(92, 212, 134, 1.0),
                          borderRadius: new BorderRadius.circular(20.0)),
                      child: FlatButton(
                        child: Text("Kontaktieren",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                        onPressed: () async {
                          _displayDialog(context);
                        },
                      ),
                      margin: EdgeInsets.fromLTRB(32, 32, 32, 0),
                    )
            ]),
          ],
        ));
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setAlertState) {
              return AlertDialog(
                title: Text('Deine Kontaktdaten'),
                content: Form(
                  key: _sendKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      DoubleTextField(
                        firstController: _firstNameController,
                        secondController: _lastNameController,
                        firstHint: "Vorname",
                        secondHint: "Nachname",
                      ),
                      SingleTextField(
                        inputType: TextInputType.number,
                        hint: "Telefonnummer",
                        mandatory: false,
                        controller: _phoneController,
                      ),
                      SingleTextField(
                        hint: "E-Mail",
                        inputType: TextInputType.text,
                        mandatory: true,
                        controller: _mailController,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      'Abbrechen',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text(
                      'Abschicken',
                      style:
                          TextStyle(color: Color.fromRGBO(92, 212, 134, 1.0)),
                    ),
                    onPressed: () {
                      if (_sendKey.currentState.validate()) {
                        _sendToServer();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  /**
   * Send all informations to the server. 
   */
  _sendToServer() {
    String firstName = _firstNameController.text;
    String secondName = _lastNameController.text;
    String phone = _phoneController.text;
    String mail = _mailController.text;
  }
}
