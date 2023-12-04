import 'package:flutter/material.dart';
import 'package:flutter_transit_app/service/DataFetcher.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:flutter_transit_app/maps.dart';
import 'package:flutter_transit_app/screens/MapLineScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/data.dart';
import '../service/stateMangment.dart';

Globals Statetimer = Globals.intial(timer: false);
void setStateTimer() {
  Statetimer.Cardtimer = false;
}

Color getBackgroundColor(String line) {
  switch (line) {
    case 'A':
    case 'C':
    case 'E':
      return Colors.blue[900]!;
    case '1':
    case '2':
    case '3':
      return Colors.red;
    case 'G':
      return Color.fromARGB(255, 97, 234, 104);
    case 'B':
    case 'D':
    case 'F':
    case 'M':
      return Colors.orange;
    case 'J':
    case 'Z':
      return Colors.brown;
    case 'L':
    case 'S':
      return Colors.grey;
    case '4':
    case '5':
    case '6':
      return Colors.green[900]!;
    case '7':
      return Colors.purple;
    case 'N':
    case 'Q':
    case 'R':
    case 'W':
      return Color.fromARGB(255, 255, 230, 0);
    default:
      return Colors.blue;
  }
}

Color getTextColor(String line) {
  if (['N', 'Q', 'R', 'W'].contains(line)) {
    return Colors.black;
  }
  return Colors.white;
}

class SubwayLinesScreen extends StatelessWidget {
  const SubwayLinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    setStateTimer();
    print("State timer ${Statetimer.onMapLineScreen} ");
    return Scaffold(
      appBar: AppBar(
        leading: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return BackButton(
            color: Colors.white,
            onPressed: () {
              print("Trigger card rebuild");
              ref.watch(rebuildCardProvider.notifier).state++;
              ref.watch(routeProvider.notifier).state = true;
              Statetimer.Cardtimer = true;
              Navigator.maybePop(context);
            },
          );
        }),
        backgroundColor: const Color.fromRGBO(33, 32, 32, 1),
        title: const Text(
          'MTA Subway Lines',
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color.fromRGBO(33, 32, 32, 1),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapSample()),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: const <Widget>[
                Icon(
                  Icons.map,
                  color: Colors.white,
                ),
                Text('Map',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: lineStations.keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Choose the number of items per row
          crossAxisSpacing: 5.0, // Spacing between items horizontally
          mainAxisSpacing: 5.0, // Spacing between items vertically
          childAspectRatio: 1.0, // Aspect ratio of each grid item
        ),
        itemBuilder: (context, index) {
          final line = lineStations.keys.elementAt(index);
          print("Line: $index " + line);
          return Container(
            decoration: BoxDecoration(
              color: getBackgroundColor(line),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubwayStopsScreen(
                        line: line,
                        stationData: DataFetcher().getStationInfo(line),
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(line,
                      style: TextStyle(
                          fontSize: 50,
                          color: getTextColor(line),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubwayStopsScreen extends StatelessWidget {
  final String line;
  final List<dynamic> stationData;

  const SubwayStopsScreen(
      {super.key, required this.line, required this.stationData});

  @override
  Widget build(BuildContext context) {
    setStateTimer();
    print("State timer ${Statetimer.onMapLineScreen}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stations on the $line line',
          style: TextStyle(color: getTextColor(line)),
        ),
        backgroundColor: getBackgroundColor(line),
      ),
      body: ListView.builder(
        itemCount: stationData.length,
        itemBuilder: (context, index) {
          final stopID = stationData.elementAt(index)['stop_id'];
          final stop = stationData.elementAt(index)['name'];
          LatLng _stationLocation = LatLng(stationData.elementAt(index)['lat'],
              stationData.elementAt(index)['lon']);
          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapLine(
                              line: line,
                              stationData: stationData,
                              stationlocation: _stationLocation,
                              stop: stop,
                              stopID: stopID.toString(),
                            )),
                  ),
              child: ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 12.0, // Adjust width and height
                      height: 12.0,
                      margin: EdgeInsets.only(right: 8.0), // Add spacing
                      decoration: BoxDecoration(
                        color: getBackgroundColor(line),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        stop ?? 'Unknown stop',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
