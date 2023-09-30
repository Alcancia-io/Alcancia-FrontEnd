import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'alcancia_copy_clipboard.dart';

class DepositInfoItem extends StatelessWidget {
  const DepositInfoItem(
      {Key? key,
        required this.title,
        required this.subtitle,
        this.supportsClipboard = false,
        this.padding = const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 8.0),
        this.titleStyle,
        this.subtitleStyle,
      })
      : super(key: key);

  final String title;
  final String subtitle;
  final bool supportsClipboard;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: titleStyle ?? const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: subtitleStyle ?? Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (supportsClipboard) ...[
            AlcanciaCopyToClipboard(
                displayText: "${title} ${appLoc.alertCopied.toLowerCase()}",
                textToCopy: subtitle),
          ]
        ],
      ),
    );
  }
}
