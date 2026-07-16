import 'package:flutter/material.dart';
import 'package:ticket_kcc/features/admin/home/pages/home_page.dart';
import 'package:ticket_kcc/features/admin/profile/pages/profile_page.dart';
import 'package:ticket_kcc/features/admin/scanner/pages/scanner_page.dart';

class AdminPages extends StatefulWidget {
  const AdminPages({super.key});

  @override
  State<AdminPages> createState() => _AdminPagesState();
}

class _AdminPagesState extends State<AdminPages> {
  final List<BottomNavigationBarItem> _bottomNavigationBarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
    BottomNavigationBarItem(
      icon: Icon(Icons.qr_code_2_rounded),
      label: "Scanner",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_rounded),
      label: "Profile",
    ),
  ];

  final List<Widget> _pages = [
    const HomePageAdmin(),
    const ScannerPage(),
    const ProfilePage(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomNavigationBarItem,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: _pages[_currentIndex],
        ),
      ),
    );
  }
}
