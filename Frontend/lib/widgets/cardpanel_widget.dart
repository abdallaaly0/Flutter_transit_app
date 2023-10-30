// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_transit_app/DataFetcher.dart';

import '../globals.dart';

class CardPanel extends StatefulWidget {
  final String stationName;
  final Color card_color;
  final String train_direction;
  final String train_id;
  final String train_icon;
  String train_time;

  CardPanel({
    super.key,
    required this.card_color,
    required this.stationName,
    required this.train_time,
    required this.train_direction,
    required this.train_id,
    required this.train_icon,
  });
  @override
  State<CardPanel> createState() => CardPanelState();
}

class CardPanelState extends State<CardPanel> {
  String estimatedTime = "";
  late String icon;
  Duration callrate = const Duration(seconds: 30);
  Timer? timer;
  Globals Statetimer = Globals.intial(timer: true);
//When the card is clicked perform the following things
  Future<void> initEstimatedTime() async {
    String data = await DataFetcher().Foo(widget.train_id);
    estimatedTime = data;
    setState(() {
      estimatedTime = data;
    });
    print("Estimated Time " + estimatedTime);
  }

  @override
  void initState() {
    initEstimatedTime();
    icon = widget.train_icon;
    print("InitalState");
    super.initState();
    timer = Timer.periodic(callrate, (Timer t) => onUpdate());
  }

  @override
  void deactivate() {
    print("deactivate");
    if (timer!.isActive) {
      timer!.cancel();
    } else {
      timer!.cancel();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    print("dispose");
    timer!.cancel();
    super.dispose();
  }

  void onUpdate() async {
    if (Statetimer.Cardtimer) {
      print("State Timer: ${Statetimer.Cardtimer}");
      String data = await DataFetcher().Foo(widget.train_id);
      int current_estimated_time = int.parse(estimatedTime);
      print("Current estimated time: $current_estimated_time");
      print("Estimated time: $estimatedTime");
      int api_new_time = int.parse(data);
      print("api time: $api_new_time");
      /* If api pulled time is different for current data update card widget */
      if (current_estimated_time != api_new_time) {
        print("Update card");
        setState(() {
          estimatedTime = data;
        });
      } else {
        print("Do not update card");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: GestureDetector(
          onTap: () => {timer!.cancel()},
          child: Card(
            color: widget.card_color,
            margin: const EdgeInsets.all(8.0),
            elevation: 20.0,
            shadowColor: Colors.blue,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 0, 0),
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: Image.asset(
                    "assets/TrainIcons/$icon.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 65, 0, 0),
                child: Text(
                  widget.train_direction,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 85, 0, 0),
                child: Text(
                  widget.stationName,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(320, 45, 0, 0),
                child: Text(
                  estimatedTime,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(305, 75, 0, 0),
                child: Text(
                  "minutes",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
