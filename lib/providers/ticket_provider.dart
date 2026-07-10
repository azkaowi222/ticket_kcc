import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  String dayName = '';
  DateTime? selectedDate;
  int _ticketQty = 1;
  bool _isConfirmationPage = false;
  int _ticketPrice = 50000;

  bool get isConfirmationPage => _isConfirmationPage;
  int get ticketPrice => _ticketPrice;
  int get ticketQty => _ticketQty;

  set setDate(date) {
    selectedDate = date;
    notifyListeners();
  }

  set setTicketQty(int ticket) {
    _ticketQty = ticket;
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      dayName = getDayName(date);
      if (date.weekday >= 6) {
        _ticketPrice = 50000;
      } else {
        _ticketPrice = 40000;
      }
      selectedDate = date;
      notifyListeners();
    }
  }

  void ticketIncrement() {
    _ticketQty++;
    notifyListeners();
  }

  void ticketDecrement() {
    if (_ticketQty == 1) return;
    _ticketQty--;
    notifyListeners();
  }

  void setConfirmationPage(bool state) {
    _isConfirmationPage = state;
    notifyListeners();
  }

  String getDayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
