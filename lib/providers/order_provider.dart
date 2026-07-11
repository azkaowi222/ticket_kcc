import 'package:flutter/material.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  OrderModel? _order;
  List<OrderHistoryModel> orderHistoryModels = [];

  OrderModel? get order => _order;

  Future<void> placeOrder({
    required String visitDate,
    required int quantity,
    required String customerName,
    String? customerPhone,
  }) async {
    try {
      // print('visitDate: $visitDate');
      final OrderModel orderModel = await _service.order(
        visitDate: visitDate,
        quantity: quantity,
        customerName: customerName,
        customerPhone: customerPhone,
      );
      _order = orderModel;
    } catch (e) {
      print("errornya ini bos: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> getOrderHistory() async {
    try {
      final List<OrderHistoryModel> orderHistoryModel =
          await _service.orderHistory();
      orderHistoryModels = orderHistoryModel;
      notifyListeners();
    } catch (e) {
      print('error ini bos ${e.toString()}');
      orderHistoryModels = [];
      notifyListeners();
      rethrow;
    }
  }
}
