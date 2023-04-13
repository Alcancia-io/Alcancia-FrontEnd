import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';

class SwapController {
  final _exceptionHandler = ExceptionService();
  final _suarmiService = SuarmiService();

  Map<String, Map<String, String>> suarmiQuoteInput({required String targetCurrency}) {
    return {
      "quoteInput": {
        "from_amount": "1",
        "from_currency": "MXN",
        "network": targetCurrency == "USDC" ? "MATIC" : "CELO",
        "to_currency": targetCurrency == 'USDC' ? 'USDC' : 'mcUSD',
      }
    };
  }

  getSuarmiExchange(String targetCurrency) async {
    var response = await _suarmiService.getSuarmiQuote(suarmiQuoteInput(targetCurrency: targetCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    return response.data?['getSuarmiQuote']['to_amount'];
  }

  getCurrentAPY(String cryptoToken) async {
    var response = await _suarmiService.getCurrentAPY(cryptoToken);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw CustomException(exception as String);
    }
    return response.data?['getCurrentAPY'];
  }

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

  Future<SuarmiOrder> sendSuarmiOrder(Map<String, dynamic> orderInput) async {
    final response = await _suarmiService.sendSuarmiOrder(orderInput);
    print(response);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['sendSuarmiOrder'];
    print(data);
    return SuarmiOrder.fromJson(data);
  }
}
