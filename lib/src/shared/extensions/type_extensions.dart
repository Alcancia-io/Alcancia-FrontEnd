import 'package:alcancia/src/shared/models/transaction_input_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension TypeToString on TransactionType {
  String typeToString(AppLocalizations appLoc) {
    switch (name.toUpperCase()) {
      case 'DEPOSIT':
        return appLoc.labelDetailDeposit;
      case 'WITHDRAW':
        return appLoc.labelDetailWithdraw;
      case 'P2P':
        return appLoc.labelDetailTransfer;
    }
    return name;
  }
}
