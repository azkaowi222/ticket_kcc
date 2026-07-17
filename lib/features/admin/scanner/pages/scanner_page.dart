import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_kcc/features/admin/scanner/pages/scanner_result_details.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _hasScanned = false;

  final ImagePicker _imagePicker = ImagePicker();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  Future<void> _onPickImage() async {
    debugPrint('pick image click');
    final XFile? _image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (_image != null) {
      final InputImage _inputImage = InputImage.fromFilePath(_image.path);
      final _barcodes = await _barcodeScanner.processImage(_inputImage);
      final String? _rawResult = _barcodes.first.rawValue;
      _hasScanned = true;
      if (_rawResult != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScannerResultDetails(ticketId: _rawResult),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: MobileScannerController(
            autoZoom: true,
            cameraResolution: Size(200, 200),
            invertImage: true,
          ),
          onDetect: (BarcodeCapture result) {
            if (_hasScanned) return;
            final String? qrText = result.barcodes[0].rawValue;
            _hasScanned = true;
            if (qrText != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScannerResultDetails(ticketId: qrText),
                ),
              );
            }
          },
        ),
        CustomPaint(size: Size.infinite, painter: ScannerOverlayPainter()),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        Positioned(
          bottom: 120,
          left: 0,
          right: 0,
          child: const Text(
            "Arahkan QR ke dalam kotak",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: GestureDetector(
            onTap: _onPickImage,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.photo_library_sharp,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);

    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    const double scanSize = 250;
    final Rect hole = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanSize,
      height: scanSize,
    );

    path.addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(16)));

    path.fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
