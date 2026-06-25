import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/account/pages/account_page.dart';
import 'package:ticket_kcc/features/auth/pages/login_page.dart';
import 'package:ticket_kcc/features/home/pages/home_page.dart';
import 'package:ticket_kcc/features/order_history/pages/order_history_pages.dart';
import 'package:ticket_kcc/providers/navigation_provider.dart';
import 'package:ticket_kcc/providers/ticket_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        fontFamily: 'Gilroy',
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndexPage = 0;
  final List<BottomNavigationBarItem> navbarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Account',
    ),
  ];
  final List<Widget> pages = [
    const HomePage(),
    const OrderHistoryPages(),
    const AccountPage(),
  ];
  bool _isLogin = false;

  void setIsLogin(bool value) {
    setState(() {
      _isLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomNavigationBar:
            _isLogin
                ? BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  useLegacyColorScheme: false,
                  items: navbarItems,
                  enableFeedback: false,

                  currentIndex: nav.currentIndex,
                  onTap: (value) {
                    nav.setIndex(value);
                  },
                )
                : null,
        appBar:
            nav.currentIndex == 0
                ? AppBar(
                  backgroundColor:
                      _isLogin
                          ? Color.fromARGB(255, 39, 54, 211)
                          : Colors.white,
                )
                : nav.currentIndex == 1
                ? AppBar(
                  title: Text(
                    'Riwayat Pemesanan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                )
                : null,
        body: SafeArea(
          child:
              _isLogin
                  ? pages[nav.currentIndex]
                  : LoginPage(setIsLogin: setIsLogin),
        ),
      ),
    );
  }
}
