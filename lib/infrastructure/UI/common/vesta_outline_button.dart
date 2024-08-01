import 'package:flutter/material.dart';

class VestaOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool enabled;

  const VestaOutlineButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
          ),
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
        onPressed: enabled ? onPressed : null,
        child: Text(
          buttonText,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white.withOpacity(0.5),
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
