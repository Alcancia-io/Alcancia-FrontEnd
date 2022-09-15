import 'package:flutter/material.dart';

class LabeledTextFormField extends StatelessWidget {
  const LabeledTextFormField(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.suffixIcon,
      this.obscure = false,
      this.autofillHints,
      this.inputType,
      this.validator,
      this.padding})
      : super(key: key);

  final TextEditingController? controller;
  final String labelText;
  final bool obscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final Iterable<String>? autofillHints;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Column(
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
            validator: validator,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
