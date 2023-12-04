import 'package:flutter/material.dart';
import 'package:flutter_transit_app/PanelViews/homepanel.dart';
import 'package:flutter_transit_app/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Widget That describes what is seen in the sliding up panel

// Globals cardclicked = Globals.intial(view: false);

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final LatLng postion;
  const PanelWidget({
    Key? key,
    required this.controller,
    required this.postion,
  }) : super(key: key);

  @override
  State<PanelWidget> createState() => PanelWidgetState();
}

class PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return HomePanelView(
      controller: widget.controller,
      postion: widget.postion,
    );
  }
}
