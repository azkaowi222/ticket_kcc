import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/models/user_model.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

class AccountSettingsPage extends StatefulWidget {
  final UserModel? user;
  const AccountSettingsPage({super.key, required this.user});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController(text: widget.user!.email);
    _usernameController = TextEditingController(text: widget.user!.username);
    _phoneController = TextEditingController(text: widget.user!.phone);
  }

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      return Scaffold(body: SizedBox.shrink());
    }
    return LoaderOverlay(
      overlayWidgetBuilder: (progress) {
        return spinkit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pengaturan akun', style: TextStyle(color: Colors.black)),
          titleSpacing: 0,
          titleTextStyle: TextStyle(fontSize: 20),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Usename Harus Diisi';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: widget.user!.username,
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Harus Diisi';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: widget.user!.email,
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20),

                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: widget.user!.phone,
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: '******',
                        helperText:
                            'Biarkan kosong jika tidak ingin merubah password',
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            widget.user?.username == 'guest'
                                ? null
                                : () async {
                                  final String _email = _emailController.text;
                                  final String _username =
                                      _usernameController.text;
                                  final String _phone = _phoneController.text;
                                  final String _password =
                                      _passwordController.text;
                                  if (_formkey.currentState!.validate()) {
                                    context.loaderOverlay.show();

                                    try {
                                      await context
                                          .read<UserProvider>()
                                          .editProfile(
                                            email: _email,
                                            username: _username,
                                            phone: _phone,
                                            password: _password,
                                          );
                                      if (context.mounted) {
                                        if (context.loaderOverlay.visible) {
                                          context.loaderOverlay.hide();
                                        }
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '✅ User berhasil diperbarui',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (context.mounted) {
                                        if (context.loaderOverlay.visible) {
                                          context.loaderOverlay.hide();
                                        }
                                      }

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString().replaceAll(
                                              'Exception',
                                              '',
                                            ),
                                          ),
                                        ),
                                      );
                                    } finally {
                                      if (context.mounted &&
                                          context.loaderOverlay.visible) {
                                        context.loaderOverlay.hide();
                                      }
                                    }
                                  }
                                },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            widget.user?.username == 'guest'
                                ? Colors.grey.shade400
                                : Colors.blue.shade400,
                          ),
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
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
    );
  }
}
