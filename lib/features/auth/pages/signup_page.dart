import 'package:flutter/material.dart';
import 'package:ticket_kcc/features/auth/pages/login_page.dart';

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
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol Back (Opsional, tapi biasanya ada di page kedua)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              const SizedBox(height: 10),
              const Text(
                "Create an account",
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
              const CustomLabel(text: "Email Address"),
              const CustomTextField(hintText: "Enter your email"),
              const SizedBox(height: 16),

              const CustomLabel(text: "Phone Number"),
              // Khusus Phone Number ada prefix +855
              const CustomTextField(
                hintText: "Enter your phonenumber",
                prefixText: "+855  ",
              ),
              const SizedBox(height: 16),

              const CustomLabel(text: "Password"),
              CustomTextField(
                hintText: "Please Enter Your Password",
                isPassword: true,
                isObscure: _isObscure,
                onVisibilityToggle: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
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
                    "Remember Me",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: kErrorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
                  onPressed: () {},
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
                    "Already have an account ? ",
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
    );
  }
}
