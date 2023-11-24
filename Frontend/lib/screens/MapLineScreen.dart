import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_transit_app/screens/SubwayLinesScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../DataFetcher.dart';
import '../widgets/MapLinePanel.dart';

class MapLine extends StatefulWidget {
  final String line;
  final List<dynamic> stationData;
  final LatLng stationlocation;
  final String stop;
  final String stopID;

  const MapLine({
    Key? key,
    required this.line,
    required this.stationData,
    required this.stationlocation,
    required this.stop,
    required this.stopID,
  }) : super(key: key);

  @override
  State<MapLine> createState() => MapLineState();
}

class MapLineState extends State<MapLine> {
  late String line, mapstyle;
  late List<dynamic> stationData;
  Set<Marker> markers = {}, empty = {};
  Set<Polyline> polylines = {};
  List<LatLng> stationlat = [];
  Set<Circle> circles = {};
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

/* Create station line from */
  void createLine() {
    for (int i = 0; i < widget.stationData.length; i++) {
      circles.add(Circle(
        circleId: CircleId(widget.stationData[i]['stop_id'].toString()),
        center:
            LatLng(widget.stationData[i]['lat'], widget.stationData[i]['lon']),
        radius: 20,
        fillColor: Colors.black,
        strokeColor: getBackgroundColor(widget.line),
        zIndex: 1,
      ));

      markers.add(
        Marker(
            markerId: MarkerId(widget.stationData[i]['stop_id'].toString()),
            position: LatLng(
                widget.stationData[i]['lat'], widget.stationData[i]['lon']),
            infoWindow: InfoWindow(
              title: widget.stationData[i]['name'],
            )),
      );
      stationlat.add(
          LatLng(widget.stationData[i]['lat'], widget.stationData[i]['lon']));
    }
    // Add PolyLines based on stationlat list
    polylines.add(Polyline(
        polylineId: const PolylineId("1"),
        points: stationlat,
        width: 10,
        color: getBackgroundColor(widget.line),
        startCap: Cap.roundCap,
        endCap: Cap.buttCap));
  }

  @override
  void initState() {
    //Intlize var
    createLine();
    line = widget.line;
    stationData = widget.stationData;
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapstyle = string;
      print(mapstyle);
    });
    print(widget.stationlocation);
    print('intial Map Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final panelHeightClosed = MediaQuery.of(context).size.height * 0.3;
    final panelHeightOpen = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$line Train",
          style: TextStyle(color: getTextColor(widget.line)),
        ),
        backgroundColor: getBackgroundColor(widget.line),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.stationlocation, zoom: 16),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(mapstyle);
            },
            circles: circles,
            polylines: polylines,
            markers: markers,
          ),
          SlidingUpPanel(
            header: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Container(
                height: 200,
                width: 350,
              ),
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 340,
                  left: 15,
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: getBackgroundColor(widget.line),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          widget.line,
                          style: TextStyle(
                            fontSize: 45,
                            color: getTextColor(widget.line),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            color: const Color.fromRGBO(33, 32, 32, 1),
            parallaxEnabled: true,
            parallaxOffset: 1,
            minHeight: panelHeightClosed,
            maxHeight: panelHeightOpen,
            panelBuilder: (sc) => MapLinePanel(
              controller: sc,
              line: widget.line,
              station: widget.stop,
              stationID: widget.stopID,
            ),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30.0)),
          ),
        ],
      ),
    );
  }
}

// Color getBackgroundColor(String line) {
//   switch (line) {
//     case 'A':
//     case 'C':
//     case 'E':
//       return Colors.blue[900]!;
//     case '1':
//     case '2':
//     case '3':
//       return Colors.red;
//     case 'G':
//       return Color.fromARGB(255, 97, 234, 104);
//     case 'B':
//     case 'D':
//     case 'F':
//     case 'M':
//       return Colors.orange;
//     case 'J':
//     case 'Z':
//       return Colors.brown;
//     case 'L':
//     case 'S':
//       return Colors.grey;
//     case '4':
//     case '5':
//     case '6':
//       return Colors.green[900]!;
//     case '7':
//       return Colors.purple;
//     case 'N':
//     case 'Q':
//     case 'R':
//     case 'W':
//       return Color.fromARGB(255, 255, 230, 0);
//     default:
//       return Colors.blue;
//   }
// }
