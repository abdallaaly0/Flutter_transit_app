import 'package:flutter/material.dart';
import 'package:flutter_transit_app/widgets/cardpanel_widget.dart';

/* This class is used to display the sliding widget, which displays cards from 
   CardPanel widget and should show the nearest stations based on a marker.
   This is the default panel shown when the Tranist app is loaded.
*/
class HomePanelView extends StatelessWidget {
  final ScrollController controller;
  final VoidCallback callback;
  const HomePanelView({
    Key? key,
    required this.controller,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
          ),
        ),
        const SizedBox(height: 26),
        CardPanel(
          card_color: Colors.blueGrey,
          stationName: "stationName",
          train_time: "9",
          train_direction: "Train_direction",
          train_type: "train_type",
          train_icon: "a",
          callback: callback,
        ),
        CardPanel(
          card_color: Colors.blueGrey,
          stationName: "stationName",
          train_time: "8",
          train_direction: "Train_direction",
          train_type: "train_type",
          train_icon: "b",
          callback: callback,
        ),
      ],
    );
  }
}
