import 'package:flutter/material.dart';
import 'package:catch_me_if_you_can/utils/constants.dart';

class SingleNotifier extends ChangeNotifier {
  String _currentDifficulty = levelDifficulty[0];
  SingleNotifier();
  String get currentDifficulty => _currentDifficulty;
  updateDifficulty(String value) {
    if (value != _currentDifficulty) {
      _currentDifficulty = value;
      notifyListeners();
    }
  }
}