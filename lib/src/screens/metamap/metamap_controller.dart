import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:intl/intl.dart';

class MetaMapController {
  final List<Map<String, String>> professions = [
    {"name": "Empleado"},
    {"name": "Autoempleado"},
    {"name": "Proveedor de Servicios Independiente"},
    {"name": "Servidor Público"},
    {"name": "Jubilado"},
    {"name": "Desempleado"},
    {"name": "Estudiante"},
    {"name": "Miembo de ONG"},
    {"name": "Otro"},
  ];

  Future<bool> updateUser({required User user}) async {
    UserService userService = UserService();
    final updatedUserInfo = {
      "dob": DateFormat("yyyy-MM-dd").format(user.dob),
      "email": user.email,
      "gender": user.gender,
      "name": user.name,
      "phoneNumber": user.phoneNumber,
      "profession": user.profession,
      "surname": user.surname,
      "address": user.address,
      "walletAddress": user.walletAddress,
    };
    try {
      var response = await userService.updateUser(info: updatedUserInfo);
      if (!response.hasException) return true;
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error updating user');
  }
}
