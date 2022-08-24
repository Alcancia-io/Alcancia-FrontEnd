import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Gender {
  woman, man, nonbinary, other
}

extension GenderString on Gender? {
  String get string {
    switch (this) {
      case Gender.man:
        return "Hombre";
      case Gender.woman:
        return "Mujer";
      case Gender.nonbinary:
        return "No Binario";
      case Gender.other:
        return "Otro";
      case null:
        return "Selecciona una opción";
    }
  }
}