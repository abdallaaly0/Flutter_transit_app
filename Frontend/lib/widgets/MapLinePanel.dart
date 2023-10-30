import 'package:flutter/material.dart';
import 'package:flutter_transit_app/PanelViews/homepanel.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:flutter_transit_app/screens/SubwayLinesScreen.dart';

class MapLinePanel extends StatelessWidget {
  final ScrollController controller;

  const MapLinePanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        // SizedBox(
        //   height: 65,
        //   child: Card(
        //     color: Colors.black,
        //     elevation: 10.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 65,
        //   child: Card(
        //     color: Colors.black,
        //     elevation: 10.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
