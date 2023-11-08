import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../shared/components/alcancia_copy_clipboard.dart';

class TransactionDetailItem extends StatelessWidget {
  final String leftText;
  final String? rightText;
  final Widget? rightIcon;
  final bool supportsClipboard;
  final bool underlinedClipboard;
  const TransactionDetailItem({
    Key? key,
    required this.leftText,
    this.rightText,
    this.rightIcon,
    this.supportsClipboard = false,
    this.underlinedClipboard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: const TextStyle(fontSize: 15),
          ),
          if (rightIcon != null) ...[
            rightIcon!,
          ] else if (rightText != null) ...[
            if (supportsClipboard && underlinedClipboard) ...[
              AlcanciaCopyToClipboardText(
                displayText: "${leftText} ${appLoc.alertCopied.toLowerCase()}",
                textToCopy: rightText!,
              ),
            ] else ...[
              Text(
                rightText!,
                style: const TextStyle(fontSize: 15),
              ),
            ]
          ],
          if (supportsClipboard && !underlinedClipboard) ...[
            AlcanciaCopyToClipboardButton(
                displayText: "${leftText} ${appLoc.alertCopied.toLowerCase()}",
                textToCopy: rightText!),
          ]
        ],
      ),
    );
  }
}
