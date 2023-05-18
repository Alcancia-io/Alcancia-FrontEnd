import 'package:flutter/material.dart';

class TransactionDetailItem extends StatelessWidget {
  final String leftText;
  final String? rightText;
  final Widget? rightIcon;

  const TransactionDetailItem(
      {Key? key, required this.leftText, this.rightText, this.rightIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: const TextStyle(fontSize: 15),
          ),
          if (rightIcon != null) ... [
            rightIcon!,
          ] else if (rightText != null)... [
            Text(rightText!),
          ],
        ],
      ),
    );
  }
}
