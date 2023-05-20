import 'package:flutter/material.dart';
import 'package:app_storethuc/data/spref/spref.dart';
import 'package:app_storethuc/shared/constant.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _startApp();
  }

  _startApp() {
    Future.delayed(
      const Duration(seconds: 1),
      () async {
        var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
        if (token != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
          return;
        }
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/sign-in');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo_book.png',
              width: 200,
              height: 200,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'App Store',
                style: TextStyle(fontSize: 30, color: Colors.brown[600]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
