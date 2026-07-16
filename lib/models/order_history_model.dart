import 'package:ticket_kcc/models/ticket_model.dart';

class OrderHistoryModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final int quantity;
  final DateTime visitDate;
  final int price;
  final int fee;
  final int total;
  final String orderStatus;
  final DateTime createdAt;
  final List<TicketModel> tickets;

  const OrderHistoryModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.quantity,
    required this.visitDate,
    required this.price,
    required this.fee,
    required this.total,
    required this.orderStatus,
    required this.createdAt,
    required this.tickets,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final _tickets = json['tickets'] ?? '';
    final List<TicketModel> _finalTickets = [];
    if (_tickets.isNotEmpty || _tickets != '') {
      for (Map<String, dynamic> _ticket in _tickets) {
        _finalTickets.add(TicketModel.fromJsonDetail(_ticket));
      }
    }
    return OrderHistoryModel(
      orderId: json['order_id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'].toString(),
      quantity: json['quantity'],
      visitDate: DateTime.parse(json['visit_date']),
      price: json['price'],
      fee: json['fee'],
      total: json['total'],
      orderStatus: json['order_status'],
      createdAt: DateTime.parse(json['createdAt']),
      tickets: _finalTickets,
    );
  }
}
