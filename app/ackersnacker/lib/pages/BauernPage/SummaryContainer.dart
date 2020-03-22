import 'package:flutter/material.dart';

class SummaryContainer extends StatelessWidget {
  static const String KEY_ID = 'id';
  static const String KEY_FARM_NAME = 'farmName';
  static const String KEY_VEGGIE_TITLE = 'veggieTitle';
  static const String KEY_DATE = 'date';
  static const String KEY_TIME = 'time';
  static const String KEY_AVAILABLE_SLOTS = 'availableSlots';
  static const String KEY_STRAIN = 'strain';
  static const String KEY_TRANSPORT = 'transport';
  static const String KEY_SALARY = 'salary';

  final String id;
  final String farmName;
  final String veggieTitle;
  final String date;
  final String time;
  final String availableSlots;
  final String strain;
  final String transport;
  final String salary;
  final VoidCallback onDelete;

  SummaryContainer(
      {@required this.id,
      @required this.farmName,
      @required this.veggieTitle,
      @required this.date,
      @required this.time,
      @required this.availableSlots,
      @required this.strain,
      @required this.transport,
      @required this.salary,
      @required this.onDelete});

  factory SummaryContainer.fromJson(Map<String, dynamic> json) {
    return SummaryContainer(
        id: json[KEY_ID],
        farmName: json[KEY_FARM_NAME],
        veggieTitle: json[KEY_VEGGIE_TITLE],
        date: json[KEY_DATE],
        time: json[KEY_TIME],
        availableSlots: json[KEY_AVAILABLE_SLOTS],
        strain: json[KEY_STRAIN],
        salary: json[KEY_SALARY],
        transport: json[KEY_TRANSPORT],
        onDelete: () {});
  }

  Map<String, dynamic> toJson() => {
        KEY_ID: id,
        KEY_FARM_NAME: farmName,
        KEY_VEGGIE_TITLE: veggieTitle,
        KEY_DATE: date,
        KEY_TIME: time,
        KEY_AVAILABLE_SLOTS: availableSlots,
        KEY_STRAIN: strain,
        KEY_TRANSPORT: transport
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(92, 212, 134, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      margin: EdgeInsets.fromLTRB(42, 32, 42, 0),
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(veggieTitle,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  onPressed: () {
                    onDelete();
                  },
                )
              ]),
          Container(
            child: Row(
              children: <Widget>[
                Text(date + ", ",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                Text(time, style: TextStyle(fontSize: 18, color: Colors.white))
              ],
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Text("$availableSlots verfügbare Plätze",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Text(
                  strain + " Stunden",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  child: Text(transport,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white)),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 8))),
          Align(
              alignment: Alignment.topLeft,
              child: Text(salary + "€ / Stunde",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)))
        ],
      ),
    );
  }
}
