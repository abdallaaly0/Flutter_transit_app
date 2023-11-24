// This class is used to hold global variables
// There can only be one instance of this class
import 'dart:async';

class Globals {
  //Global var
  late bool Cardtimer;
  bool onMapLineScreen = false;
  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }
  factory Globals.intial({required bool timer}) {
    _singleton.Cardtimer = timer;
    return _singleton;
  }
  /* Set if varibale is on maplinescreen */
  void setonMapLineScreen(bool val) {
    onMapLineScreen = val;
  }

  bool getonMapLineScreen() {
    return onMapLineScreen;
  }

  Globals._internal();
}
