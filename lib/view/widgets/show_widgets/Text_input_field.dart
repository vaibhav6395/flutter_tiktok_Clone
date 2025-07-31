import 'package:flutter/material.dart';
import 'package:tiktok_clonee/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isobscure;
  final IconData icon;
  const TextInputField({super.key, required this.controller, required this.labelText,  this.isobscure=false, required this.icon ,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color:Bordercolor)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color:Bordercolor)
        ),
      ),
      
      obscureText: isobscure,
    );
  }
}