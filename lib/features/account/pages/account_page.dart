import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: deviceHeight * 0.5,
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
                  Text('Arman Maulana'),
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            height: 400,
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
                      hintText: 'maximkelly659@gmail.com',
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
                      hintText: '081380486807',
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
                      onPressed: () {},
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
