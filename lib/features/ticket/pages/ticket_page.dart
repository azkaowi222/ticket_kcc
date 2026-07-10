import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_kcc/models/order_model.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/navigation_provider.dart';
import 'package:ticket_kcc/providers/order_provider.dart';
import 'package:ticket_kcc/providers/ticket_provider.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final List<int> progressTicket = [1, 0, 0];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final List<Tab> tabs = [
    Tab(text: 'Informasi Kunjungan'),
    Tab(text: 'Konfirmasi'),
  ];
  bool _isFormFilled = false;

  void setFormFilled(bool value) {
    _isFormFilled = value;
  }

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  @override
  Widget build(BuildContext context) {
    final TicketProvider ticketProvider = context.watch<TicketProvider>();
    final double deviceWidth = MediaQuery.of(context).size.width;
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 39, 54, 211),
          title: Text('Beli Tiket', style: TextStyle(color: Colors.white)),
          titleSpacing: 0,
          titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context);
              // context.read<TicketProvider>().setConfirmationPage(false);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  child: Stack(
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
                      ),
                      Positioned(
                        top: 100,
                        left: 20,
                        right: 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.normal,
                                ),
                              ],
                            ),
                            width: 300,
                            height: 400,
                            child: Form(
                              key: formKey,
                              child: DefaultTabController(
                                length: tabs.length,
                                child: Column(
                                  children: [
                                    TabBar(
                                      tabs: tabs,
                                      isScrollable:
                                          false, // penting biar seperti Google UI
                                      labelColor: Colors.black,
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor: Colors.blue,
                                      indicatorWeight: 3,
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          FormWidget(
                                            ticketProvider: ticketProvider,
                                            nameController: nameController,
                                            dateController: dateController,
                                            formKey: formKey,
                                            setFormFilled: setFormFilled,
                                          ),
                                          _isFormFilled
                                              ? ConfirmationPage(
                                                nameController: nameController,
                                                ticketProvider: ticketProvider,
                                              )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final TicketProvider ticketProvider;
  final TextEditingController nameController;
  const ConfirmationPage({
    super.key,
    required this.nameController,
    required this.ticketProvider,
  });

  void _showModernBottomSheet(
    BuildContext context, {
    required OrderModel order,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Penting: Agar tinggi bisa menyesuaikan konten & tidak terpotong
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24), // Memberikan efek melengkung di sudut atas
        ),
      ),
      builder: (context) {
        return Padding(
          // Padding tambahan agar konten tidak tertutup keyboard jika ada TextField
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize
                      .min, // Container akan menyesuaikan tinggi konten di dalamnya
              children: [
                // --- Drag Handle (Indikator garis kecil di bagian atas) ---
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24), // Jarak antara handle dan judul
                // --- Judul Konten ---
                const Text(
                  "Payment via QRIS",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Text(
                  "Nomor Order : ${order.orderId}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 14),
                QrImageView(
                  data: order.paymentNumber,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  size: 180,
                ),
                const SizedBox(height: 24),
                _paymentDetails(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Items',
                  body: 'Ticket wisata x${order.quantity}',
                ),
                _paymentDetails(
                  icon: Icons.payment_outlined,
                  title: 'Subtotal',
                  body: 'Rp. ${order.total} + ${order.fee} (fee)',
                ),
                _paymentDetails(
                  icon: Icons.money,
                  title: 'Total Pembayaran',
                  body: 'Rp. ${order.totalPayment}',
                ),
                const SizedBox(height: 24),

                // --- Tombol Aksi ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final nav = Provider.of<NavigationProvider>(
                        context,
                        listen: false,
                      );

                      Navigator.pop(context);
                      Navigator.pop(
                        context,
                      ); // Perintah untuk menutup Bottom Sheet
                      nav.goToHistory();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Tombol juga dibuat melengkung
                      ),
                    ),
                    child: const Text(
                      "Konfirmasi Pembayaran",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? date = ticketProvider.selectedDate;
    final String dayName = ticketProvider.dayName;
    final int jumlahTicket = ticketProvider.ticketQty;
    final num total = jumlahTicket * ticketProvider.ticketPrice;
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              Icon(Icons.date_range_outlined),
              SizedBox(width: 10),
              Text('$dayName, ${date!.year}-${date.month}-${date.day}'),
            ],
          ),
          const Divider(thickness: 1.5),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 10),
              Text(nameController.text),
            ],
          ),
          const Divider(thickness: 1.5),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.confirmation_num_outlined),
              SizedBox(width: 10),
              Text('${jumlahTicket.toString()} Tiket'),
            ],
          ),
          const Divider(thickness: 1.5),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.payment_outlined),
              SizedBox(width: 10),
              Text('Total Rp. $total'),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 39, 54, 211),
                ),
              ),
              onPressed: () async {
                context.loaderOverlay.show();

                final UserModel? user =
                    context.read<AuthProvider>().currentUser;
                final OrderModel order = await context
                    .read<OrderProvider>()
                    .placeOrder(
                      customerName: nameController.text,
                      customerPhone: user?.phone,
                      quantity: ticketProvider.ticketQty,
                      visitDate: ticketProvider.selectedDate!.toString(),
                    );
                if (context.mounted) {
                  if (context.loaderOverlay.visible) {
                    context.loaderOverlay.hide();
                  }
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(order.message)));
                  _showModernBottomSheet(context, order: order);
                }
              },
              child: Text('Pay', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  final TicketProvider ticketProvider;
  final TextEditingController nameController;
  final TextEditingController dateController;
  final GlobalKey<FormState> formKey;
  final void Function(bool value) setFormFilled;
  const FormWidget({
    super.key,
    required this.ticketProvider,
    required this.nameController,
    required this.dateController,
    required this.formKey,
    required this.setFormFilled,
  });

  @override
  Widget build(BuildContext context) {
    final int ticketPrice = ticketProvider.ticketPrice;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              fillColor: Colors.black,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              icon: Icon(Icons.calendar_month_outlined),
              suffixIcon: Icon(Icons.arrow_drop_down),
              suffixIconConstraints: BoxConstraints(),
              hintText: 'Pilih Tanggal Kunjungan',
            ),
            readOnly: true,
            onTap: () async {
              await ticketProvider.pickDate(context);
              if (ticketProvider.selectedDate != null) {
                final date = ticketProvider.selectedDate!;
                dateController.text =
                    '${ticketProvider.dayName}, ${date.day}/${date.month}/${date.year}';
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tanggal Kunjungan harus diisi';
              }
              return null;
            },
          ),
          SizedBox(height: 5),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nama Lengkap harus diisi';
              }
              return null;
            },
            controller: nameController,
            decoration: InputDecoration(
              fillColor: Colors.black,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5),
              ),

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              icon: Icon(Icons.person_outline_outlined),
              hintText: 'Nama Lengkap',
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.5),
                        ),

                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                        icon: Icon(Icons.confirmation_num_outlined),
                        hintText: 'Jumlah Tiket',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<TicketProvider>().ticketDecrement();
                            },
                            icon: const Icon(Icons.remove),
                          ),

                          Text(ticketProvider.ticketQty.toString()),

                          IconButton(
                            onPressed: () {
                              context.read<TicketProvider>().ticketIncrement();
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // const Spacer(),
            ],
          ),
          SizedBox(height: 5),
          Text(
            context.watch<TicketProvider>().selectedDate != null
                ? '*Harga Tiket Rp. $ticketPrice'
                : '*Pilih tanggal untuk melihat harga',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 39, 54, 211),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<TicketProvider>().setConfirmationPage(true);
                  setFormFilled(true);
                  DefaultTabController.of(context).animateTo(1);
                }
              },
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _paymentDetails({
  required IconData? icon,
  required String title,
  required String body,
}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 246, 246, 246),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 3),
                Text(body, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      const Divider(thickness: 1.5),
    ],
  );
}
