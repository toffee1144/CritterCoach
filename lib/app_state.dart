import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _xp = prefs.getInt('ff_xp') ?? _xp;
    });
    _safeInit(() {
      _coins = prefs.getInt('ff_coins') ?? _coins;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  int _xp = 0;
  int get xp => _xp;
  set xp(int value) {
    _xp = value;
    prefs.setInt('ff_xp', value);
  }

  int _coins = 0;
  int get coins => _coins;
  set coins(int value) {
    _coins = value;
    prefs.setInt('ff_coins', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
