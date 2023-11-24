import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_transit_app/DataFetcher.dart';
import 'package:flutter_transit_app/PanelViews/homepanel.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:flutter_transit_app/screens/SubwayLinesScreen.dart';

class MapLinePanel extends StatefulWidget {
  final ScrollController controller;
  final String line;
  final String station;
  final String stationID;

  const MapLinePanel(
      {super.key,
      required this.controller,
      required this.line,
      required this.station,
      required this.stationID});

  @override
  State<MapLinePanel> createState() => MapLinePanelState();
}

class MapLinePanelState extends State<MapLinePanel> {
  late Color dot;
  bool left = true;
  bool right = false;
  late List<dynamic> arrivaltimesNorth = ["", "", ""];
  late List<dynamic> arrivaltimesSouth = ["", "", ""];
  late String northDirection;
  late String southDirection;
  Timer? timer;
  Globals Statetimer = Globals.intial(timer: false);
  Duration callrate = const Duration(seconds: 30);

  //Get Color of dot
  Color dotColor(bool left) {
    if (left) {
      return getBackgroundColor(widget.line);
    } else {
      return getBackgroundColor(widget.line).withOpacity(0.3);
    }
  }

  /* Set Color dot postion  */
  void onSwip(int i) {
    switch (i) {
      case 0:
        setState(() {
          left = true;
          right = false;
        });
        break;
      case 1:
        setState(() {
          left = false;
          right = true;
        });
        break;
      default:
    }
  }

  /* Get a list of train times from server for both directions of travel*/
  Future<void> initTimes() async {
    List<dynamic> dataN = await DataFetcher()
        .getTrainTimeList("${widget.line}${widget.stationID}N");
    print("data North: $dataN");
    List<dynamic> dataS = await DataFetcher()
        .getTrainTimeList("${widget.line}${widget.stationID}S");
    print("data South: $dataS");
    setState(() {
      arrivaltimesNorth = dataN;
      arrivaltimesSouth = dataS;
    });
  }

  /* Fromat and set times in proper postions */
  String timeText(int i, String route) {
    String time = "";
    switch (route) {
      /* NorthBound times */
      case 'N':
        /* If we don't know time at index i  */
        if (3 < i) {
          return time = "";
        } else {
          return "${arrivaltimesNorth[i]} mins";
        }
      /* SouthBound times */
      case 'S':
        if (3 < i) {
          return time = "";
        } else {
          return "${arrivaltimesSouth[i]} mins";
        }
      default:
        return time;
    }
  }

  /* Update Train Time */
  void onUpdate() async {
    if (Statetimer.getonMapLineScreen()) {
      print("StateTimer: ${Statetimer.getonMapLineScreen()}");
      List<dynamic> dataN = await DataFetcher()
          .getTrainTimeList("${widget.line}${widget.stationID}N");
      print("data North: $dataN");
      List<dynamic> dataS = await DataFetcher()
          .getTrainTimeList("${widget.line}${widget.stationID}S");
      print("data South: $dataS");
      setState(() {
        arrivaltimesNorth = dataN;
        arrivaltimesSouth = dataS;
      });
    } else {
      print(
          "State Timer: ${Statetimer.getonMapLineScreen()}, Turn off state timer");
      timer!.cancel();
    }
  }

  @override
  void initState() {
    Statetimer.setonMapLineScreen(true);
    print(Statetimer.getonMapLineScreen());
    //Get Train times
    initTimes();
    // Show train directions
    setTrainDirection(widget.line);
    super.initState();
    timer = Timer.periodic(callrate, (Timer t) => onUpdate());
  }

  @override
  void dispose() {
    print("dispose");
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 12),

        // Grey thing at top of sliding panel
        Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
        const SizedBox(height: 26),

