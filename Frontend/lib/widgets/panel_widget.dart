/*
import 'package:flutter/material.dart';
import 'package:flutter_transit_app/PanelViews/homepanel.dart';
import '../PanelViews/timepanel.dart';
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
    if (cardclicked.view) {
      return Container(child: TimePanel(controller: widget.controller));
    }
    return Container(
        child: HomePanelView(
      controller: widget.controller,
      callback: onCardClick,
    ));
  }

  //When a CardWidget is clicked we change the cardclicked.view to true
  void onCardClick() {
    setState(() {
      print("Card Clicked");
      //cardclicked.view = true;
    });
  }
}
*/