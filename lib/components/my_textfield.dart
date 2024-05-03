import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none, // Elimina la línea inferior del texto
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black)
            ),
          ),
          SizedBox(height: 2), // Espacio entre el texto y el contenedor azul
          FadeInLeft(
            delay: const Duration(milliseconds: 1100),
            child: Container(
              width: 220,
              height: 2,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

}