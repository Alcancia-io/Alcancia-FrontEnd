import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TypeToString on TransactionType {
  String typeToString(AppLocalizations appLoc) {
    switch (this) {
      case TransactionType.deposit:
        return appLoc.labelDetailDeposit;
      case TransactionType.withdraw:
        return appLoc.labelDetailWithdraw;
      case TransactionType.p2p:
        return appLoc.labelDetailTransfer;
      case TransactionType.p2p_ext:
        return appLoc.labelDetailCryptoWithdrawal;
      case TransactionType.crypto_withdrawal:
        return appLoc.labelDetailCryptoWithdrawal;
      case TransactionType.unknown:
        return appLoc.unknown;
    }
  }
}
