import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_transit_app/service/DataFetcher.dart';
import 'package:flutter_transit_app/maps.dart';
import 'package:flutter_transit_app/widgets/cardpanel_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import '../entites/StationData.dart';
import '../service/stateMangment.dart';

/* This class is used to display the sliding widget, which displays cards from 
   CardPanel widget and should show the nearest stations based on a marker.
   This is the default panel shown when the Tranist app is loaded.
*/
class HomePanelView extends StatefulWidget {
  final ScrollController controller;
  final LatLng postion;
  const HomePanelView({
    Key? key,
    required this.controller,
    required this.postion,
  }) : super(key: key);

  @override
  State<HomePanelView> createState() => HomePanelViewState();
}

class HomePanelViewState extends State<HomePanelView> {
//Creates an instance of object DataFetcher that handels http requests
  final DataFetcher _dataFetcher = DataFetcher();
  List<StationData> cardList = [];
  late List<dynamic> stationData = [];

  // /* Build cards to be used in panel */
  // void buildArray() async {
  //   int maxCard = 5;
  //   stationData = _dataFetcher.getStationInfo("A");

  //   List<int> randomIndices =
  //       generateRandomIndices(stationData.length, maxCard);
  //   print(randomIndices.length);
  //   print(randomIndices);
  //   for (int i = 0; i < maxCard; i++) {
  //     cardList.add(StationData(
  //         stationName: stationData[randomIndices[i]]['name'],
  //         trainId: stationData[randomIndices[i]]['stop_id'].toString(),
  //         icon: "A",
  //         stationLocation: stationData[randomIndices[i]][''] ));
  //   }
  // }

  @override
  void initState() {
    buildPanel(widget.postion);
    super.initState();
  }

  /* Build panel based on postion */
  void buildPanel(LatLng postion, {WidgetRef? ref}) async {
    print("Build panel for location: $postion");
    setState(() {
      cardList.clear;
      cardList = DataFetcher()
          .getNearestStations(postion.latitude, postion.longitude, 3);
    });
    logger.log(Level.info, "Length of New CardList ${cardList.length}");
  }

  void removeCard(String stationID) async {
    String line = stationID.substring(0, 1);
    print("Line: $line");
    print("stationID: ${stationID.substring(1, stationID.length)}");
    cardList.removeWhere((element) {
      if ((element.icon == line) &
          (element.trainId == stationID.substring(1, stationID.length))) {
        return true;
      } else {
        return false;
      }
    });
    setState(() {
      cardList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        /* Waits for the state "PositionProvider to change" then updates panel with nearest stations */
        ref.listen(positionProvider, (previous, next) {
          print("New Postion: $next");
          if (next != previous) {
            buildPanel(next);
            /* Trigger Card Rebuild */
            ref.watch(rebuildCardProvider.notifier).state++;
          }
        });
        ref.listen(dataProvider, (previous, next) {
          print("Remove card: $next");
          removeCard(next);
        });
        return ListView.builder(
          controller: widget.controller,
          padding: const EdgeInsets.only(top: 15.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: cardList.length,
          addAutomaticKeepAlives: false,
          itemBuilder: (BuildContext context, int index) {
            return CardPanel(
              stationName: cardList[index].stationName,
              train_id: cardList[index].trainId,
              train_icon: cardList[index].icon,
              station_postion: cardList[index].stationLocation,
            );
          },
        );
      },
    );
  }

  List<int> generateRandomIndices(int listLength, int numberOfIndices) {
    if (numberOfIndices > listLength) {
      throw ArgumentError(
          "Number of indices requested exceeds the length of the list.");
    }

    List<int> indices = List.generate(listLength, (index) => index);
    indices.shuffle();

    return indices.sublist(0, numberOfIndices);
  }
}
