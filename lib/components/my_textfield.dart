import 'package:flutter/material.dart';

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
      width: size.width * 0.8,
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
                  borderSide: BorderSide(color: Colors.indigo.withOpacity(0.3))
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 82, 81, 81)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide( color: Colors.blue)
                ),
                hintText: _showHint ? widget.hintText : null,
                hintStyle: const TextStyle(color: Colors.blue),
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: Colors.blue),
                prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.blue) : null
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