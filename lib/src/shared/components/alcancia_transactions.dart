import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AlcanciaTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const AlcanciaTransactions({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("these are the transactions");
    // print(transactions[0]!['createdAt']);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: Text(
                "Actividad",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text("Ver mas"),
          ],
        ),
        // Column(
        //   children: [for (var item in transactions) Text(item.createdAt)],
        // )

        // Padding(
        //   padding: const EdgeInsets.only(bottom: 24),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Row(
        //         children: [
        //           SvgPicture.asset("lib/src/resources/images/deposit.svg"),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 6),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: const [
        //                 Text(
        //                   "Retiro UST",
        //                   style: TextStyle(fontSize: 13),
        //                 ),
        //                 Text("2 Mar 2022"),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: const [
        //           Text("-\$15.26"),
        //           Text("0.01 UST"),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
