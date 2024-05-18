import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData? icon;

  const MyTextField({
    super.key, 
    required this.controller, 
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.icon
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  bool _showHint = true;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: widget.controller,
              obscureText: widget.obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(255, 82, 81, 81)),
                  borderRadius: BorderRadius.circular(18)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide( color: Colors.grey),
                  borderRadius: BorderRadius.circular(18)

                ),
                hintText: _showHint ? widget.hintText : null,
                hintStyle: const TextStyle(color: Colors.grey),
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.lightGreen) : null
              ),
              onTap: () {
                setState(() {
                  _showHint = false;
                });
              },
              onChanged: (value) {
                setState(() {
                  _showHint = value.isEmpty;
                });
              },
            ),
          ],
        ),
      )
    );
  }
}