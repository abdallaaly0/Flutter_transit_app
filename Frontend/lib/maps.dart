import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_transit_app/service/DataFetcher.dart';
import 'package:flutter_transit_app/data/data.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:flutter_transit_app/screens/SubwayLinesScreen.dart';
import 'package:flutter_transit_app/widgets/panel_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'service/stateMangment.dart';

var logger = Logger();

class MapSample extends ConsumerStatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  ConsumerState<MapSample> createState() => MapSampleState();
}

class MapSampleState extends ConsumerState<MapSample> {
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> stationlat = [];
  Set<Circle> circles = {};
  late List<dynamic> stationData;
  late String _mapStyle;
  static const Color buttonColor = Color.fromRGBO(73, 98, 110, 1);
  static const Color panelColor = Color.fromRGBO(33, 32, 32, 1);
  LatLng cameraPostion = LatLng(0, 0);

/* The function below creates the polylines, markers, and circles.
    lineStations contains the stationID's for every station in a line.
    */
  void createLine() {
    //Set timer for cards
    for (int i = 0; i < lineStations.keys.length; i++) {
      print("Number of Lines: ${lineStations.keys.length}");
      String line = lineStations.keys.elementAt(i);
      //Build list of stations based on line
      stationData = DataFetcher().getStationInfo(line);
      for (int j = 0; j < stationData.length; j++) {
        // Add Circle and marker at every station location
        circles.add(Circle(
          circleId: CircleId(stationData[j]['stop_id'].toString()),
          center: LatLng(stationData[j]['lat'], stationData[j]['lon']),
          radius: 15,
          fillColor: Colors.black,
          strokeColor: getBackgroundColor(line),
          zIndex: 20,
        ));

        markers.add(
          Marker(
              alpha: 0,
              markerId: MarkerId(stationData[j]['stop_id'].toString()),
              position: LatLng(stationData[j]['lat'], stationData[j]['lon']),
              infoWindow: InfoWindow(
                title: stationData[j]['name'],
                anchor: const Offset(0.5, 1),
              )),
        );
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

// Method to get user location and move camera
  Future<void> _goToCurrentLocation(WidgetRef ref) async {
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
      // Get the current postion of user
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Get location");
      print("Ref: ${ref.watch(positionProvider.notifier).state}");

      /* Trigger panel rebuild based on users postion  */
      ref.watch(positionProvider.notifier).state =
          LatLng(position.latitude, position.longitude);
      //Move camera towards positon
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        ),
      ));
      setState(() {
        //Set marker on users postion
        markers.add(Marker(
          markerId: MarkerId(markers.length.toString()),
          infoWindow: const InfoWindow(title: "You are here"),
          position: LatLng(position.latitude, position.longitude),
        ));
      });
    } catch (e) {
      // Handle the exception here
      logger.e("Error occurred during moving to current location", e);
    }
  } //go to current location

  Future<void> getCameraStoppedPostion(WidgetRef ref) async {
    /* Get maps controller */
    print("CameraStoped postion $cameraPostion");
    /* Trigger panel rebuild based on users postion  */
    ref.watch(positionProvider.notifier).state =
        LatLng(cameraPostion.latitude, cameraPostion.longitude);
  }

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      print(_mapStyle);
    });
    createLine(); //Create lines a markers
    Globals.intial(timer: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ajust hight of sliding panel on screen
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.3;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.7;
    logger.i("Screen size, Size: ${MediaQuery.of(context).size}");
    return Scaffold(
        body: Stack(children: [
      Consumer(
        builder: (context, ref, child) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
            polylines: polylines,
            circles: circles,
            markers: markers,
            onCameraIdle: () {
              ref.watch(isCameraMoving.notifier).state = false;
              Timer(const Duration(seconds: 2), (() {
                if (ref.read(isCameraMoving)) {
                  print("Camera is still moving, ${ref.read(isCameraMoving)}");
                } else {
                  print("Camera Stopped moving, ${ref.read(isCameraMoving)}");
                  getCameraStoppedPostion(ref);
                }
              }));
            },
            onCameraMove: (position) {
              ref.watch(isCameraMoving.notifier).state = true;
              cameraPostion = position.target;
              print("Camera postion $cameraPostion");
            },
          );
        },
      ),
      //Dot on screen
      Center(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Color.fromRGBO(56, 112, 232, 1),
            shape: BoxShape.circle,
            border: Border.all(
              color: panelColor,
              width: 4.0,
            ),
          ),
        ),
      ),
      SlidingUpPanel(
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.64,
              left: MediaQuery.of(context).size.width * 0.101,
              right: MediaQuery.of(context).size.width * 0.101,
              child: Container(
                height: 50,
                width: 275,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(33, 32, 32, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(panelColor),
                      ),
                      onPressed: () {
                        // Handle button 1 press
                      },
                      child: const Text('Nearest'),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(panelColor)),
                      onPressed: () {
                        // Handle button 2 press
                      },
                      child: const Text('Saved'),
                    ),
                  ],
                ),
              ),
            ),
            /* Train List Icon */
            Positioned(
              top: MediaQuery.of(context).size.height * 0.537,
              left: MediaQuery.of(context).size.width * 0.84,
              child: Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                return FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    ref.watch(routeProvider.notifier).state = false;
                    ref.watch(stateTimer.notifier).state = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubwayLinesScreen()),
                    );
                  },
                  backgroundColor:
                      buttonColor, // Call _goToCurrentLocation() method
                  child: const Icon(Icons.train, size: 30.0),
                );
              }),
            ),
            /* Location Icon */
            Positioned(
                top: MediaQuery.of(context).size.height * 0.435,
                left: MediaQuery.of(context).size.width * 0.84,
                child: Consumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  return FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: () => _goToCurrentLocation(ref),
                    backgroundColor:
                        buttonColor, // Call _goToCurrentLocation() method
                    child: const Icon(Icons.my_location, size: 30.0),
                  );
                }))
          ],
        ),
        color: panelColor,
        parallaxEnabled: true,
        parallaxOffset: 1,
        minHeight: panelHeightClosed,
        maxHeight: panelHeightOpen,
        panelBuilder: (sc) =>
            PanelWidget(controller: sc, postion: _kGooglePlex.target),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
        // header: Padding(
        //   padding: const EdgeInsets.only(left: 180, right: 180),
        //   child: Column(
        //     children: [
        //       const SizedBox(height: 12),
        //       Center(
        //           child: Container(
        //         width: 30,
        //         height: 5,
        //         decoration: BoxDecoration(
        //           color: Colors.grey[300],
        //         ),
        //       )),
        //       const SizedBox(height: 26),
        //     ],
        //   ),
        // ),

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
      )
    ]));
  }
}
