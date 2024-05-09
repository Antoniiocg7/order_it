import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final Icon icon;

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
    return Padding(
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo.withOpacity(0.3)),
            ),
              hintText: _showHint ? widget.hintText : null,
              hintStyle: const TextStyle(color: Colors.black),
              labelText: widget.labelText,
              prefixIcon: widget.icon,
              labelStyle: const TextStyle( color: Colors.grey ),
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
    );
  }
}