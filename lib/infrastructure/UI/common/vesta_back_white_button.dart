import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VestaWhiteBackButton extends StatelessWidget {
  final Function()? onPressed;
  const VestaWhiteBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        child: InkWell(
          onTap: () {
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svg/arrow_back.svg',
                semanticsLabel: 'Vesta Logo',
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Back",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffFFFFFF),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
