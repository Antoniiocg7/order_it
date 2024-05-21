import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? color;
  final LinearGradient? linearGradient;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.linearGradient,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * 0.065,
        width: size.width * 0.75,
        /*padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),*/
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.inversePrimary,
            gradient: linearGradient,
            borderRadius: BorderRadius.circular(100)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
