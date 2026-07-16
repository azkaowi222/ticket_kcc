import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/providers/ticket_provider.dart';

class ScannerResultDetails extends StatefulWidget {
  final String ticketId;
  const ScannerResultDetails({super.key, required this.ticketId});

  @override
  State<ScannerResultDetails> createState() => _ScannerResultDetailsState();
}

class _ScannerResultDetailsState extends State<ScannerResultDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ticketIdController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _orderDateController = TextEditingController();
  final TextEditingController _ticketStatusController = TextEditingController();

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      context.loaderOverlay.show();
      final _ticketProvider = context.read<TicketProvider>();
      await _ticketProvider.getTicketDetails(widget.ticketId);
      if (_ticketProvider.ticketModel != null) {
        _ticketIdController.text = _ticketProvider.ticketModel!.ticketId;
        _customerNameController.text =
            _ticketProvider.ticketModel!.customerName!;
        _orderDateController.text =
            _ticketProvider.ticketModel!.orderDate.toLocal().toString();
        _ticketStatusController.text =
            _ticketProvider.ticketModel!.ticketStatus;
      }
      if (mounted) {
        if (context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TicketProvider _ticket = context.watch<TicketProvider>();

    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tiket detail'),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                !_ticket.isLoading
                    ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade700),
                            controller: _ticketIdController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(),
                              filled: true,
                              fillColor: Colors.grey.shade400,
                              helperText: 'ID Tiket',

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade700),
                            controller: _customerNameController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(),
                              filled: true,
                              fillColor: Colors.grey.shade400,
                              helperText: 'Nama Pemesan',

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade700),
                            controller: _orderDateController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(),
                              filled: true,
                              fillColor: Colors.grey.shade400,
                              helperText: 'Waktu Pemesanan',

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade700),
                            controller: _ticketStatusController,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            decoration: InputDecoration(
                              constraints: BoxConstraints(),
                              filled: true,
                              fillColor: Colors.grey.shade400,
                              helperText: 'Status',

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed:
                                _ticket.ticketModel!.ticketStatus == 'active'
                                    ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        final int statusCode = await context
                                            .read<TicketProvider>()
                                            .updateTicket(widget.ticketId);

                                        if (context.mounted) {
                                          if (context.loaderOverlay.visible) {
                                            context.loaderOverlay.hide();
                                          }
                                          if (statusCode != 200) {
                                            print('statusCode: $statusCode');

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '❌ Gagal menggunakan tiket',
                                                  ),
                                                ),
                                              );
                                          } else {
                                            print(
                                              'statusCode: $statusCode sucees',
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '✅ Tiket berhasil digunakan',
                                                  ),
                                                ),
                                              );
                                            Navigator.pop(context);
                                          }
                                        }
                                      }
                                    }
                                    : null,
                            child: Text(
                              _ticket.ticketModel!.ticketStatus == 'used'
                                  ? 'Tiket sudah digunakan'
                                  : 'Gunakan Tiket',
                            ),
                          ),
                        ],
                      ),
                    )
                    : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
