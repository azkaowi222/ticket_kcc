import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/order/order_detail/order_detail.dart';
import 'package:ticket_kcc/models/order_history_model.dart';
import 'package:ticket_kcc/providers/order_provider.dart';

class OrderHistoryPages extends StatefulWidget {
  const OrderHistoryPages({super.key});

  @override
  State<OrderHistoryPages> createState() => _OrderHistoryPagesState();
}

class _OrderHistoryPagesState extends State<OrderHistoryPages> {
  final String status = 'completed';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await context.read<OrderProvider>().getOrderHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<OrderHistoryModel> orderHistories =
        context.watch<OrderProvider>().orderHistoryModels;
    return Padding(
      padding: EdgeInsets.all(8),
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<OrderProvider>().getOrderHistory();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Riwayat berhasil diperbaharui')),
            );
          }
        },
        child:
            orderHistories.isNotEmpty
                ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: orderHistories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print('order hisypry klik');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    OrderDetail(orderHistory: orderHistories[index]),
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
                                    orderHistories[index].orderStatus ==
                                            'success'
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
      ),
    );
  }
}





// Column(
//         children: [
//           Container(

//             width: double.infinity,
          
//             child:
                
//         ],
//       ),