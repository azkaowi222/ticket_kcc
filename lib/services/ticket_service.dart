import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ticket_kcc/models/ticket_model.dart';
import 'package:ticket_kcc/services/api_service.dart';
import 'package:ticket_kcc/services/storage_service.dart';

class TicketService {
  Future<TicketModel> detailTicket(String ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/tickets/$ticketId'),
      );
      final data = jsonDecode(response.body);
      final TicketModel ticketModel = TicketModel.fromjson(data['data']);
      return ticketModel;
    } catch (e, stack) {
      throw 'error Excepetion $e at $stack';
    }
  }

  Future<int> useTicket(String ticketId) async {
    try {
      final token = await StorageService.getToken();
      final response = await http.patch(
        Uri.parse('${ApiService.baseUrl}/tickets/$ticketId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception(response.statusCode);
      }
      final int statusCode = response.statusCode;
      return statusCode;
    } catch (e) {
      rethrow;
    }
  }
}
