import 'package:flutter/material.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/models/ticket_model.dart';
import 'package:ticket_kcc/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  List<OrderHistoryModel> _orderHistoryModels = [];
  final List<OrderHistoryModel> _guestOrderHistory = [];
  final List<TicketModel> _ticketModel = [];
  OrderHistoryModel? _orderHistoryModel;
  OrderModel? _orderModel;
  bool _isDetailLoading = false;
  String? _message;

  OrderHistoryModel? get orderHistoryModel => _orderHistoryModel;
  List<OrderHistoryModel> get orderHistoryModels => _orderHistoryModels;
  List<OrderHistoryModel> get guestOrderHistory => _guestOrderHistory;
  OrderModel? get orderModel => _orderModel;
  bool get isDetailLoading => _isDetailLoading;

  Future<void> placeOrder({
    required String visitDate,
    required int quantity,
    required String customerName,
    String? customerPhone,
    bool isGuest = false,
  }) async {
    try {
      // print('visitDate: $visitDate');
      final OrderModel orderModel = await _service.order(
        visitDate: visitDate,
        quantity: quantity,
        customerName: customerName,
        customerPhone: customerPhone,
      );
      _orderModel = orderModel;
      if (isGuest) {
        print('ya ini usernya guest');
        final OrderHistoryModel _orderHistoryModel = await _service
            .orderHistoryDetail(orderModel.orderId);
        _guestOrderHistory.add(_orderHistoryModel);
      }

      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getOrderHistory([
    String? customerName,
    bool isGuest = false,
  ]) async {
    _orderHistoryModels.clear();
    _isDetailLoading = true;
    notifyListeners();
    try {
      if (isGuest) {
        if (_guestOrderHistory.isEmpty) return;
        for (OrderHistoryModel element in _guestOrderHistory) {
          final OrderHistoryModel _orderHistoryModel = await _service
              .orderHistoryDetail(element.orderId);

          final int index = _guestOrderHistory.indexWhere(
            (e) => e.orderId == _orderHistoryModel.orderId,
          );

          if (index != -1) {
            // Order sudah ada, perbarui datanya
            _guestOrderHistory[index] = _orderHistoryModel;
          } else {
            // Order belum ada, tambahkan
            _guestOrderHistory.add(_orderHistoryModel);
          }
        }

        notifyListeners();
        return;
      }
      final List<OrderHistoryModel> orderHistoryModel =
          await _service.orderHistory();
      _orderHistoryModels = orderHistoryModel;

      notifyListeners();
    } catch (e) {
      print('error ini bos ${e.toString()}');
      _orderHistoryModels = [];
      notifyListeners();
      rethrow;
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDetailHistory(String orderId) async {
    _isDetailLoading = true;
    _orderHistoryModel = null;
    notifyListeners();
    try {
      final OrderHistoryModel orderHistoryModel = await _service
          .orderHistoryDetail(orderId);
      _orderHistoryModel = orderHistoryModel;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }
}
