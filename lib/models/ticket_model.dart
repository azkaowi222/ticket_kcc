class TicketModel {
  final String ticketId;
  final String ticketType;
  final String ticketStatus;
  final String? customerName;
  final DateTime? usedAt;
  final DateTime orderDate;

  const TicketModel({
    required this.ticketId,
    required this.ticketType,
    required this.ticketStatus,
    this.customerName,
    this.usedAt,
    required this.orderDate,
  });

  factory TicketModel.fromjson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticket_id'],
      ticketType: json['ticket_type'],
      customerName: json['order']['customer_name'],
      ticketStatus: json['ticket_status'],
      orderDate: DateTime.parse(json['order']['createdAt']),
    );
  }

  factory TicketModel.fromJsonDetail(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticket_id'],
      ticketType: json['ticket_type'],
      ticketStatus: json['ticket_status'],
      orderDate: DateTime.parse(json['createdAt']),
    );
  }
}
