import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:ticket_kcc/providers/auth_provider.dart';
import 'package:ticket_kcc/providers/navigation_provider.dart';
import 'package:ticket_kcc/providers/order_provider.dart';
import 'package:ticket_kcc/providers/user_provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final UserProvider _userProvider;
  bool _initialLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProvider = context.read<UserProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.loaderOverlay.show();
      try {
        await _userProvider.getProfile();
      } catch (e, stack) {
        debugPrint('$e, $stack');
      } finally {
        if (mounted && context.loaderOverlay.visible) {
          context.loaderOverlay.hide();
          setState(() {
            _initialLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    if (_initialLoading) {
      return const SizedBox.shrink();
    }
    return _userProvider.user == null && _userProvider.isLoading
        ? SizedBox.shrink()
        : Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: deviceHeight,
              width: deviceWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 239, 246, 243),
                    Color.fromARGB(255, 196, 226, 213),
                  ],
                  begin: Alignment.topCenter,
                  stops: [0, 1],
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.5),
                      child: Text('AM'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user?.username ?? 'user'),
                      SizedBox(width: 5),
                      Icon(Icons.edit, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 220,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                // height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: Icon(Icons.edit),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                          suffixIconConstraints: BoxConstraints(minWidth: 40),
                          hintText: user?.email,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          suffixIcon: Icon(Icons.edit),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 40),
                          suffixIconConstraints: BoxConstraints(minWidth: 40),
                          hintText: user?.phone ?? '-',
                        ),
                      ),
                      SizedBox(height: 20),

                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.logout, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.red.shade400,
                            ),
                          ),
                          onPressed: () async {
                            print('logot di klik');
                            context.loaderOverlay.show();
                            context.read<NavigationProvider>().goToHome();
                            context
                                .read<OrderProvider>()
                                .guestOrderHistory
                                .clear();
                            await context.read<AuthProvider>().processLogout();
                            if (context.mounted) {
                              if (context.loaderOverlay.visible) {
                                context.loaderOverlay.hide();
                              }
                            }
                          },
                          label: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
  }
}
