import 'package:alcancia/src/shared/extensions/datetime_extensions.dart';
import 'package:alcancia/src/shared/extensions/type_extensions.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/features/transaction-detail/presentation/transaction_detail_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../resources/colors/colors.dart';
import '../../../shared/models/transaction_model.dart';

class TransactionDetail extends ConsumerWidget {
  const TransactionDetail({Key? key, required this.txn}) : super(key: key);
  final Transaction txn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(18),
              height: 630,
              decoration: BoxDecoration(
                color: ctx.brightness == Brightness.dark
                    ? alcanciaCardDark2
                    : alcanciaCardLight2,
                borderRadius: const BorderRadius.all(
                  Radius.circular(11),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 48, top: 8),
                    child: Text(
                      appLoc.labelActivityDetail,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TransactionDetailItem(
                    leftText: appLoc.labelDate,
                    rightText: txn.createdAt.formattedLocalString(),
                  ),
                  TransactionDetailItem(
                    leftText: appLoc.labelTransactionId,
                    rightText: txn.transactionID
                        .substring(0, txn.transactionID.indexOf('-')),
                  ),
                  if (txn.type == TransactionType.deposit) ...[
                    TransactionDetailItem(
                      leftText: appLoc.labelDepositValue,
                      rightText: '\$${txn.sourceAmount?.toStringAsFixed(2)}',
                    ),
                  ] else if (txn.type == TransactionType.withdraw) ...[
                    TransactionDetailItem(
                      leftText: appLoc.labelWithdrawalValue,
                      rightText: '\$${txn.sourceAmount?.toStringAsFixed(2)}',
                    ),
                  ],
                  TransactionDetailItem(
                    leftText: appLoc.labelValueAsset(txn.targetAsset ?? ''),
                    rightText: '\$${txn.amount.toStringAsFixed(2)}',
                  ),
                  TransactionDetailItem(
                    leftText: appLoc.labelTransactionType,
                    rightText: txn.type.typeToString(appLoc),
                  ),
                  TransactionDetailItem(
                    leftText: appLoc.labelStatus,
                    rightIcon: txn.iconForTxnStatus(user.id),
                  ),
                  if (txn.status == "PENDING") ...[
                    TransactionDetailItem(
                      leftText: appLoc.labelClearedDate,
                      rightText: txn.clearedDate?.formattedLocalString(),
                    ),
                    TransactionDetailItem(
                      leftText: appLoc.labelNewBalance,
                      rightText: (txn.newBalance == null)
                          ? ''
                          : '\$${txn.newBalance?.toStringAsFixed(2)}',
                    ),
                    TransactionDetailItem(
                      leftText: appLoc.labelConversionRate,
                      rightText: txn.conversionRate?.toStringAsFixed(2),
                    ),
                    TransactionDetailItem(
                      leftText: appLoc.labelTransMethod,
                      rightText: (txn.method == "null" || txn.method!.isEmpty)
                          ? ''
                          : txn.method.toString(),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF4E76E5),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(appLoc.buttonClose),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
