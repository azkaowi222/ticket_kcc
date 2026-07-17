import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/order/order_detail/order_detail.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/order_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

class OrderHistoryPages extends StatefulWidget {
  const OrderHistoryPages({super.key});

  @override
  State<OrderHistoryPages> createState() => _OrderHistoryPagesState();
}

class _OrderHistoryPagesState extends State<OrderHistoryPages> {
  bool _initialLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.loaderOverlay.show();
      try {
        if (context.read<UserProvider>().user?.username != 'guest') {
          await context.read<OrderProvider>().getOrderHistory();
        }
      } finally {
        if (mounted && context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
          setState(() {
            _initialLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<OrderHistoryModel> orderHistories =
        context.watch<OrderProvider>().orderHistoryModels;
    final bool isGuest =
        context.watch<UserProvider>().user?.username == 'guest';
    final OrderProvider _orderProvider = context.watch<OrderProvider>();

    // if (_initialLoading) {
    //   return SizedBox.shrink();
    // }
    return Padding(
      padding: EdgeInsets.all(8),
      child:
          orderHistories.isNotEmpty
              ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: orderHistories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => OrderDetail(
                                orderId: orderHistories[index].orderId,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.confirmation_num_outlined),
                        title: Text(
                          'Ticket Wisata',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderHistories[index].createdAt.toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2.5),
                            Text(
                              'Rp. ${orderHistories[index].price} x${orderHistories[index].quantity} item',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        trailing: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                orderHistories[index].orderStatus == 'success'
                                    ? Color.fromARGB(255, 217, 253, 232)
                                    : orderHistories[index].orderStatus ==
                                        'pending'
                                    ? Color.fromARGB(255, 255, 244, 217)
                                    : Color.fromARGB(255, 254, 233, 233),
                          ),
                          child: Text(
                            orderHistories[index].orderStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  orderHistories[index].orderStatus == 'success'
                                      ? Color.fromARGB(255, 84, 143, 107)
                                      : orderHistories[index].orderStatus ==
                                          'pending'
                                      ? Color.fromARGB(255, 254, 141, 0)
                                      : Color.fromARGB(255, 222, 151, 157),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : isGuest && _orderProvider.guestOrderHistory.isNotEmpty
              ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _orderProvider.guestOrderHistory.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => OrderDetail(
                                orderId:
                                    _orderProvider
                                        .guestOrderHistory[index]
                                        .orderId,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 14),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.confirmation_num_outlined),
                        title: Text(
                          'Ticket Wisata',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _orderProvider.guestOrderHistory[index].createdAt
                                  .toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 2.5),
                            Text(
                              'Rp. ${_orderProvider.guestOrderHistory[index].price} x${_orderProvider.guestOrderHistory[index].quantity} item',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        trailing: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                _orderProvider
                                            .guestOrderHistory[index]
                                            .orderStatus ==
                                        'success'
                                    ? Color.fromARGB(255, 217, 253, 232)
                                    : _orderProvider
                                            .guestOrderHistory[index]
                                            .orderStatus ==
                                        'pending'
                                    ? Color.fromARGB(255, 255, 244, 217)
                                    : Color.fromARGB(255, 254, 233, 233),
                          ),
                          child: Text(
                            _orderProvider.guestOrderHistory[index].orderStatus,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  _orderProvider
                                              .guestOrderHistory[index]
                                              .orderStatus ==
                                          'success'
                                      ? Color.fromARGB(255, 84, 143, 107)
                                      : _orderProvider
                                              .guestOrderHistory[index]
                                              .orderStatus ==
                                          'pending'
                                      ? Color.fromARGB(255, 254, 141, 0)
                                      : Color.fromARGB(255, 222, 151, 157),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
              : context.watch<OrderProvider>().isDetailLoading
              ? const SizedBox()
              : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                // shrinkWrap: true,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty-order.png',
                          // width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          // semanticLabel: 'usuwhuwdh',
                        ),
                        Text(
                          'Belum ada riwayat order',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: 5),

                  // Container(color: Colors.red, height: 20),
                ],
              ),
    );
  }
}
