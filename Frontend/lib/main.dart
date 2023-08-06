import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String _searchQuery = ''; // Store the search query entered by user
  final Set<Marker> _markers = {}; // Set to store markers on the map

  void _onMapLongPress(LatLng latLng) {
    setState(() {
      // Add a new marker to the set
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

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
            onLongPress: _onMapLongPress,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update the search query
                });
              },
              onSubmitted: (value) {
                // Perform geocoding when user submits the search query
                _searchLocation();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _goToCurrentLocation(), // Call _goToCurrentLocation() method
        label: const Text('Current Location'),
        icon: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _searchLocation() async {
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
  }
}
