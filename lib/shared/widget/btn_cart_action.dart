import 'package:flutter/material.dart';

class BtnCartAction extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  final VoidCallback onPressed;

  const BtnCartAction(
      {super.key, required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        ),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style:
                  const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
