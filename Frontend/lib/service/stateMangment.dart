import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final positionProvider = StateProvider<LatLng>((ref) => LatLng(10, 15));

final rebuildCardProvider = StateProvider<int>((ref) => 0);
/* Whether the previous root will be maps  */
final routeProvider = StateProvider<bool>((ref) => true);
/* Provids data for function  */
final dataProvider = StateProvider<String>((ref) => "");
/* Controlls global timer   */
final stateTimer = StateProvider<bool>((ref) => false);
/* isCamerMoving? */
final isCameraMoving = StateProvider<bool>((ref) => false);
