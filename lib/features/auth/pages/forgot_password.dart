import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/auth/pages/login_page.dart';
import 'package:ticket_kcc/features/auth/pages/reset_password.dart';
import 'package:ticket_kcc/features/auth/pages/verify_email_page.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';

// Sesuaikan import dengan lokasi widget milikmu
// import 'package:ticket_kcc/widgets/custom_label.dart';
// import 'package:ticket_kcc/widgets/custom_text_field.dart';
// import 'package:ticket_kcc/pages/reset_password_page.dart';

const Color kPrimaryColor = Color(0xFF500088);
const Color kLabelColor = Color(0xFF6A1B9A);
const Color kErrorColor = Color(0xFFFF5252);

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Widget spinkit = const SpinKitThreeInOut(color: Colors.white, size: 25);

  Future<void> _sendForgotPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    context.loaderOverlay.show();

    try {
      final bool isSuccess = await context
          .read<AuthProvider>()
          .processResendOtp(email: _emailController.text.trim());

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kode OTP telah dikirim')));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => VerifyEmailPage(
                  email: _emailController.text.trim(),
                  username: _emailController.text.split('@')[0],
                  isFromForgotPass: true,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mengirim kode OTP')));
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted && context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Jangan khawatir. Masukkan email yang '
                    'terdaftar untuk mengatur ulang password Anda.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 35),

                  const CustomLabel(text: 'Email Address'),

                  const SizedBox(height: 8),

                  CustomTextField(
                    controller: _emailController,
                    hintText: 'johndoe@gmail.com',
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
                      onPressed: _sendForgotPassword,
                      child: const Text(
                        'Kirim Kode OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ingat password? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
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
        ),
      ),
    );
  }
}
