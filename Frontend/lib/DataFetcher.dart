import 'dart:convert';
// import 'package:flutter_transit_app/entites/stations.dart';
import 'package:http/http.dart' as http;
import '../assets/StationData.dart';
import 'package:flutter/services.dart';

//This class is used for fetching and serving data to app

class DataFetcher {
  //URL were API server is running
  static const baseURL = "http://192.168.1.250:5000";
  static const atrainEndpoint =
      "$baseURL/api/train-time"; //Adds '/Atrain' to baseURL
  static const postEndpoint = "$baseURL/api/response";
  static const JsonFilePath = "assets/Stations.json";

  /* /* This class function returns a dynamic list of data */
  Future<Map<String, List<Line>>> loadJsonData(String line) async {
    Map<String, List<Line>> data = {};
    final String jsonString = await rootBundle.loadString(JsonFilePath);
    final jsonData = Stations.fromJson(jsonDecode(jsonString));
    return data;
    // Use the data as needed in your Flutter app.
  } */

  /* Creates a List based on the station ID's in each route */
  List<dynamic> getStationInfo(String line) {
    List<dynamic> DataList = List.empty(growable: true);
    /* Get route IDs for "line" */
    for (int i = 0; i < Lines_NorthBound[line]!.length; i++) {
      String desiredID = Lines_NorthBound[line]!.elementAt(i);
      for (int i = 0; i < Stations["Stations"]!.length; i++) {
        if (Stations["Stations"]!.elementAt(i)['stop_id'].toString() ==
            desiredID) {
          DataList.add(Stations["Stations"]!.elementAt(i));
        }
      }
    }
    return DataList;
  }

  Future<int> fetchATrainData() async {
    final url = Uri.parse(atrainEndpoint);
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['train time'];
    } else {
      throw Exception('Failed to load post:');
    }
  }

  /* This function gets train data based on stationID */
  Future<String> Foo(String stationID) async {
    final url = Uri.parse(postEndpoint);
    final response =
        await http.post(url, body: json.encode({'name': stationID}));
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data['name'].toString());
      return data['name'].toString();
    } else {
      throw Exception('Failed to load post:');
    }
    // final res = await http.get(url);
    // if (res.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   return data['train time'];
    // } else {
    //   throw Exception('Failed to load post:');
    // }
  }

  /* Function For getting MapStyle */
  String getMapStyle() {
    late String _mapStyle;
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
      print(_mapStyle);
    });
    return _mapStyle;
  }
}
