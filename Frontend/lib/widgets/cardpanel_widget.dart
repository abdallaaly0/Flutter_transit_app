// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_transit_app/screens/MapLineScreen.dart';
import 'package:flutter_transit_app/service/DataFetcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../globals.dart';
import '../maps.dart';
import '../service/stateMangment.dart';

/* CardWidget that is built from station data
    The wigdet uses data from the api to update train times */

class CardPanel extends ConsumerStatefulWidget {
  final String stationName;
  final String train_id;
  final String train_icon;
  final LatLng station_postion;
  final Color card_color = const Color.fromRGBO(73, 98, 110, 1);

  CardPanel({
    super.key,
    required this.stationName,
    required this.train_id,
    required this.train_icon,
    required this.station_postion,
  });
  @override
  ConsumerState<CardPanel> createState() => CardPanelState();
}

class CardPanelState extends ConsumerState<CardPanel> {
  String nbound_time = "";
  String sbound_time = "";
  String northDirection = "Train Direction";
  String southDirection = "Train Direction";
  int i = 0;
  static const Color textColor = Colors.white;
  Duration callrate = const Duration(seconds: 30);
  Timer? timer;
  Globals Statetimer = Globals.intial(timer: true);

  // On app load set estimated times
  Future<void> initEstimatedTime() async {
    String dataN = '';
    String dataS = '';

    try {
      dataN = await DataFetcher()
          .getTrainTime("${widget.train_icon}${widget.train_id}N");
      dataS = await DataFetcher()
          .getTrainTime("${widget.train_icon}${widget.train_id}S");
      print("After data is called");
    } catch (e) {
      logger.e("API not connecting load "
          " for cardpanel: ${widget.train_icon}${widget.train_id} ");
    }
    if (mounted) {
      setState(() {
        print("Set State");
        nbound_time = dataN;
        sbound_time = dataS;
      });
    }
  }

  void reBuild() {
    Statetimer.Cardtimer = true;
    print("Inside Rebuild");
    setTrainDirection(widget.train_icon);
    initEstimatedTime();
    print("reBuild");
    timer = Timer.periodic(callrate, (Timer T) {
      onUpdate(T);
    });
  }

  @override
  void dispose() {
    //Called when widget is out of tree
    print("dispose");
    //Cancel timer when widget is disposed/deleted
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //Called when widget is frist built
    setTrainDirection(widget.train_icon);
    initEstimatedTime();
    print("InitalState");
    timer = Timer.periodic(callrate, (Timer T) {
      onUpdate(T);
    });
    super.initState();
  }

  @override
  void activate() {
    //Called when widget reinstered into tree
    logger.log(Level.info, "activate");
    super.activate();
  }

  @override
  void deactivate() {
    //Called before dispose
    timer!.cancel();
    super.deactivate();
  }

  /* Code to update time  and cards*/
  void onUpdate(Timer T) async {
    String dataN = '';
    String dataS = '';
    //If homepage is on screen run the update
    if ((Statetimer.Cardtimer) & (mounted)) {
      print("mouted: ${mounted},State Timer: ${Statetimer.Cardtimer}");
      try {
        dataN = await DataFetcher()
            .getTrainTime("${widget.train_icon}${widget.train_id}N");
        /* get New southbound times */
        dataS = await DataFetcher()
            .getTrainTime("${widget.train_icon}${widget.train_id}S");
        logger.i("API connected");
      } catch (e) {
        logger.e("API not connected");
      }

      if ((dataN == '') & (dataS == '')) {
        logger.i(
            "DataN: $dataN, DataS: $dataS, cancel timer, for ${widget.train_icon}${widget.train_id}  ");
        // ref.watch(dataProvider.notifier).state =
        //     "${widget.train_icon}${widget.train_id}";
      }
      logger
          .i("Update Time for cardID: ${widget.train_icon}${widget.train_id}N");

      int? current_estimated_time_N = int.tryParse(nbound_time);

      int? current_estimated_time_S = int.tryParse(sbound_time);

      int? api_new_time_n = int.tryParse(dataN);
      int? api_new_time_s = int.tryParse(dataS);

      /* If api pulled time is different for current data update card widget */
      if ((current_estimated_time_N != api_new_time_n) ||
          (current_estimated_time_S != api_new_time_s)) {
        if (mounted) {
          setState(() {
            nbound_time = dataN;
            sbound_time = dataS;
          });
        }
      } else {
        print("Don't change times");
      }
    } else {
      T.cancel();
      logger.i(
          "Mounted: $mounted, Card: ${widget.train_icon}${widget.train_id},Timer: ${T.isActive}");
    }
  }

  /* set route */
  void setrouteProviderState() {
    logger.log(Level.info, "Change route proveider");
    ref.watch(routeProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    setTrainDirection(widget.train_icon);
    return SizedBox(
      height: 130,
      child: GestureDetector(onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MapLine(
                    line: widget.train_icon,
                    stationData:
                        DataFetcher().getStationInfo(widget.train_icon),
                    stationlocation: widget.station_postion,
                    stop: widget.stationName,
                    stopID: widget.train_id,
                  )),
        );
      }, child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        /* Waits for the state "PositionProvider to change" then updates panel with nearest stations */
        ref.listen(rebuildCardProvider, (previous, next) {
          print("Location Button pressed reinstatewidget");
          reBuild();
        });
        return Card(
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
                    Container(
                      padding: const EdgeInsets.only(right: 2),
                      child: Row(
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              northDirection, // hardcoded for demonstration
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.25,
                                  color: textColor,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2,
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
                              "min",
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
                    Container(
                      padding: const EdgeInsets.only(right: 2, left: 2),
                      child: Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.509),
                            child: Text(
                              southDirection, // hardcoded for demonstration
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.25,
                                  color: textColor,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            ),
                          ),
                          const Spacer(),
                          //NorthBound
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              sbound_time,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              "min",
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
        );
      })),
    );
  }

  //Get train Directon based on the Line
  void setTrainDirection(String line) {
    switch (line) {
      case "A":
        northDirection = "Brooklyn and Manhattan (Inwood-207 St)";
        southDirection = "Queens (Leffert Blvd)";
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
        northDirection = "Uptown & Queens";
        southDirection = "Manhattan (World Trade Center)";
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
