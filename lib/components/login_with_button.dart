import 'package:flutter/material.dart';

class LoginWithButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final Color? color;
  final String icon;
  final LinearGradient? linearGradient;

  const LoginWithButton({
    super.key,
    required this.onTap,
    this.text,
    this.color,
    this.linearGradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.11,
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.secondary,
            gradient: linearGradient,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: 1,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              icon,
              height: 30,
              width: 30,
            ),
          ],
        ),
      ),
    );
  }
}
