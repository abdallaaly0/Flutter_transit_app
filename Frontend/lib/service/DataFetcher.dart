import 'dart:async';
import 'dart:convert';
import 'dart:math';
// import 'package:flutter_transit_app/entites/stations.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../data/data.dart';
import 'package:flutter/services.dart';
import 'package:kdtree/kdtree.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../entites/StationData.dart';

//This class is used for fetching and serving data to app

class DataFetcher {
  //URL to connet to API
  static const baseURL = "http://192.168.1.250:5000";
  //Endpoints
  static const singleTimeEndpoint = "$baseURL/api/single_times";
  static const listTimesEndpoint = "$baseURL/api/multipule_times";

  /* build and return a List based on line exp: ("A","B","C") */
  List<dynamic> getStationInfo(String line) {
    List<dynamic> builtList = List.empty(growable: true);

    /* LineStation contains all station ID's that go through a train line
       for each index of LineStaion, get data for that specific station and
       add it to builtList */
    for (int i = 0; i < lineStations[line]!.length; i++) {
      String desiredID = lineStations[line]!.elementAt(i);
      for (int i = 0; i < allStationsData["Stations"]!.length; i++) {
        if (allStationsData["Stations"]!.elementAt(i)['stop_id'].toString() ==
            desiredID) {
          builtList.add(allStationsData["Stations"]!.elementAt(i));
        }
      }
    }
    return builtList;
  }

  /* This function gets arrival time  data based on stationID */
  Future<String> getTrainTime(String stationID) async {
    print("Get time for Station ID: $stationID");
    final url = Uri.parse(singleTimeEndpoint);

    /* Send data to API */
    final response =
        await http.post(url, body: json.encode({'name': stationID}));
    print('Response status: ${response.statusCode}');
    /* Handle response data */
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Data: ${data['name']}");
      return data['name'].toString();
    } else {
      print("Error for station:  $stationID ");
      throw Exception('Failed to load post:');
    }
  }

  /* Get Train List of Train times for station */
  Future<List<dynamic>> getTrainTimeList(String stationID) async {
    List<dynamic> TrainTimes;
    final url = Uri.parse(listTimesEndpoint);
    final response =
        await http.post(url, body: json.encode({'name': stationID}));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      TrainTimes = data['name'];
      return TrainTimes;
    } else {
      throw Exception('Failed to load post:');
    }
  }

  /* Function gets List of nearest stations using KD tree,
     Gets data based on postion, maxNode, and optional maxDistance
   */
  List<StationData> getNearestStations(double lat, double lon, int maxNodes,
      {int? maxDistance}) {
    List<StationData> formatedNearest = [];
    List<String> Icons = [];

    /* Function That gives the distance bewteen two points */
    distance(a, b) {
      return pow(a['lat'] - b['lat'], 2) + pow(a['lon'] - b['lon'], 2);
    }

    KDTree tree =
        KDTree(allStationsData["Stations"]!, distance, ['lat', 'lon']);
    print("tree: $tree");

    List<dynamic> nearest =
        tree.nearest({'lat': lat, 'lon': lon}, maxNodes, maxDistance);
    //nearest[0] has data
    //nearest[1] has distance between points
    print("NearestList: ${nearest}");

    for (int i = nearest.length - 1; i > 0; i--) {
      /* Check what Lines go through the station */
      lineStations.forEach((key, value) {
        if (value.contains(nearest[i][0]['stop_id'].toString())) {
          Icons.add(key);
        }
      });

      print("Icons for ${nearest[i][0]['name']}: $Icons ");

      //Add StationData
      for (int j = 0; j < Icons.length; j++) {
        formatedNearest.add(StationData(
          stationName: nearest[i][0]['name'],
          trainId: nearest[i][0]['stop_id'].toString(),
          icon: Icons[j],
          stationLocation: LatLng(nearest[i][0]['lat'], nearest[i][0]['lon']),
        ));
      }
      Icons.clear();
    }
    print("Built string length: ${formatedNearest.length}");
    print("Print formatedNearest: ${formatedNearest}");
    return formatedNearest;
  }
}
