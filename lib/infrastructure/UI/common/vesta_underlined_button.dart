import 'package:flutter/material.dart';

class VestaUnderlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  const VestaUnderlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 17,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            decorationColor: color ?? Colors.white,
            letterSpacing: 0.85,
          ),
        ),
      ),
    );
  }
}
