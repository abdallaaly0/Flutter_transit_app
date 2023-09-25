import 'package:flutter/material.dart';
import 'package:flutter_transit_app/DataFetcher.dart';
import 'package:flutter_transit_app/widgets/cardpanel_widget.dart';

/* This class is used to display the sliding widget, which displays cards from 
   CardPanel widget and should show the nearest stations based on a marker.
   This is the default panel shown when the Tranist app is loaded.
*/
class HomePanelView extends StatefulWidget {
  final ScrollController controller;
  final VoidCallback callback;

  const HomePanelView({
    Key? key,
    required this.controller,
    required this.callback,
  }) : super(key: key);

  @override
  State<HomePanelView> createState() => HomePanelViewState();
}

class HomePanelViewState extends State<HomePanelView> {
//Creates an instance of object DataFetcher that handels http requests
  final DataFetcher _dataFetcher = DataFetcher();

  String estimatedTime = "0";
  @override
  void inistate() async {
    estimatedTime = _dataFetcher.fetchATrainData().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), onPullDown);
      },
      child: ListView(
        controller: widget.controller,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
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
            train_time: estimatedTime,
            train_direction: "Train_direction",
            train_type: "train_type",
            train_icon: "a",
            callback: widget.callback,
          ),
        ],
      ),
    );
  }

  //Function that updates homepanel and train time
  void onPullDown() async {
    var data = await _dataFetcher.fetchATrainData();
    setState(() {
      estimatedTime = data.toString();
    });
  }
}