        // Transition Dots
        Row(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor(left),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor(right),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        //Size of card widget
        SizedBox(
          height: 250,
          child: PageView(
            controller: PageController(viewportFraction: 1),
            onPageChanged: (int pageindex) {
              print("Page index: $pageindex");
              onSwip(pageindex);
            },
            children: [
              /* First Card */
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: SizedBox(
                      width: 350,
                      child: Card(
                        color: const Color.fromRGBO(80, 82, 80, 1),
                        child: Stack(
                          children: [
                            /* First Card */
                            /* Header of Card */
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Text(
                                  widget.station,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            /* Direction text */
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 10, 0),
                                child: Text(
                                  northDirection,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            //First Divider
                            const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            ),

                            // ListView.builder(
                            //     physics: null,
                            //     itemCount: 2,
                            //     itemBuilder: (context, index) {
                            //       return Row(
                            //         children: [

                            //         ],
                            //       );
                            //     }),

                            // 1st Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 80, 0, 0),
                              child: Text(
                                timeText(0, "N"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // 2nd Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 130, 0, 0),
                              child: Text(
                                timeText(1, "N"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // 3rd Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 180, 0, 0),
                              child: Text(
                                timeText(2, "N"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            //Dividers
                            const Padding(
                              padding: EdgeInsets.only(top: 110),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            ),

                            //Dividers
                            const Padding(
                              padding: EdgeInsets.only(top: 160),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        // elevation: 10.0,
                        // shadowColor: getBackgroundColor(line),
                      ))),

              /* Second Card */
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: SizedBox(
                      width: 350,
                      child: Card(
                        color: const Color.fromRGBO(80, 82, 80, 1),
                        child: Stack(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text(
                                  widget.station,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 0, 0),
                                child: Text(
                                  southDirection,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),

                            // 1st Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 80, 0, 0),
                              child: Text(
                                timeText(0, "S"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // 2nd Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 130, 0, 0),
                              child: Text(
                                timeText(1, "S"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            // 3rd Time
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 180, 0, 0),
                              child: Text(
                                timeText(2, "S"),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),

                            //Dividers
                            const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            ),

                            //Dividers
                            const Padding(
                              padding: EdgeInsets.only(top: 110),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            ),

                            //Dividers
                            const Padding(
                              padding: EdgeInsets.only(top: 160),
                              child: Divider(
                                thickness: 1,
                                indent: 5,
                                endIndent: 5,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                        // elevation: 10.0,
                        // shadowColor: getBackgroundColor(line),
                      ))),
            ],
          ),
        )
      ],
    );
  }

  //Get train Directon based on the Line
  void setTrainDirection(String line) {
    switch (line) {
      case "A":
        northDirection = "Brooklyn and Manhattan";
        southDirection = "Queens";
        break;
      case "B":
        northDirection = "Manhattan (145 st)";
        southDirection = "Brooklyn (Brigthon Beach)";
        break;
      case "C":
        northDirection = "Manhattan (168 st)";
        southDirection = "Brooklyn (Euclid Av)";
        break;
      case "D":
        northDirection = "Manhattan & Bronx (Norwood-205 st)";
        southDirection = "Manhattan & Brooklyn (Coney Island)";
        break;
      case "E":
        northDirection = "Manhattan (World Trade Center)";
        southDirection = "Uptown & Queens";
        break;
      case "F":
        northDirection = "Manhattan & Queens (Jamaica-179 st)";
        southDirection = "Manhattan & Brooklyn (Coney Island)";
        break;
      case "G":
        northDirection = "Queens (Court Sq)";
        southDirection = "Brooklyn (Church Av)";
        break;
      case "J":
        northDirection = "Queens (Jamaica Center)";
        southDirection = "Manhattan (Broad St)";
        break;
      case "L":
        northDirection = "Manhattan (8 Av)";
        southDirection = "Brooklyn (Canarsie)";
        break;
      case "M":
        northDirection = "Manhatan (57 St)";
        southDirection = "Queens (Middle Village)";
        break;
      case "N":
        northDirection = "Manhattan & Queens (Astoria)";
        southDirection = "Manhattan & Brooklyn (Coney Island)";
        break;
      case "Q":
        northDirection = "Manhattan (96 St)";
        southDirection = "Brooklyn (Coney Island)";
        break;
      case "R":
        northDirection = "Manhattan & Queens (Forest Hills)";
        southDirection = "Manhattan & Brooklyn (95 St)";
        break;
      case "W":
        northDirection = "Manhattan & Queens (Astoria)";
        southDirection = "Manhattan & Brooklyn (86 St)";
        break;
      case "Z":
        northDirection = "Queens (Jamaica)";
        southDirection = "Manhattan (Broadt St)";
        break;
      case "1":
        northDirection = "The Bronx (242 St)";
        southDirection = "Manhattan (South Ferry)";
        break;
      case "2":
        northDirection = "The Bronx";
        southDirection = "Brookyln";
        break;
      case "3":
        northDirection = "Manhattan (148 St)";
        southDirection = "Brookyln";
        break;
      case "4":
        northDirection = "Manhattan & The Bronx (WoodLawn)";
        southDirection = "Manhattan & Brooklyn (New Lots Av)";
        break;
      case "5":
        northDirection = "Manhattan & The Bronx";
        southDirection = "Manhattan & Brooklyn ";
        break;
      case "6":
        northDirection = "The Bronx (Pelham Bay Park)";
        southDirection = "Manhattan (BK Bridge-City Hall)";
        break;
      case "7":
        northDirection = "Queens (Flushing-Main St)";
        southDirection = "Manhattan (Hudson Yards)";
        break;
      default:
        northDirection = "Train Direction";
        southDirection = "Train Direction";
    }
  }
}
