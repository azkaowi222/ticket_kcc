import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/ticket/pages/ticket_page.dart';
import 'package:ticket_kcc/providers/ticket_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              height: 300,
              width: deviceWidth,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 39, 54, 211),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textRegularBold(
                    'Selamat Datang, ${user?.username.toUpperCase()}',
                    20,
                  ),
                  SizedBox(height: 10),
                  textRegular(
                    DateFormat(
                      'EEEE, d MMMM yyyy',
                      'id_ID',
                    ).format(DateTime.now()),
                    13,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -60,
              left: 20,
              right: 20,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<TicketProvider>()
                                  .setConfirmationPage(false);
                              context.read<TicketProvider>().setDate = null;
                              context.read<TicketProvider>().setTicketQty = 1;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TicketPage(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.qr_code_2_rounded,
                                  size: 30,
                                  color: Color.fromARGB(255, 39, 54, 211),
                                ),
                                SizedBox(height: 4),
                                Text('Ticket'),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 30,
                            color: Color.fromARGB(255, 39, 54, 211),
                          ),
                          SizedBox(height: 4),
                          Text('Hotel'),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.food_bank,
                            size: 30,
                            color: Color.fromARGB(255, 39, 54, 211),
                          ),
                          SizedBox(height: 4),
                          Text('Makan'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 70),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textRegular('Popular Programs', 16, color: Colors.black),
              Text('View all'),
            ],
          ),
        ),
      ],
    );
  }
}

Widget textRegularBold(
  String label,
  double fontSize, {
  Color? color = Colors.white,
}) {
  return Text(
    label,
    style: TextStyle(
      color: color ?? Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
    ),
  );
}

Widget textRegular(
  String label,
  double fontSize, {
  Color? color = Colors.white,
}) {
  return Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    ),
  );
}
