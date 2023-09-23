// ignore_for_file: non_constant_identifier_names
/*
import 'package:flutter/material.dart';

class CardPanel extends StatelessWidget {
  final String stationName;
  final Color card_color;
  final String train_time;
  final String train_direction;
  final String train_type;
  final VoidCallback callback;
  final String train_icon;

  CardPanel({
    super.key,
    required this.card_color,
    required this.stationName,
    required this.train_time,
    required this.train_direction,
    required this.train_type,
    required this.callback,
    required this.train_icon,
  });

//When the card is clicked perform the following things

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: GestureDetector(
          onTap: callback,
          child: Card(
            color: card_color,
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
                    "assets/TrainIcons/$train_icon.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 65, 0, 0),
                child: Text(
                  train_direction,
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
                  stationName,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(320, 45, 0, 0),
                child: Text(
                  train_time,
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
*/