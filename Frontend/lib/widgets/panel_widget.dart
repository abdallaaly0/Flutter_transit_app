import 'package:flutter/material.dart';
import 'package:flutter_transit_app/widgets/homepanel.dart';
import 'timepanel.dart';
import 'package:flutter_transit_app/globals.dart';

//Widget That describes what is seen in the sliding up panel

Globals cardclicked = Globals.intial(view: false);

class PanelWidget extends StatefulWidget {
  final ScrollController controller;

  const PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<PanelWidget> createState() => PanelWidgetState();
}

class PanelWidgetState extends State<PanelWidget> {
  void inistate() {
    cardclicked.view = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: HomePanel(controller: widget.controller));
  }

  // void onCardClick() {
  //   setState((){

  //   })
  // }
}
