import 'package:flutter/material.dart';

class TransactionDetailItem extends StatelessWidget {
  final String leftText;
  final String rightText;

  const TransactionDetailItem(
      {Key? key, required this.leftText, required this.rightText})
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
            style: TextStyle(fontSize: 15),
          ),
          Text(rightText),
        ],
      ),
    );
  }
}
