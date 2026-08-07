import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/auth/pages/login_page.dart';
import 'package:ticket_kcc/features/auth/pages/verify_email_page.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

// --- CONSTANT COLORS ---
const Color kPrimaryColor = Color(0xFF500088); // Warna Ungu Tombol/Header
const Color kLabelColor = Color(0xFF6A1B9A); // Warna Ungu Label
const Color kErrorColor = Color(0xFFFF5252); // Warna Merah Forgot Password

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isObscure = true;
  final bool _rememberMe = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  Future<void> signInOrSignUpWithGoogle() async {
    context.loaderOverlay.show();
    try {
      final UserModel user =
          await context.read<AuthProvider>().processSignInWithGoogle();
      context.read<UserProvider>().setUser(user);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception', ''))),
      );
    } finally {
      if (mounted && context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Back (Opsional, tapi biasanya ada di page kedua)
                const SizedBox(height: 10),
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Connect with your friends today!",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // --- Form Fields ---
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomLabel(text: "Email Address"),
                      CustomTextField(
                        controller: _emailController,
                        hintText: "johndoe@gmail.com",
                      ),
                      const SizedBox(height: 16),

                      const CustomLabel(text: "Nomer Handphone"),
                      // Khusus Phone Number ada prefix +855
                      CustomTextField(
                        isPhone: true,
                        controller: _phoneController,
                        hintText: "81234567890 (opsional)",
                        prefixText: "+62  ",
                      ),
                      const SizedBox(height: 16),

                      const CustomLabel(text: "Password"),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: "******",
                        isPassword: true,
                        isObscure: _isObscure,
                        onVisibilityToggle: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // --- Sign Up Button ---
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

                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        context.loaderOverlay.show();
                        try {
                          final Map<String, dynamic> data = await context
                              .read<AuthProvider>()
                              .fetchRegister(
                                email: _emailController.text,
                                password: _passwordController.text,
                                username: _emailController.text.split('@')[0],
                                phone: _phoneController.text,
                              );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(data['message'])),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => VerifyEmailPage(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      username:
                                          _emailController.text.split('@')[0],
                                      phone: _phoneController.text,
                                    ),
                              ),
                            );

                            if (context.loaderOverlay.visible) {
                              context.loaderOverlay.hide();
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().replaceAll('Exception', ''),
                                ),
                              ),
                            );
                          }
                        } finally {
                          if (context.mounted) {
                            if (context.loaderOverlay.visible) {
                              context.loaderOverlay.hide();
                            }
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const OrWithDivider(),
                const SizedBox(height: 15),

                ElevatedButton(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: signInOrSignUpWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon/google_icon.png',
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Daftar dengan Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // const OrWithDivider(),
                // const SizedBox(height: 20),

                // const Row(
                //   children: [
                //     Expanded(
                //       child: SocialButton(label: "GitHub", icon: Icons.code),
                //     ),
                //     SizedBox(width: 16),
                //     Expanded(
                //       child: SocialButton(
                //         label: "GitLab",
                //         icon: Icons.source,
                //         iconColor: Colors.orange,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sudah punya Akun ? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Kembali ke Login
                      },
                      child: const Text(
                        "Login",
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
    );
  }
}

class OrWithDivider extends StatelessWidget {
  const OrWithDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("Or", style: TextStyle(color: Colors.grey.shade500)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade400)),
      ],
    );
  }
}
