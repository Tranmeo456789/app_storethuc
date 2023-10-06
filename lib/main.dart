import 'package:app_storethuc/module/checkout/checkout_page.dart';
import 'package:app_storethuc/module/home/home_page.dart';
import 'package:app_storethuc/module/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:app_storethuc/module/signin/signin_page.dart';
import 'package:app_storethuc/module/signup/signup_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(primaryColor: Colors.amber),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const SignInPage(),
        '/register': (context) => const SignUpPage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}
