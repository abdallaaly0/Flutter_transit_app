import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_transit_app/DataFetcher.dart';
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
  List<Line> aTrainMarkers = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<Line> oneTrainMarkers = [];
  late String _mapStyle;

/* The function below reads a .json file from the assets folder which contains
  Train station locations. Using the data from the .json file the google map
  is filled with markers and polylines based on the coordinats of each station */

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/Stations.json');
    final data = Stations.fromJson(jsonDecode(response));
    setState(() {
      //Data from .json file
      aTrainMarkers = data.lineA;
    });
    List<LatLng> aRoute = [];
    // List of Markers Added on Google Map
    for (int i = 0; i < aTrainMarkers.length; i++) {
      markers.add(
        Marker(
            markerId: MarkerId(aTrainMarkers[i].parentStation),
            position: LatLng(aTrainMarkers[i].lat, aTrainMarkers[i].lon),
            infoWindow: InfoWindow(
              title: aTrainMarkers[i].name,
            )),
      );
      //Add coordaintes of stations
      aRoute.add(LatLng(aTrainMarkers[i].lat, aTrainMarkers[i].lon));
    }

    //Add Polylines
    polylines.add(Polyline(
      polylineId: const PolylineId("1"),
      points: aRoute,
      width: 5,
    ));
  } //LoadsJson file

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.67043, -73.82294),
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
    readJson(); //Read local Json file and setMarkers
    print(aTrainMarkers);
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
            markers: markers,
            polylines: polylines,
          ),
          Padding(
            // Adjust the left value as needed
            padding: const EdgeInsets.only(top: 100.0, left: 10.0),
            child: FloatingActionButton(
              onPressed: () =>
                  _goToCurrentLocation(), // Call _goToCurrentLocation() method
              child: const Icon(Icons.my_location),
            ),
          ),
          SlidingUpPanel(
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            minHeight: panelHeightClosed,
            maxHeight: panelHeightOpen,
            panelBuilder: (sc) => PanelWidget(controller: sc),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
        ],
      ),
      //button to get to train list
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubwayLinesScreen()),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
                ),
                Text('Train List'),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*   Future<void> _searchLocation() async {
    if (_searchQuery.isNotEmpty) {
      try {
        List<Location> locations =
            await locationFromAddress(_searchQuery); // Perform geocoding
        if (locations.isNotEmpty) {
          Location firstLocation = locations.first;
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(firstLocation.latitude, firstLocation.longitude),
              zoom: 20.0,
            ),
          ));
        }
      } catch (e) {
        // Handle the exception here
        logger.e("Error occurred during geocoding", e);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('Location not found'),
                content:
                    const Text('No results found for the entered address.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]);
          });
    }
  } */
}
