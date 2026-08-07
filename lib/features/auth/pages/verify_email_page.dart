import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';

const Color kPrimaryColor = Color(0xFF500088); // Warna Ungu Tombol/Header
const Color kLabelColor = Color(0xFF6A1B9A); // Warna Ungu Label
const Color kErrorColor = Color(0xFFFF5252); // Warna Merah Forgot Password

class VerifyEmailPage extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final String? phone;

  const VerifyEmailPage({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    this.phone,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get otp {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp(BuildContext overlayContext) async {
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode OTP')),
      );
      return;
    }

    print('OTP: $otp');

    overlayContext.loaderOverlay.show();

    // Nanti panggil provider/API:
    // context.read<AuthProvider>().verifyEmailOtp(
    //   email: widget.email,
    //   otp: otp,
    // );
    // context.loaderOverlay.show();

    try {
      final bool isValidOtp = await context
          .read<AuthProvider>()
          .processVerifyEmail(email: widget.email, otp: int.parse(otp));
      if (!isValidOtp) {
        throw Exception('Otp tidak valid');
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Email berhasil diverifikasi')));
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception', ''))),
        );
      }
    } finally {
      if (context.mounted) {
        if (overlayContext.loaderOverlay.visible) {
          context.loaderOverlay.hide();
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Builder(
        builder: (overlayContext) {
          return Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),

            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verifikasi Email',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Kami telah mengirimkan kode verifikasi 6 digit ke ${widget.email}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _buildOtpField(index),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          _verifyOtp(overlayContext);
                        },
                        child: const Text(
                          'Verifikasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tidak menerima kode? ',
                          style: TextStyle(color: Colors.grey),
                        ),

                        GestureDetector(
                          onTap: () async {
                            print('Resend OTP');
                            try {
                              await context
                                  .read<AuthProvider>()
                                  .processResendOtp(email: widget.email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Email berhasil dikirim ulang ke ${widget.email}',
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll('Exception', ''),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Kirim Ulang',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],

        textAlign: TextAlign.center,

        keyboardType: TextInputType.number,

        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],

        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
        ),

        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }

          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
