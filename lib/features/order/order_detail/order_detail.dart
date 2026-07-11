import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/providers/order_provider.dart';

class OrderDetail extends StatelessWidget {
  final OrderHistoryModel orderHistory;
  const OrderDetail({super.key, required this.orderHistory});

  @override
  Widget build(BuildContext context) {
    final OrderModel? order = context.read<OrderProvider>().order;
    print('total payment: ${order?.orderId}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Order detail'),
        actions: [
          Text(
            orderHistory.orderStatus,
            style: TextStyle(
              fontSize: 16  ,
              fontWeight: FontWeight.bold,
              color:
                  orderHistory.orderStatus == 'success'
                      ? Color.fromARGB(255, 84, 143, 107)
                      : orderHistory.orderStatus == 'pending'
                      ? Color.fromARGB(255, 254, 141, 0)
                      : Color.fromARGB(255, 222, 151, 157),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QrImageView(
                            data: order.paymentNumber,
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
                            size: 200,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text('Tunjukan QR ini ke petugas untuk masuk'),
                      SizedBox(height: 15),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.account_circle_rounded, size: 35),
                        title: Text(orderHistory.customerName),
                        subtitle: Text(
                          orderHistory.createdAt.toLocal().toString(),
                        ),
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
                        value: orderHistory.quantity.toString(),
                      ),

                      Divider(),
                      _buildPaymentItem(
                        icon: Icon(Icons.confirmation_num_outlined),
                        key: 'Harga 1 Tiket',
                        value: 'Rp. ${orderHistory.price}',
                      ),

                      Divider(),
                      _buildPaymentItem(
                        icon: Icon(Icons.attach_money_outlined),
                        key: 'Subtotal',
                        value: 'Rp. ${orderHistory.total}',
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
                        value: 'Rp. ${order.totalPayment}',
                      ),
                    ],
                  )
                  : Center(child: CircularProgressIndicator()),
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