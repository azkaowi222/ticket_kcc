import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider = context.read<AuthProvider>();
    return Column(
      children: [
        Text('ini profile page'),
        ElevatedButton(
          onPressed: () async {
            await _authProvider.processLogout();
            context.read<UserProvider>().clearUser();
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}
