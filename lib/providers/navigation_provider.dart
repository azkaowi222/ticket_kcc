import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void goToHistory() {
    _currentIndex = 1;
    notifyListeners();
  }

  void goToHome() {
    _currentIndex = 0;
    // notifyListeners();
  }
}
