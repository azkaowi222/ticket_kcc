class OrderHistoryModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final int quantity;
  final DateTime visitDate;
  final int price;
  final int total;
  final String orderStatus;
  final DateTime createdAt;

  const OrderHistoryModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.quantity,
    required this.visitDate,
    required this.price,
    required this.total,
    required this.orderStatus,
    required this.createdAt,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      orderId: json['order_id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'].toString(),
      quantity: json['quantity'],
      visitDate: DateTime.parse(json['visit_date']),
      price: json['price'],
      total: json['total'],
      orderStatus: json['order_status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
