import 'package:flutter/material.dart';
//import 'package:app_storethuc/shared/style/btn_style.dart';

// ignore: unused_import
import '../app_color.dart';

class NormalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final bool enable;
  const NormalButton(
      {super.key, this.onPressed, required this.title, required this.enable});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          enable ? Colors.blue : const Color.fromARGB(255, 137, 191, 235),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          title!,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
