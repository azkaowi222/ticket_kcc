class TicketModel {
  final String ticketId;
  final String ticketType;
  final String ticketStatus;
  final DateTime usedAt;

  const TicketModel({
    required this.ticketId,
    required this.ticketType,
    required this.ticketStatus,
    required this.usedAt,
  });

  factory TicketModel.fromjson(Map<String, dynamic> json) {
    return TicketModel(
      ticketId: json['ticketId'],
      ticketType: json['ticketType'],
      ticketStatus: json['ticketStatus'],
      usedAt: DateTime.parse(json['usedAt']),
    );
  }
}
