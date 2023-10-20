// To parse this JSON data, do
//
//     final stations = stationsFromJson(jsonString);

import 'dart:convert';

Stations stationsFromJson(String str) => Stations.fromJson(json.decode(str));

String stationsToJson(Stations data) => json.encode(data.toJson());

class Stations {
  List<Line> lineA;
  List<Line> line1;

  Stations({
    required this.line1,
    required this.lineA,
  });

  factory Stations.fromJson(Map<String, dynamic> json) => Stations(
      line1: List<Line>.from(json["1"].map((x) => Line.fromJson(x))),
      lineA:
          List<Line>.from(json["A-FarRockaway"].map((x) => Line.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "1": List<dynamic>.from(lineA.map((x) => x.toJson())),
      };
}

class Line {
  dynamic stopId;
  String name;
  double lat;
  double lon;
  dynamic parentStation;

  Line({
    required this.stopId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.parentStation,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        stopId: json["stop_id"]?.toString(),
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        parentStation: json["parent_station"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "stop_id": stopId,
        "name": name,
        "lat": lat,
        "lon": lon,
        "parent_station": parentStation,
      };
}
