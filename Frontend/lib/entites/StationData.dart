import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationData {
  String stationName;
  String trainId;
  String icon;
  LatLng stationLocation;

  StationData({
    required this.stationName,
    required this.trainId,
    required this.icon,
    required this.stationLocation,
  });
}
