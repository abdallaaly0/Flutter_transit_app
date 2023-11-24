// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_transit_app/DataFetcher.dart';

import '../globals.dart';

class CardPanel extends StatefulWidget {
  final String stationName;
  final String train_id;
  final String train_icon;
  final Color card_color = const Color.fromRGBO(73, 98, 110, 1);

  CardPanel({
    super.key,
    required this.stationName,
    required this.train_id,
    required this.train_icon,
  });
  @override
  State<CardPanel> createState() => CardPanelState();
}

class CardPanelState extends State<CardPanel> {
  String nbound_time = "";
  String sbound_time = "";
  String northDirection = "Train Direction";
  String southDirection = "Train Direction";

  static const Color textColor = Colors.white;
  late String icon;
  Duration callrate = const Duration(seconds: 30);
  Timer? timer;
  Globals Statetimer = Globals.intial(timer: true);

  // On app load set estimated times
  Future<void> initEstimatedTime() async {
    String dataN = await DataFetcher()
        .getTrainTime("${widget.train_icon}${widget.train_id}N");
    String dataS = await DataFetcher()
        .getTrainTime("${widget.train_icon}${widget.train_id}S");
    setState(() {
      nbound_time = dataN;
      sbound_time = dataS;
    });
  }

  @override
  void initState() {
    setTrainDirection(widget.train_icon);
    initEstimatedTime();
    print("InitalState");
    super.initState();

    // Start timer for api calls based on callrate
    timer = Timer.periodic(callrate, (Timer t) => onUpdate());
  }

  @override
  void dispose() {
    print("dispose");
    //Cancel timer when widget is disposed/deleted
    timer!.cancel();
    super.dispose();
  }

  /* Code to update time  and cards*/
  void onUpdate() async {
    //If homepage is on screen run the update
    if (Statetimer.Cardtimer) {
      print("Key: ${widget.key},State Timer: ${Statetimer.Cardtimer}");
      /* get New northbound times */
      String dataN = await DataFetcher()
          .getTrainTime("${widget.train_icon}${widget.train_id}N");
      int current_estimated_time_N = int.parse(nbound_time);

      /* get New southbound times */
      String dataS = await DataFetcher()
          .getTrainTime("${widget.train_icon}${widget.train_id}S");
      int current_estimated_time_S = int.parse(sbound_time);

      int api_new_time_n = int.parse(dataN);
      int api_new_time_s = int.parse(dataS);

      /* If api pulled time is different for current data update card widget */
      if ((current_estimated_time_N != api_new_time_n) ||
          (current_estimated_time_S != api_new_time_s)) {
        setState(() {
          nbound_time = dataN;
          sbound_time = dataS;
        });
      } else {
        print("Don't change times");
      }
    } else {
      print("State Timer: ${Statetimer.Cardtimer}, Turn off state timer");
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: GestureDetector(
        onTap: () => {DataFetcher().getTrainTimeList(widget.train_id)},
        child: Card(
          color: widget.card_color,
          margin: const EdgeInsets.all(8.0),
          elevation: 20.0,
          shadowColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            children: [
              // 20% portion
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/TrainIcons/${widget.train_icon}.png",
                      height: 50.0,
                      width: 50.0,
                    ),
                    Text(
                      widget.stationName,
                      style: const TextStyle(
                          fontSize: 14,
                          color: textColor,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              // 80% portion
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    // Top half
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                northDirection, // hardcoded for demonstration
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.25,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          //NorthBound
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              nbound_time,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              "minutes",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: textColor,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom half
                    Expanded(
                      child: Row(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              southDirection,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.25,
                                color: textColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Southbound
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              sbound_time, // need to modify this to have different estimated time for the second direction
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Text(
                              "minutes",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: textColor,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
        northDirection = "Bronx (Norwood-205 st)";
        southDirection = "Brooklyn (Coney Island)";
        break;
      case "E":
        northDirection = "Manhattan (World Trade Center)";
        southDirection = "Uptown & Queens";
        break;
      case "F":
        northDirection = "Queens (Jamaica-179 st)";
        southDirection = "Brooklyn (Coney Island)";
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
        northDirection = "Queens (Astoria)";
        southDirection = "Brooklyn (Coney Island)";
        break;
      case "Q":
        northDirection = "Manhattan (96 St)";
        southDirection = "Brooklyn (Coney Island)";
        break;
      case "R":
        northDirection = "Queens (Forest Hills)";
        southDirection = "Brooklyn (95 St)";
        break;
      case "W":
        northDirection = "Queens (Astoria)";
        southDirection = "Brooklyn (86 St)";
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
        northDirection = "The Bronx (WoodLawn)";
        southDirection = "Brooklyn (New Lots Av)";
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
