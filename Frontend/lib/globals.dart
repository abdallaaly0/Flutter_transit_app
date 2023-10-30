// This class is used to hold global variables
// There can only be one instance of this class
import 'dart:async';

class Globals {
  //Global var
  late bool Cardtimer;
  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }
  factory Globals.intial({required bool timer}) {
    _singleton.Cardtimer = timer;
    return _singleton;
  }
  Globals._internal();
}
