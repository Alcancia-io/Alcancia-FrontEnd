import 'package:alcancia/src/shared/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ToValue on RiskLevel {
  String toValue(AppLocalizations appLoc) {
    switch (this) {
      case RiskLevel.high:
        return appLoc.labelRiskHigh;
      case RiskLevel.medium:
        return appLoc.labelRiskMedium;
      case RiskLevel.low:
        return appLoc.labelRiskLow;
      default:
        return appLoc.unknown;
    }
  }
}
