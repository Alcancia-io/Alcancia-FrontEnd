import 'package:alcancia/src/screens/transaction_detail/transaction_detail_controller.dart';
import 'package:alcancia/src/shared/components/deposit_info_item.dart';
import 'package:alcancia/src/shared/extensions/datetime_extensions.dart';
import 'package:alcancia/src/shared/extensions/type_extensions.dart';
import 'package:alcancia/src/shared/models/bank_info_item.dart';
import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:alcancia/src/shared/provider/alcancia_providers.dart';
import 'package:flutter/material.dart';
import 'package:alcancia/src/screens/transaction_detail/components/transaction_detail_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../resources/colors/colors.dart';
import '../../shared/models/transaction_model.dart';

class TransactionDetail extends ConsumerWidget {
  TransactionDetail({Key? key, required this.txn}) : super(key: key);
  final Transaction txn;

  final controller = TransactionDetailController();

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
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
                  if (txn.status == TransactionStatus.pending) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(thickness: 1,),
                    ),
                    BankInfo(appLoc),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red)
                          ),
                          onPressed: () async {
                            try {
                              await controller.cancelTransaction(id: txn.transactionID);
                              context.pop();
                            } catch (e) {
                              Fluttertoast.showToast(msg: appLoc.errorSomethingWentWrong, backgroundColor: Colors.red, textColor: Colors.white70);
                            }
                          },
                          child: Text(appLoc.buttonCancel),
                        ),
                      ),
                    )
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

  Widget BankInfo(AppLocalizations appLoc) {
    final info =
        txn.sourceAsset == 'MXN' ? AccountInfo.MXNInfo : AccountInfo.DOPInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DepositInfoItem(
          title: appLoc.labelBank,
          subtitle: info.bank,
          padding: EdgeInsets.only(bottom: 18),
        ),
        DepositInfoItem(
          title: appLoc.labelBeneficiary,
          subtitle: info.beneficiary,
          supportsClipboard: true,
          padding: EdgeInsets.only(bottom: 18),
        ),
        if (info.rnc != null) ...[
          DepositInfoItem(
            title: appLoc.labelRNC,
            subtitle: info.rnc!,
            supportsClipboard: true,
            padding: EdgeInsets.only(bottom: 18),
          ),
        ],
        if (info.accountNumber != null) ...[
          DepositInfoItem(
            title: appLoc.labelAccountNumber,
            subtitle: info.accountNumber!,
            supportsClipboard: true,
            padding: EdgeInsets.only(bottom: 18),
          ),
        ],
        if (info.clabe != null) ...[
          DepositInfoItem(
            title: appLoc.labelCLABE,
            subtitle: info.clabe!,
            supportsClipboard: true,
            padding: EdgeInsets.only(bottom: 18),
          ),
        ],
      ],
    );
  }
}
