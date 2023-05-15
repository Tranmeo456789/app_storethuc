import 'package:flutter/material.dart';
import 'package:app_storethuc/shared/fade_animation.dart';

class TxtButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const TxtButton({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 1,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2697FF),
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0))),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
