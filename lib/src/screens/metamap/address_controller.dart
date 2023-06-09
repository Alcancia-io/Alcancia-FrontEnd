import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:alcancia/src/shared/services/user_service.dart';

class AddressController {
  final _suarmiService = SwapService();
  final _exceptionHandler = ExceptionService();

  Future<User> fetchUser() async {
    UserService userService = UserService();
    try {
      var response = await userService.getUser();
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["me"];
        final user = User.fromJSON(data);
        return user;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error getting user');
  }

  Future<AlcanciaOrder> sendSuarmiOrder(Map<String, dynamic> orderInput) async {
    final response = await _suarmiService.sendOrder(orderInput);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['sendSuarmiOrder'];
    return AlcanciaOrder.fromJson(data);
  }
}
