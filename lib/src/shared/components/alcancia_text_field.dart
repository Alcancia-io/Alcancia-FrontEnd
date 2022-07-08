import 'package:flutter/material.dart';

class LabeledTextFormField extends StatelessWidget {
  const LabeledTextFormField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.suffixIcon,
      this.obscure = false,
      this.autofillHints,
      this.inputType})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscure;
  final Icon? suffixIcon;
  final TextInputType? inputType;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        TextFormField(
          controller: controller,
          keyboardType: inputType,
          autofillHints: autofillHints,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
