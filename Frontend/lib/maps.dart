import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_transit_app/DataFetcher.dart';
import 'package:flutter_transit_app/data/StationData.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:flutter_transit_app/screens/SubwayLinesScreen.dart';
import 'package:flutter_transit_app/widgets/panel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'entites/stations.dart';
import 'dart:convert';

import 'package:sliding_up_panel/sliding_up_panel.dart';

var logger = Logger();

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> stationlat = [];
  Set<Circle> circles = {};
  late List<dynamic> stationData;
  late String _mapStyle;
  static const Color buttonColor = Color.fromRGBO(73, 98, 110, 1);

/* The function below reads a .json file from the assets folder which contains
  Train station locations. Using the data from the .json file the google map
  is filled with markers and polylines based on the coordinats of each station */

  void createLine() {
    for (int i = 0; i < Lines_NorthBound.keys.length; i++) {
      print("Number of Lines: ${Lines_NorthBound.keys.length}");
      String line = Lines_NorthBound.keys.elementAt(i);
      //Build list of stations based on line
      stationData = DataFetcher().getStationInfo(line);
      for (int j = 0; j < stationData.length; j++) {
        circles.add(Circle(
          circleId: CircleId(stationData[j]['stop_id'].toString()),
          center: LatLng(stationData[j]['lat'], stationData[j]['lon']),
          radius: 20,
          fillColor: Colors.black,
          strokeColor: getBackgroundColor(line),
          zIndex: 1,
        ));

        // markers.add(
        //   Marker(
        //       markerId: MarkerId(stationData[j]['stop_id'].toString()),
        //       position: LatLng(stationData[j]['lat'], stationData[j]['lon']),
        //       infoWindow: InfoWindow(
        //         title: stationData[j]['name'],
        //       )),
        // );
        stationlat.add(LatLng(stationData[j]['lat'], stationData[j]['lon']));
      }

      // Add PolyLines based on stationlat list
      polylines.add(Polyline(
          polylineId: PolylineId(i.toString()),
          points: stationlat,
          width: 5,
          zIndex: i,
          color: getBackgroundColor(line),
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));

      stationlat = [];
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.733267535460655, -73.9879430702977),
    zoom: 15,
  );

  /* String _searchQuery = ''; // Store the search query entered by user */

  // on below line we have created list of markers

// Method to move the camera to the current location
  Future<void> _goToCurrentLocation() async {
    // Check if location permission is granted
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      // Request location permission
      final result = await Permission.locationWhenInUse.request();
      if (result.isDenied) {
        // User denied location permission, handle it here
        logger.w('Location permission denied by user');
        return;
      }
    }

    try {
      final GoogleMapController controller = await _controller.future;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ));
    } catch (e) {
      // Handle the exception here
      logger.e("Error occurred during moving to current location", e);
    }
  } //go to current location

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      print(_mapStyle);
    });
    createLine(); //Create lines a markers
    //Set timer for cards
    Globals.intial(timer: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ajust hight of sliding panel on screen
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.3;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
            polylines: polylines,
            circles: circles,
          ),
          SlidingUpPanel(
            body: Stack(
              children: [
                /* Train List Icon */
                Positioned(
                  top: 440,
                  left: 320,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubwayLinesScreen()),
                    ),
                    backgroundColor:
                        buttonColor, // Call _goToCurrentLocation() method
                    child: const Icon(Icons.train, size: 30.0),
                  ),
                ),
                /* Location Icon */
                Positioned(
                  top: 350,
                  left: 320,
                  child: FloatingActionButton(
                    onPressed: () => _goToCurrentLocation(),
                    backgroundColor:
                        buttonColor, // Call _goToCurrentLocation() method
                    child: const Icon(Icons.my_location, size: 30.0),
                  ),
                )
              ],
            ),
            color: const Color.fromRGBO(33, 32, 32, 1),
            parallaxEnabled: true,
            parallaxOffset: 1,
            minHeight: panelHeightClosed,
            maxHeight: panelHeightOpen,
            panelBuilder: (sc) => PanelWidget(controller: sc),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
        ],
      ),

      // //button to get to train list
      // bottomNavigationBar: Container(
      //   height: 50,
      //   color: Colors.black12,
      //   child: InkWell(
      //     onTap: () => Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const SubwayLinesScreen()),
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 8.0),
      //       child: Column(
      //         children: <Widget>[
      //           Icon(
      //             Icons.timeline,
      //             color: Theme.of(context).accentColor,
      //           ),
      //           const Text('Train List'),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
