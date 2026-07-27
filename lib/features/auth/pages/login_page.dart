import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/auth/pages/signup_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

// --- CONSTANT COLORS ---
const Color kPrimaryColor = Color(0xFF500088); // Warna Ungu Tombol/Header
const Color kLabelColor = Color(0xFF6A1B9A); // Warna Ungu Label
const Color kErrorColor = Color(0xFFFF5252); // Warna Merah Forgot Password

// ==========================================
// 1. LOGIN PAGE
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> signInWithGoogle() async {
    context.loaderOverlay.show();
    try {
      final UserModel user =
          await context.read<AuthProvider>().processSignInWithGoogle();
      context.read<UserProvider>().setUser(user);
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
    return Container(
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // --- Header ---
            const Text(
              "Hi, Selamat Datang! 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Hello again, you've been missed!",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // --- Form ---
            const CustomLabel(text: "Email"),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "johndoe@gmail.com",
                    controller: _emailController,
                  ),

                  const SizedBox(height: 20),

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

            // --- Remember Me & Forgot Password ---
            const SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: kPrimaryColor,
                    onChanged: (val) => setState(() => _rememberMe = val!),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Ingat saya",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Text(
                  "Lupa Password",
                  style: TextStyle(
                    color: kErrorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- Login Button ---
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
                  if (formKey.currentState!.validate()) {
                    context.loaderOverlay.show();

                    final UserModel? _user = await context
                        .read<AuthProvider>()
                        .fetchLogin(
                          _emailController.text,
                          _passwordController.text,
                        );
                    if (context.mounted) {
                      context.read<UserProvider>().setUser(_user);
                    }

                    if (_user == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email atau password salah')),
                        );
                        if (context.loaderOverlay.visible) {
                          context.loaderOverlay.hide();
                        }
                      }
                    } else {
                      if (context.mounted) {
                        if (context.loaderOverlay.visible) {
                          context.loaderOverlay.hide();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login berhasil")),
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- Divider ---
            // const OrWithDivider(),
            // const SizedBox(height: 20),

            // // --- Social Buttons ---
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () {},
            //         style: ButtonStyle(
            //           padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
            //           shape: WidgetStatePropertyAll(
            //             ContinuousRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(20)),
            //             ),
            //           ),

            //           backgroundColor: WidgetStatePropertyAll(kPrimaryColor),
            //         ),
            //         icon: Icon(Icons.g_mobiledata_sharp, color: Colors.white),
            //         label: Text(
            //           'Google',

            //           style: TextStyle(color: Colors.white),
            //         ),
            //         iconAlignment: IconAlignment.end,
            //       ),
            //     ),
            //   ],
            // ),

            // const SizedBox(height: 50),

            // --- Footer ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            const OrWithDivider(),
            SizedBox(height: 15),
            ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: signInWithGoogle,
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
                    'Login dengan Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                context.read<UserProvider>().setUserGuest();
                context.read<AuthProvider>().clearCustomer();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue without Login',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. SIGN UP PAGE
// ==========================================

// ==========================================
// WIDGETS REUSABLE (Agar kode rapi)
// ==========================================

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: kLabelColor, // Ungu sesuai gambar
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool isObscure;
  final bool isPhone;
  final VoidCallback? onVisibilityToggle;
  final String? prefixText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.isObscure = false,
    this.isPhone = false,
    this.onVisibilityToggle,
    this.prefixText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty && !isPhone) {
          return '${isPassword ? 'Password' : 'Email'} Harus Diisi';
        }
        if (!isPassword) {
          if (!value.contains('@') && !isPhone) {
            return 'Email Tidak Valid';
          }
        }
        return null;
      },
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: isPassword ? isObscure : false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // Menangani Prefix (+855)
        prefixIcon:
            prefixText != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 10),
                  child: SizedBox(
                    width: 50, // Lebar fixed untuk prefix
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        prefixText!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
                : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

        // Menangani Icon Mata (Password)
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.black54,
                    size: 20,
                  ),
                  onPressed: onVisibilityToggle,
                )
                : null,

        // Border Style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor),
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

class SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}
