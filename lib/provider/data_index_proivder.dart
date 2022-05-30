import 'package:flutter/material.dart';

/*
  各类需要替换的Provider
 */
class DataIndexProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
