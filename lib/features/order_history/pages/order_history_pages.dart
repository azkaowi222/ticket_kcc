import 'package:flutter/material.dart';

class OrderHistoryPages extends StatelessWidget {
  const OrderHistoryPages({super.key});
  final String status = 'Completed';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,

            child: ListTile(
              leading: Icon(Icons.confirmation_num_outlined),
              title: Text(
                'Ticket Wisata',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '25 Oct 2026. 02:33PM',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 2.5),
                  Text(
                    'Rp. 150000 x2 item',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),

              trailing: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      status == 'Completed'
                          ? Color.fromARGB(255, 217, 253, 232)
                          : status == 'Pending'
                          ? Color.fromARGB(255, 255, 244, 217)
                          : Color.fromARGB(255, 254, 233, 233),
                ),
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 76, 143, 105),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




// Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Icon(Icons.confirmation_num_outlined),
//                 ),
//                 SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Ticket Wisata',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       '25 Oct 2026. 02:33PM',
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
                    // Text(
                    //   'Rp. 150000 x2 item',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 16,
                    //   ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
          