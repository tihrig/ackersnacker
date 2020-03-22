import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:ackersnacker/widgets/FarmInfoMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocation/geolocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../networking/farmer.dart';
import 'BauernPage/SummaryContainer.dart';

const LatLng _kBremen = LatLng(53.073635, 8.806422);
// everything within latitude /longitude tolerance is displayed
// TODO temporarily set to 1000 because Android Studio emulator does not save
// Bremen as location
const double _kLatTolerance = 1000;
const double _kLonTolerance = 1000;

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  final String url = 'PLACE_YOUR_SERVER_URL_HERE';
  final String getFarmsGet = "getFarms";
  final String getTasksGet = "getTasks";
  final String contentType = 'application/json; charset=UTF-8';

  Completer<GoogleMapController> _controller = Completer();
  LatLng currentPosition = _kBremen;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, SummaryContainer> markersToTask = <MarkerId, SummaryContainer>{};
  Map<MarkerId, Farmer> markersToFarmer = <MarkerId, Farmer>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;
  double top = 0.0;
  double baseTop = 0.0;

  String markerTitle;
  String markerDate;
  String markerTime;
  String markerSalary;
  String markerStreet;
  String markerCity;
  String markerPLZ;
  String markerVegetable;
  String markerSeats;
  String markerDuration;
  String markerTransport;

  @override
  Widget build(BuildContext context) {
    baseTop = MediaQuery.of(context).size.height * 1.0;

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(92, 212, 134, 1.0),
        title: Text("Finde Ernteausschreibungen"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: currentPosition, zoom: 10),
            markers: Set<Marker>.of(markers.values),
            onMapCreated: _onMapCreated,
            onTap: (test) {
              setState(() {
                top = 800;
              });
            },
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                  top = baseTop;
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              final double scrollPos = details.globalPosition.dy;
              setState(() {
                top = scrollPos;
              });
            },
            child: FarmInfoMap(
              top: this.top == 0.0 ? baseTop : this.top, title: markerTitle, date: markerDate, time: markerTime, street: markerStreet, city: markerCity, plz: markerPLZ, duration: markerDuration, slots: markerSeats, vegetable: markerVegetable, transport: markerTransport, salary: markerSalary,
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    LatLng currentLocation = await _setStartingPosition();
    _createMarkers(currentLocation.latitude, currentLocation.longitude);
  }

  Future<LatLng> _setStartingPosition() async {
    final GoogleMapController controller = await _controller.future;
    LocationResult result = null;
    result = await Geolocation.lastKnownLocation();
    double latitude;
    double longitude;
    try {
      Location loc = result.location;
      latitude = loc.latitude;
      longitude = loc.longitude;
    } catch (e) {
      // use Bremen as location by default
      latitude = _kBremen.latitude;
      longitude = _kBremen.longitude;
    }
    final CameraPosition _currentCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 11,
    );
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_currentCameraPosition));
    return LatLng(latitude, longitude);
  }

  ///
  /// Fetch markers near current location and display them on map
  void _createMarkers(double pLatitude, double pLongitude) async {
    _setStartingPosition();
    //_add(pLatitude + 0.03, pLongitude + 0.03, "Feld 1", "Möhren", "Carrot");
    //_add(pLatitude + 0.03, pLongitude + 0.03, "Feld 2", "Spargel", "Carrot");
    _getFarmDataFromDB(pLatitude, pLongitude);
  }

  ///
  /// Fetch data for farms near given latitude and longitude from database
  /// Add markers for each task in the vicinity
  ///
  void _getFarmDataFromDB(double pLatitude, double pLongitude) async {

    final responseTasks = await http.get(url + getTasksGet);
    List<SummaryContainer> containers = List<SummaryContainer>();
    if (responseTasks.statusCode == 200) {
      var taskJsonObjs = jsonDecode(responseTasks.body) as List;
      containers.addAll(taskJsonObjs.map((taskJson) => SummaryContainer.fromJson(taskJson)).toList());
    } else {
      throw Exception('Failed to load tasks…');
    }
    final responseFarmers = await http.get(url + getFarmsGet);
    List<Farmer> farmers = List<Farmer>();
    if (responseFarmers.statusCode == 200) {
      var farmerJsonObjs = jsonDecode(responseFarmers.body) as List;
      farmers.addAll(farmerJsonObjs.map((farmerJson) => Farmer.fromJson(farmerJson)).toList());
    } else {
      throw Exception('Failed to load farmers…');
    }
    //iterate over all farms
    // value of "farms" should be a map specifying one farm
    farmers.forEach((farmer) {
      double farmLat = farmer.latitude;
      double farmLon = farmer.longitude;
      // filter near farms
      if ((farmLat - pLatitude).abs() < _kLatTolerance &&
          (farmLon - pLongitude).abs() < _kLonTolerance) {
        containers.forEach((task) {
          if (farmer.farmName == task.farmName) {
            // info page popup when marker is clicked
            _addMarker(farmLat, farmLon, farmer, task);
          }
        });
      }
    });
  }

  //TODO: currently just one task
  Map<String, dynamic> _mockDBFarms() {
    Map<String, dynamic> farms = {
      "farmX": {
        "farm": "WeddingRüben",
        "farmer": "Ka Rotte",
        "email": "weddingrueben@gmail.de",
        "phone": "02080/8627",
        "street": "Rübenweg 5",
        "city": "Vehnemoor",
        "lat": "53.083114",
        "lon": "7.96"
      },
      "farmY": {
        "farm": "Gutes Land",
        "farmer": "To Mate",
        "email": "tomatefarm@gmail.de",
        "phone": "0178/274833",
        "street": "Tomatenweg 5",
        "city": "Vehnemoor",
        "lat": "53.053114",
        "lon": "8.04"
      },
      "farmZ": {
        "farm": "Gemüseplantage 23",
        "farmer": "Richard",
        "email": "gemüseplantage25@gmail.de",
        "phone": "0372/32882",
        "street": "Gemüsestraße 1",
        "city": "Vehnemoor",
        "lat": "53.01",
        "lon": "7.958"
      }
    };
    return farms;
  }

  //TODO: currently just one task
  Map<String, dynamic> _mockDBTasks() {
    Map<String, dynamic> tasks = {
      "taskX": {
        "farm": "WeddingRüben",
        "good": "Spargel",
        "spots": 4,
        "date": "23.03.2020",
        "burden": "schwer",
        "transport": "Abholdienst"
      },
      "taskY": {
        "farm": "WeddingRüben",
        "good": "Carrot",
        "spots": 4,
        "date": "23.03.2020",
        "burden": "schwer",
        "transport": "Abholdienst"
      },
      "taskX": {
        "farm": "Gutes Land",
        "good": "Tomate",
        "spots": 3,
        "date": "23.05.2020",
        "burden": "leicht",
        "transport": "Abholdienst"
      },
      "taskM": {
        "farm": "Gemüseplantage 23",
        "good": "Gurken",
        "spots": 2,
        "date": "12.05.2020",
        "burden": "leicht",
        "transport": "Abholdienst"
      }
    };
    return tasks;
  }

  Future<BitmapDescriptor> _createMarkerIconFromSvg(
      BuildContext context, String assetName, int scale) async {
    // Read SVG file as String
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width =
        24 * devicePixelRatio + (scale * 3); // where 32 is your SVG's original width
    double height = 24 * devicePixelRatio + (scale * 3); // same thing

    // Convert to ui.Picture
    ui.Picture picture = svgDrawableRoot.toPicture(size: Size(width, height));

    // Convert to ui.Image. toImage() takes width and height as parameters
    // you need to find the best size to suit your needs and take into account the
    // screen DPI
    ui.Image image = await picture.toImage(width.round(), height.round());
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createMarkerIconFromPng(String assetName) async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    return BitmapDescriptor.fromAssetImage(imageConfiguration, assetName);
  }

  ///
  /// Defines Assets for each possible type of harvest
  Future<BitmapDescriptor> _getIconForMarkerType(String availableSlots) async {
      return await _createMarkerIconFromSvg(context, 'assets/Karotte.svg', int.parse(availableSlots));
  }

  ///Adds markers at given latitude and longitude, with given title and
  ///description.
  /// pType gives the type of harvest done on the field and is used to
  /// set a fitting item. Make sure to include each possible pType in
  /// _getIconForMarkerType()
  /// also just add the farm and task fitting to the marker
  void _addMarker(double latitude, double longitude, Farmer farmer, SummaryContainer container) async {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    markersToFarmer[markerId] = farmer;
    markersToTask[markerId] = container;

    // TODO use different icons based on activity/ number of people needed
    BitmapDescriptor markerIcon = await _getIconForMarkerType(container.availableSlots);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      icon: markerIcon,
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    Farmer farmer = markersToFarmer[markerId];
    SummaryContainer summaryContainer = markersToTask[markerId];
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {

        // TODO: Get the right job by the markers id.
        markerTitle = farmer.farmName;
        markerDate = summaryContainer.date;
        markerTime = summaryContainer.time;
        markerSalary = summaryContainer.salary;
        markerStreet = farmer.street;
        markerCity = farmer.city;
        markerPLZ = farmer.place;
        markerVegetable = summaryContainer.veggieTitle;
        markerSeats = summaryContainer.availableSlots;
        markerDuration = summaryContainer.time;
        markerTransport = summaryContainer.transport;
        top = 0.7;
        if (markers.containsKey(selectedMarker)) {

          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
      });
    }
  }
}
