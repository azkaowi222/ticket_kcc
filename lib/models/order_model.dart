class OrderModel {
  final int statusCode;
  final String orderId;
  final DateTime visitDate;
  final String message;
  final int quantity;
  final int price;
  final int total;
  final String paymentStatus;
  final String paymentNumber;
  final int fee;
  final int totalPayment;

  const OrderModel({
    required this.statusCode,
    required this.orderId,
    required this.visitDate,
    required this.message,
    required this.quantity,
    required this.price,
    required this.total,
    required this.paymentStatus,
    required this.paymentNumber,
    required this.fee,
    required this.totalPayment,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> payment = json['data']['pakasir']['payment'];
    return OrderModel(
      statusCode: json['status'],
      orderId: json['data']['order_id'],
      visitDate: DateTime.parse(json['data']['visitDate']),
      message: json['message'],
      quantity: json['data']['quantity'],
      price: json['data']['price'],
      total: json['data']['total'],
      paymentStatus: json['data']['payment_status'],
      paymentNumber: payment['payment_number'],
      fee: payment['fee'],
      totalPayment: payment['total_payment'],
    );
  }
}
