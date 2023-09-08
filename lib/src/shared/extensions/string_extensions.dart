import 'package:flutter_gen/gen_l10n/app_localizations.dart';
extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPassword() {
    return RegExp(r'(^(?=(.*[a-z]){3,})(?=(.*[A-Z]){1,})(?=(.*[0-9]){1,})(?=(.*[!@#$%^&*()\-__+.]){1,}).{8,}$)')
        .hasMatch(this);
  }

  String isDepositOrWithdraw(AppLocalizations appLoc) {
    switch (this) {
      case 'DEPOSIT':
        return appLoc.labelDetailDeposit;
      case 'WITHDRAW':
        return appLoc.labelDetailWithdraw;
      case 'YIELD':
        return appLoc.labelDetailYield;
    }
    return '';
  }

  bool hasUpperCase() {
    return contains(RegExp(r'[A-Z]'));
  }

  bool hasLowerCase() {
    return contains(RegExp(r'[a-z]'));
  }

  bool hasDigits() {
    return contains(RegExp(r'[0-9]'));
  }

  bool hasSpecialChar() {
    return contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  bool isValidWalletAddress() {
    return RegExp(r'^(0x)[0-9a-fA-F]{40}$').hasMatch(this);
  }


}
