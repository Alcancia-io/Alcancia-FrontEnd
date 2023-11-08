import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlcanciaCopyToClipboardButton extends StatelessWidget {
  final String textToCopy;
  final String displayText;

  const AlcanciaCopyToClipboardButton({
    super.key,
    required this.displayText,
    required this.textToCopy,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: const Icon(
        Icons.copy,
        size: 20,
        color: Colors.blue,
      ),
      onTap: () async {
        Clipboard.setData(ClipboardData(text: textToCopy));
        ScaffoldMessenger.of(context).showSnackBar(
          alcanciaSnackBar(context, displayText),
        );
      },
    );
  }
}

class AlcanciaCopyToClipboardText extends StatelessWidget {
  final String textToCopy;
  final String displayText;
  final TextStyle? style;

  const AlcanciaCopyToClipboardText({
    super.key,
    required this.displayText,
    required this.textToCopy,
    this.style = const TextStyle(
      fontSize: 15,
      color: Colors.blueAccent,
      decoration: TextDecoration.underline,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        textToCopy,
        style: style,
      ),
      onTap: () async {
        Clipboard.setData(ClipboardData(text: textToCopy));
        ScaffoldMessenger.of(context).showSnackBar(
          alcanciaSnackBar(context, displayText),
        );
      },
    );
  }
}
