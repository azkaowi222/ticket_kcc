import 'package:flutter/material.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();

  Future<OrderModel> placeOrder({
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
      return orderModel;
    } catch (e) {
      print("errornya ini bos: ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
