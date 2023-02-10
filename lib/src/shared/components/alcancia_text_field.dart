import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabeledTextFormField extends StatelessWidget {
  const LabeledTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.suffixIcon,
    this.obscure = false,
    this.autofillHints,
    this.textInputAction,
    this.inputType,
    this.validator,
    this.inputFormatters,
    this.onChanged,
    this.enabled,

  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final bool? enabled;

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
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
          ),
          validator: validator,
          style: Theme.of(context).textTheme.bodyText1,
          onChanged: onChanged,
          enabled: enabled,
        ),
      ],
    );
  }
}
