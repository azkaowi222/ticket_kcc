import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class OrderService {
  Future<OrderModel> order({
    required String visitDate,
    required int quantity,
    required String customerName,
    String? customerPhone,
  }) async {
    try {
      final String? token = await StorageService.getToken();
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/orders/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'visitDate': visitDate,
          'quantity': quantity,
          'customerName': customerName,
          'customerPhone': customerPhone,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        final errorMessage = data['message'] as String;
        throw Exception(errorMessage);
      }
      final OrderModel orderModel = OrderModel.fromJson(data);
      return orderModel;
    } catch (e, stack) {
      throw Exception('Error exception $e, $stack');
    }
  }

  Future<List<OrderHistoryModel>> orderHistory() async {
    try {
      final token = await StorageService.getToken();
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/orders/history'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = jsonDecode(response.body);
      // print('data: $data');
      if (response.statusCode != 200) {
        final errorMsg = data['message'] as String;
        throw Exception(errorMsg);
      }

      final datas = data['data'] as List;

      final List<OrderHistoryModel> orderHistoryModel =
          datas.map((e) {
            return OrderHistoryModel.fromJson(e);
          }).toList();
      return orderHistoryModel;
    } catch (e, stack) {
      print('Error exception $e, $stack');
      throw Exception('Error exception $e, $stack');
    }
  }
}
