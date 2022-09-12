import 'package:alcancia/src/shared/extensions/string_extensions.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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
    // return ListTile(
    //   title: Text("${txn.type} ${txn.sourceAsset}"),
    //   subtitle: Text(txn.createdAt),
    //   onTap: () {
    //     context.push('/transaction_detail', extra: txn);
    //   },
    //   leading: SvgPicture.asset(getImageType(txn.type)) ,
    //   trailing: SvgPicture.asset("lib/src/resources/images/white_arrow_right.svg"),
    // );
    return InkWell(
    customBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)),
    onTap: () {
          context.push('/transaction_detail', extra: txn);
        },
    child: Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12,left: 12,right: 12 ),
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
                      "${txn.type.isDepositOrWithdraw()} ${txn.sourceAsset}",
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
    )
    );
  }
}
