import 'dart:convert';
import 'dart:io';

import 'package:ackersnacker/buttons/NewJobButton.dart';
import 'package:ackersnacker/pages/BauernPage/BauernContactForm.dart';
import 'package:ackersnacker/pages/BauernPage/SingleTextField.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'BauernPage/SummaryContainer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../buttons/SubmitButton.dart';
import '../Utils/DateHelper.dart';
import '../networking/farmer.dart';

class BauerPage extends StatefulWidget {
  @override
  _BauerPageState createState() => _BauerPageState();
}

class _BauerPageState extends State<BauerPage> {
  // Validates the contact informations
  final _formKey = GlobalKey<FormState>();

  final String url = 'PLACE_YOUR_SERVER_URL_HERE';
  final String createFarmPost = "createFarm";
  final String createTaskPost = "createTask";
  final String contentType = 'application/json; charset=UTF-8';

  // Validates slots that can be created via new job
  final _slotKey = GlobalKey<FormState>();

  // Stores the created Job containers
  List<SummaryContainer> _containers = [];

  // Bauerncontact Form
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _farmNameController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _streetNumberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _plzController = TextEditingController();

  // Job Form
  TextEditingController _veggieFieldController = TextEditingController();
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _timeFieldController = TextEditingController();
  TextEditingController _seatsFieldController = TextEditingController();
  TextEditingController _durationFieldController = TextEditingController();
  TextEditingController _transportFieldController = TextEditingController();
  TextEditingController _salaryFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Jobauschreibungen erstellen'),
          backgroundColor: Color.fromRGBO(92, 212, 134, 1.0),
        ),
        body: ListView(
          children: <Widget>[
            Container(child: Text("Deine Kontaktinformationen", style: TextStyle(color: Color.fromRGBO(92, 212, 134, 1.0), fontWeight: FontWeight.bold, fontSize: 20),), margin: EdgeInsets.fromLTRB(42, 32, 42, 0),),
            
            // Contact Informations
            Container(
              margin: EdgeInsets.fromLTRB(42, 8, 42, 0),
              child: BauernContactForm(
                firstNameFieldController: _firstNameController,
                lastNameFieldController: _lastNameController,
                farmNameFieldController: _farmNameController,
                streetFieldController: _streetController,
                streetNumberFieldController: _streetNumberController,
                cityFieldController: _cityController,
                plzFieldController: _plzController,
                globalKey: _formKey,
              ),
            ),
            // "New Job" Button
            Align(
              alignment: Alignment.bottomLeft,
              child: NewJobButton(callback: () async {
                _displayDialog(context, "1");
              }),
            ),
            // List of created Jobs
            Column(
              children: _containers,
            ),
            // Show Submit button only when there are Job containers
            Opacity(
                child: Container(
                  margin: EdgeInsets.fromLTRB(38, 32, 38, 0),
                  child: SubmitButton(callback: () {
                    _sendToServer();
                  }),
                  width: 60,
                  height: 50,
                ),
                opacity: _containers.length > 0 ? 1.0 : 0.0)
          ],
        ));
  }

  Future<Address>_getGoogleAddress() async {
    final String query = _streetNumberController.text + " " +
        _streetController.text + ", " + _cityController.text;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    stderr.writeln("${first.featureName} : ${first.coordinates}");
    return first;
  }

  /**
   * Send all informations to the server. 
   */
  _sendToServer() async {
    String firstName = _firstNameController.text;
    String secondName = _lastNameController.text;
    String farmName = _farmNameController.text;
    String street = _streetController.text;
    int streetNumber = int.parse(_streetNumberController.text);
    String city = _cityController.text;
    String plz = _plzController.text;
    // TODO make this more error-proof
    Address address = await _getGoogleAddress();
    double latitude = address.coordinates.latitude;
    double longitude = address.coordinates.longitude;


    List<String> containerJsons = [];
    for (SummaryContainer container in _containers) {
      String containerJson = jsonEncode(container);
      containerJsons.add(containerJson); 
    }

    Farmer tempFarmer = Farmer(
      firstName: firstName, 
      secondName: secondName,
      farmName: farmName,
      street: street,
      streetNumber: streetNumber,
      city: city,
      place: plz,
      latitude: latitude,
      longitude: longitude
    );
    String farmerJson = jsonEncode(tempFarmer);

    // create a farmer on the server
    final http.Response response = await http.post(
      url + createFarmPost,
      headers: <String, String>{
        'Content-Type': contentType,
      },
      body: farmerJson,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      //Farmer responsFarmer = Farmer.fromJson(json.decode(response.body));
      // TODO Farmers are created correctly, but do not get sent back
    } else {
      throw Exception('Failed to create farmer!' + response.statusCode.toString());
    }

    // create a the tasks on the server
    // TODO tasks are not created correctly
    final http.Response taskResponse = await http.post(
      url + createTaskPost,
      headers: <String, String>{
        'Content-Type': contentType,
      },
      // i am not sure if lists of objects are directly converted with their items…
      body: jsonEncode(containerJsons),
    );

    if (taskResponse.statusCode == 201 || taskResponse.statusCode == 200) {
      String answer = json.decode(response.body);
      print(answer);
    } else {
      throw Exception('Failed to send the tasks!');
    }
  }

  // Shows a dialog with a form to create a job
  _displayDialog(BuildContext context, String code) async {
    return showDialog(
        context: context,
        builder: (context) {
          _textFieldController.text = "";
          _timeFieldController.text = "";
          return StatefulBuilder(
            builder: (context, setAlertState) {
              return AlertDialog(
                title: Text('Arbeitsbeschreibung'),
                content: Form(
                  key: _slotKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleTextField(
                        inputType: TextInputType.text,
                        hint: "Gemüseart",
                        mandatory: true,
                        controller: _veggieFieldController,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Datum notwendig.';
                                }
                                return null;
                              },
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2022, 1, 1),
                                    onConfirm: (date) {
                                  setAlertState(() {
                                    _textFieldController.text =
                                        date.day.toString() +
                                            ". " +
                                            DateHelper.getMonthName(date.month);
                                  });
                                }, locale: LocaleType.de);
                              },
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                  hintText: "Datum",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(201, 201, 201, 1.0))),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Startzeit notwendig.';
                                }
                                return null;
                              },
                              controller: _timeFieldController,
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    onConfirm: (date) {
                                  setAlertState(() {
                                    _timeFieldController.text =
                                        date.hour.toString() + " Uhr";
                                  });
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Startzeit",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(201, 201, 201, 1.0))),
                            ),
                          )
                        ],
                      ),
                      SingleTextField(
                        inputType: TextInputType.number,
                        hint: "Verfügbare Plätze",
                        mandatory: true,
                        controller: _seatsFieldController,
                      ),
                      SingleTextField(
                        hint: "Dauer (in Stunden)",
                        inputType: TextInputType.number,
                        mandatory: true,
                        controller: _durationFieldController,
                      ),
                      SingleTextField(
                        controller: _transportFieldController,
                        inputType: TextInputType.text,
                        hint: "Transport",
                        mandatory: false,
                      ),
                      SingleTextField(
                        controller: _salaryFieldController,
                        inputType: TextInputType.number,
                        hint: "Gehalt pro Stunde",
                        mandatory: true,
                      )
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
                      'Bestätigen',
                      style:
                          TextStyle(color: Color.fromRGBO(92, 212, 134, 1.0)),
                    ),
                    onPressed: () {
                      if (_slotKey.currentState.validate()) {
                        setState(() {
                          String id = Uuid().v1();
                          _containers.add(SummaryContainer(
                            id: id,
                            farmName: _farmNameController.text,
                            veggieTitle: _veggieFieldController.text,
                            date: _textFieldController.text,
                            time: _timeFieldController.text,
                            availableSlots: _seatsFieldController.text,
                            strain: _durationFieldController.text,
                            salary: _salaryFieldController.text,
                            transport: _transportFieldController.text,
                            onDelete: () {
                              setState(() {
                                _containers
                                    .removeWhere((item) => item.id == id);
                              });
                            },
                          ));
                          Navigator.of(context).pop();
                        });
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }
}
