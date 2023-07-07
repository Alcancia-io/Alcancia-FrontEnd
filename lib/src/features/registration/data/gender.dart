import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Gender { woman, man, nonbinary, other }

extension GenderString on Gender? {
  String string(AppLocalizations appLoc) {
    switch (this) {
      case Gender.man:
        return appLoc.labelGenderMan;
      case Gender.woman:
        return appLoc.labelGenderWoman;
      case Gender.nonbinary:
        return appLoc.labelGenderNonbinary;
      case Gender.other:
        return appLoc.labelGenderOther;
      case null:
        return appLoc.labelSelectOption;
    }
  }
}
