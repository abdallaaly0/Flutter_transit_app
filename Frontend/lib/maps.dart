import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'entites/stations.dart';
import 'dart:convert';

var logger = Logger();

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<ALine> AtrainMarkers = [];
  Set<Marker> _markers = {};

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/Stations.json');
    final data = Stations.fromJson(jsonDecode(response));
    setState(() {
      AtrainMarkers = data.aLine;
    });

    // List of Markers Added on Google Map
    for (int i = 0; i < AtrainMarkers.length; i++) {
      _markers.add(
        Marker(
            markerId: MarkerId(AtrainMarkers[i].parentId),
            position: LatLng(AtrainMarkers[i].lat, AtrainMarkers[i].lon),
            infoWindow: InfoWindow(
              title: AtrainMarkers[i].name,
            )),
      );
    }
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
    super.initState();
    readJson(); //Read local Json file and setMarkers
    print(AtrainMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 90.0, // Adjust the bottom value as needed
              right: 0.0, // Adjust the left value as needed
              child: FloatingActionButton(
                onPressed: () =>
                    _goToCurrentLocation(), // Call _goToCurrentLocation() method
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ));
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