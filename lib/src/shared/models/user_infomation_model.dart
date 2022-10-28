import 'package:alcancia/src/shared/models/alcancia_models.dart';

class UserInformationModel {
  late User user;
  late List<Transaction> txns;

  UserInformationModel({
    required this.user,
    required this.txns,
  });
}
