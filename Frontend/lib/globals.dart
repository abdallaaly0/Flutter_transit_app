// This class is used to hold global variables
// There can only be one instance of this class
class Globals {
  //Global var
  late bool view;

  static final Globals _singleton = Globals._internal();

  factory Globals() {
    return _singleton;
  }
  factory Globals.intial({required bool view}) {
    _singleton.view = view;
    return _singleton;
  }
  Globals._internal();
}
