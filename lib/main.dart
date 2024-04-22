import 'package:flutter/material.dart';
import 'package:order_it/auth/login_or_register.dart';
import 'package:order_it/models/restaurant.dart';
import 'package:order_it/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  MultiProvider(providers: [
      // THEME PROVIDER
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),

      // RESTAURANT PROVIDER
      ChangeNotifierProvider(
        create: (context) => Restaurant()
      ),

    ],
    child: const MyApp()
  )
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const LoginOrRegister(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      
    );
  }
}