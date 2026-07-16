import 'package:flutter/material.dart';
import 'package:ticket_kcc/models/ticket_model.dart';
import 'package:ticket_kcc/services/ticket_service.dart';

class TicketProvider extends ChangeNotifier {
  String dayName = '';
  DateTime? selectedDate;
  int _ticketQty = 1;
  bool _isConfirmationPage = false;
  int _ticketPrice = 50000;
  TicketModel? _ticketModel;
  bool _isLoading = false;
  final TicketService _service = TicketService();

  bool get isConfirmationPage => _isConfirmationPage;
  bool get isLoading => _isLoading;
  int get ticketPrice => _ticketPrice;
  int get ticketQty => _ticketQty;
  TicketModel? get ticketModel => _ticketModel;

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

  Future<void> getTicketDetails(String ticketId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final TicketModel ticketModel = await _service.detailTicket(ticketId);
      _ticketModel = ticketModel;

      notifyListeners();
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> updateTicket(String ticketId) async {
    try {
      final int ticketStatusCode = await _service.useTicket(ticketId);
      return ticketStatusCode;
    } catch (e) {
      print(e.toString());
      return 400;
    }
  }
}
