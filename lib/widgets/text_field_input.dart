import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  const TextFieldInput({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final inputBoarder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBoarder,
        focusedBorder: inputBoarder,
        enabledBorder: inputBoarder,
        filled: true,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
