import 'package:flutter/material.dart';

class VestaOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  VestaOutlineButton({required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(100),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w400,
            height: 0.07,
            letterSpacing: 0.85,
          ),
        ),
      ),
    );
  }
}
