import 'dart:async';
import 'dart:ui' as ui;

import 'package:ackersnacker/widgets/FarmInfoMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocation/geolocation.dart';
import 'package:latlong/latlong.dart';

LatLng _kBremen = LatLng(53.073635, 8.806422);

class OpenStreetMapPage extends StatefulWidget {
  @override
  State<OpenStreetMapPage> createState() => OpenStreetMapPageState();
}

class OpenStreetMapPageState extends State<OpenStreetMapPage> {
  MapController _controller = MapController();
  LatLng currentPosition = _kBremen;
  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  //MarkerId selectedMarker;
  int _markerIdCounter = 1;
  double top = 0.0;
  double initialTop = 0.0;

  @override
  Widget build(BuildContext context) {
    final baseTop = MediaQuery.of(context).size.height * 0.8;


    return new Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: new MapOptions(
              center: new LatLng(51.5, -0.09),
              zoom: 13.0,
            ),
            layers: [
              new TileLayerOptions(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: new LatLng(51.5, -0.09),
                    builder: (ctx) =>
                    new Container(
                      child: new FlutterLogo(),
                    ),
                  ),
                ],
              ),
            ],
            mapController: _controller,
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                if(top != 0.2) {
                  top = 0.2;
                } else {
                  top = baseTop;
                }
              });
            },
            onPanUpdate: (DragUpdateDetails details) {
              final double scrollPos = details.globalPosition.dy;
              setState(() {
                top = scrollPos;
              });
            },
            child: FarmInfoMap(
              top: this.top == 0.0 ? baseTop : this.top,
            ),
          ),
        ],
      ),
    );
  }

  /*
  void _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    LatLng currentLocation = await _setStartingPosition();
    await _createMarkers(currentLocation.latitude, currentLocation.longitude);
  }

  Future<LatLng> _setStartingPosition() async {
    final GoogleMapController controller = await _controller.future;
    LocationResult result = await Geolocation.lastKnownLocation();
    Location loc = result.location;
    final CameraPosition _currentCameraPosition = CameraPosition(
      target: LatLng(loc.latitude, loc.longitude),
      zoom: 11,
    );
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_currentCameraPosition));
    return LatLng(loc.latitude, loc.longitude);
  }

  ///
  /// Fetch markers near current location and display them on map
  void _createMarkers(double pLatitude, double pLongitude) async {
    _setStartingPosition();
    // TODO: get values from data base
    _add(pLatitude + 0.03, pLongitude + 0.03, "Feld 1", "Möhren", "Carrot");
    _add(pLatitude - 0.03, pLongitude - 0.03, "Feld 2", "Spargel", "Asparagus");
  }



  Future<BitmapDescriptor> _createMarkerIconFromSvg(BuildContext context, String assetName) async {
    // Read SVG file as String
    String svgString = await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);

    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    double width = 32 * devicePixelRatio; // where 32 is your SVG's original width
    double height = 32 * devicePixelRatio; // same thing

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
    return BitmapDescriptor.fromAssetImage(
        imageConfiguration, assetName);
  }

  ///
  /// Defines Assets for each possible type of harvest
  Future<BitmapDescriptor> _getIconForMarkerType(String type) async{
    if (type == "Carrot") {
      return await _createMarkerIconFromSvg(context, 'assets/Karotte.svg');
    } else if (type == "Leek") {
      // TODO: this is much too large, was just a test, do not use
      return await _createMarkerIconFromPng('assets/logo.png');
    }
    // no fitting type -> use default marker
    return BitmapDescriptor.defaultMarker;
  }

  ///Adds markers at given latitude and longitude, with given title and
  ///description.
  /// pType gives the type of harvest done on the field and is used to
  /// set a fitting item. Make sure to include each possible pType in
  /// _getIconForMarkerType()
  void _add(double latitude, double longitude, String pTitle,
      String pDescription, String pType) async {

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    // TODO use different icons based on activity/ number of people needed
    BitmapDescriptor markerIcon = await _getIconForMarkerType(pType);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(title: pTitle, snippet: pDescription),
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
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        // TODO: this currently replaces with default green marker,
        // with finished assets it should ideally replace with differently
        // colored version of same icon
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        // TODO uncomment this once fitting replacement markers are implemented
        //markers[markerId] = newMarker;
      });
    }
  }

   */
}