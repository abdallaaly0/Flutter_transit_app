import 'package:flutter/material.dart';
import 'package:flutter_transit_app/maps.dart';

class TrainListScreen extends StatelessWidget {
  const TrainListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //button to return back to map
    return Scaffold(
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapSample()),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
                ),
                Text('Map'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
