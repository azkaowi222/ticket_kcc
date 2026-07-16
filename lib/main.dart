import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/features/account/pages/account_page.dart';
import 'package:ticket_kcc/features/admin/pages/admin_pages.dart';
import 'package:ticket_kcc/features/auth/pages/login_page.dart';
import 'package:ticket_kcc/features/home/pages/home_page.dart';
import 'package:ticket_kcc/features/order/order_history/order_history_pages.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/navigation_provider.dart';
import 'package:ticket_kcc/providers/order_provider.dart';
import 'package:ticket_kcc/providers/ticket_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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

  final Widget spinkit = SpinKitThreeInOut(color: Colors.white, size: 25);

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: LoaderOverlay(
        overlayWidgetBuilder: (_) {
          return spinkit;
        },
        child: Scaffold(
          floatingActionButton:
              nav.currentIndex == 1
                  ? FloatingActionButton(
                    // mini: true,
                    backgroundColor: Colors.white,

                    child: Icon(Icons.refresh_outlined),
                    onPressed: () async {
                      final String? customerName =
                          context.read<AuthProvider>().customerName;
                      await context.read<OrderProvider>().getOrderHistory(
                        customerName,
                        context.read<AuthProvider>().currentUser?.username ==
                            'guest',
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Riwayat berhasil diperbaharui'),
                          ),
                        );
                      }
                    },
                  )
                  : null,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar:
              context.watch<AuthProvider>().isLogin &&
                      !context.watch<AuthProvider>().isAdmin
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
              nav.currentIndex == 0 && !context.watch<AuthProvider>().isAdmin
                  ? AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor:
                        context.watch<AuthProvider>().isLogin
                            ? Color.fromARGB(255, 39, 54, 211)
                            : Colors.white,
                  )
                  : nav.currentIndex == 1
                  ? AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(
                      'Riwayat Pemesanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                  )
                  : null,
          body: SafeArea(
            child:
                context.watch<AuthProvider>().isLogin &&
                        !context.watch<AuthProvider>().isAdmin
                    ? pages[nav.currentIndex]
                    : context.watch<AuthProvider>().isLogin &&
                        context.watch<AuthProvider>().isAdmin
                    ? const AdminPages()
                    : const LoginPage(),
          ),
        ),
      ),
    );
  }
}
