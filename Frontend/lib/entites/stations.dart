// To parse this JSON data, do
//
//     final stations = stationsFromJson(jsonString);

import 'dart:convert';

Stations stationsFromJson(String str) => Stations.fromJson(json.decode(str));

String stationsToJson(Stations data) => json.encode(data.toJson());

class Stations {
  List<ALine> aLine;

  Stations({
    required this.aLine,
  });

  factory Stations.fromJson(Map<String, dynamic> json) => Stations(
        aLine: List<ALine>.from(json["A-line"].map((x) => ALine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "A-line": List<dynamic>.from(aLine.map((x) => x.toJson())),
      };
}

class ALine {
  String stopId;
  String name;
  double lat;
  double lon;
  String parentId;

  ALine({
    required this.stopId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.parentId,
  });

  factory ALine.fromJson(Map<String, dynamic> json) => ALine(
        stopId: json["stop_id"],
        name: json["name"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        parentId: json["parent_id"],
      );

  Map<String, dynamic> toJson() => {
        "stop_id": stopId,
        "name": name,
        "lat": lat,
        "lon": lon,
        "parent_id": parentId,
      };
}
