import 'package:alcancia/src/shared/models/transaction.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';

class AlcanciaTransactionItem extends StatelessWidget {
  Transaction txn;
  AlcanciaTransactionItem({Key? key, required this.txn}) : super(key: key);

  String getImageType(String txnType) {
    if (txnType == "WITHDRAW") {
      return "lib/src/resources/images/withdraw.svg";
    }
    return "lib/src/resources/images/deposit.svg";
  }

  @override
  Widget build(BuildContext context) {
    var txtTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1F318C)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                getImageType(txn.type),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${txn.type} ${txn.sourceAsset}",
                      style: txtTheme.bodyText2,
                    ),
                    Text(txn.createdAt),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$${txn.sourceAmount.toStringAsFixed(2)}"),
                    Text("${txn.amount.toStringAsFixed(2)} ${txn.targetAsset}"),
                  ],
                ),
              ),
              SvgPicture.asset(
                "lib/src/resources/images/white_arrow_right.svg",
              )
            ],
          ),
        ],
      ),
    );
  }
}
