import 'dart:ffi';

import 'package:flutter/material.dart';

class Farmer {

  static const String KEY_FIRST_NAME = 'firstName';
  static const String KEY_SECOND_NAME = 'secondName';
  static const String KEY_FARM_NAME = 'farmName';
  static const String KEY_STREET = 'street';
  static const String KEY_STREET_NUMBER = 'streetNumber';
  static const String KEY_CITY = 'city';
  static const String KEY_PLACE = 'place';
  static const String KEY_LONGITUDE = 'longitude';
  static const String KEY_LATITUDE = 'latitude';

  final String firstName;
  final String secondName;
  final String farmName;
  final String street;
  final int streetNumber;
  final String city;
  final String place;
  final double longitude;
  final double latitude;

  Farmer({
    this.firstName,
    this.secondName,
    this.farmName,
    this.street,
    this.streetNumber,
    this.city,
    this.place,
    this.longitude,
    this.latitude
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      firstName: json[KEY_FIRST_NAME],
      secondName: json[KEY_SECOND_NAME],
      farmName: json[KEY_FARM_NAME],
      street: json[KEY_STREET],
      streetNumber: json[KEY_STREET_NUMBER],
      city: json[KEY_CITY],
      place: json[KEY_PLACE],
      longitude: json[KEY_LONGITUDE],
      latitude: json[KEY_LATITUDE]
    );
  }

  Map<String, dynamic> toJson() => {
      KEY_FIRST_NAME: firstName,
      KEY_SECOND_NAME: secondName,
      KEY_FARM_NAME: farmName,
      KEY_STREET: street,
      KEY_STREET_NUMBER: streetNumber,
      KEY_CITY: city,
      KEY_PLACE: place,
      KEY_LONGITUDE: longitude,
      KEY_LATITUDE: latitude
  };

  bool operator ==(o) => o is Farmer 
    && firstName == o.firstName 
    && secondName == o.secondName
    && farmName == o.farmName
    && street == o.street
    && streetNumber == o.streetNumber
    && city == o.city
    && place == o.place
    && longitude == o.longitude
    && latitude == o.latitude;
    
  int get hashCode => hashValues(firstName, secondName, farmName, street, streetNumber, city, place, longitude, latitude);
}