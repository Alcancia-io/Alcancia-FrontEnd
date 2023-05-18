import 'package:alcancia/src/shared/components/alcancia_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlcanciaCopyToClipboard extends StatelessWidget {
  final String textToCopy;
  final String displayText;

  const AlcanciaCopyToClipboard({
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
