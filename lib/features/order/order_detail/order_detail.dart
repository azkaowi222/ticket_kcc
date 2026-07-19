import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/models/ticket_model.dart';
import 'package:ticket_kcc/providers/order_provider.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;
  const OrderDetail({super.key, required this.orderId});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  TicketModel? selectedTicket;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  Future<void> _loadDetail() async {
    context.loaderOverlay.show();

    try {
      await context.read<OrderProvider>().getDetailHistory(widget.orderId);
      if (!mounted) return;

      final order = context.read<OrderProvider>().orderHistoryModel;

      if (order != null) {
        selectedTicket = order.tickets.first;
      }
    } finally {
      if (mounted && context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderHistoryModel? order =
        context.watch<OrderProvider>().orderHistoryModel;

    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return SpinKitThreeInOut(color: Colors.white, size: 25);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order detail'),
          actions: [
            Text(
              order?.orderStatus != null ? order!.orderStatus : '...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    order?.orderStatus != null
                        ? order!.orderStatus == 'success'
                            ? Color.fromARGB(255, 84, 143, 107)
                            : order.orderStatus == 'pending'
                            ? Color.fromARGB(255, 254, 141, 0)
                            : Color.fromARGB(255, 222, 151, 157)
                        : Colors.white,
              ),
            ),
          ],
          actionsPadding: EdgeInsets.all(12),
          centerTitle: false,
          titleSpacing: 0,
          titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child:
                order != null
                    ? Column(
                      children: [
                        order.orderStatus != 'success'
                            ? Stack(
                              children: [
                                ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: Image.asset(
                                    'assets/images/qr-placeholder.png',
                                    width: 220,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.lock_rounded,
                                    size: 28,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                            : selectedTicket != null
                            ? Column(
                              children: [
                                DropdownButton<TicketModel>(
                                  value: selectedTicket,
                                  isExpanded: true,
                                  items:
                                      order.tickets
                                          .asMap()
                                          .entries
                                          .map(
                                            (entry) =>
                                                DropdownMenuItem<TicketModel>(
                                                  value: entry.value,
                                                  child: Text(
                                                    'Ticket ${entry.key + 1}',
                                                  ),
                                                ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTicket = value;
                                    });
                                  },
                                ),
                                Stack(
                                  children: [
                                    QrImageView(
                                      data: selectedTicket!.ticketId,
                                      size: 220,
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3),
                                          ),
                                          color:
                                              selectedTicket!.ticketStatus ==
                                                      'active'
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                        child: Text(
                                          selectedTicket!.ticketStatus,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : SizedBox(),

                        SizedBox(height: 5),
                        Text('Tunjukan QR ini ke petugas untuk masuk'),
                        SizedBox(height: 15),
                        Divider(),
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.account_circle_rounded,
                                  size: 35,
                                ),
                                title: Text(order.customerName),
                                subtitle: Text(
                                  order.createdAt.toLocal().toString(),
                                ),
                              ),
                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.support_agent_rounded),
                                key: 'Nomor order',
                                value: order.orderId,
                              ),

                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.date_range_outlined),
                                key: 'Waktu kunjungan',
                                value: order.visitDate.toLocal().toString(),
                              ),

                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.payment_outlined),
                                key: 'Payment metode',
                                value: 'Qris',
                              ),

                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.shopping_cart_outlined),
                                key: 'Quantity',
                                value: order.quantity.toString(),
                              ),

                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.confirmation_num_outlined),
                                key: 'Harga 1 Tiket',
                                value: 'Rp. ${order.price}',
                              ),

                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.attach_money_outlined),
                                key: 'Subtotal',
                                value: 'Rp. ${order.price * order.quantity}',
                              ),

                              Divider(),

                              _buildPaymentItem(
                                icon: Icon(Icons.money_outlined),
                                key: 'Fee',
                                value: 'Rp. ${order.fee}',
                              ),
                              Divider(),
                              _buildPaymentItem(
                                icon: Icon(Icons.money_outlined),
                                key: 'Total',
                                value: 'Rp. ${order.total}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : SizedBox(),
          ),
        ),
      ),
    );
  }
}

Widget _buildPaymentItem({
  required Icon icon,
  required String key,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 5),
            Text(key, style: TextStyle(fontSize: 14)),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}


// style: ListTileStyle.drawer,
//     leading: Text(key, style: TextStyle(fontSize: 14)),
//     trailing: Text(
//       value,
//       style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//     ),

// GestureDetector(
//                                     child: QrImageView(
//                                       data: order.tickets[index].ticketId,
//                                       size: 150,
//                                       errorCorrectionLevel:
//                                           QrErrorCorrectLevel.H,
//                                     ),
//                                   );