import 'package:flutter/material.dart';
import 'package:order_it/pages/login_page.dart';
import 'package:order_it/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // INITIALLY, SHOW LOGIN PAGE
  bool showLoginPage = true;

  // TOGGLE BETWEEN LOGIN AND REGISTER PAGE
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen();
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
