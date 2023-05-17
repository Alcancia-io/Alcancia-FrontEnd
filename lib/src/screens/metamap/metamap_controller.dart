import 'package:alcancia/src/shared/services/services.dart';

class MetaMapController {
  final List<Map<String, String>> professions = [
    {"name": "Empleado"},
    {"name": "Autoempleado"},
    {"name": "Proveedor de Servicios Independiente"},
    {"name": "Servidor Público"},
    {"name": "Jubilado"},
    {"name": "Desempleado"},
    {"name": "Estudiante"},
    {"name": "Miembro de ONG"},
    {"name": "Otro"},
  ];

  Future<bool> updateUser({required String address, required String profession}) async {
    UserService userService = UserService();
    final updatedUserInfo = {
      "profession": profession,
      "address": address,
    };
    try {
      final response = await userService.updateUser(info: updatedUserInfo);
      if (!response.hasException) return true;
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error updating user');
  }
}
