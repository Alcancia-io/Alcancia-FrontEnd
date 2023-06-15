import 'package:alcancia/src/shared/models/alcancia_models.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';

class SwapController {
  final _exceptionHandler = ExceptionService();
  final _swapService = SwapService();

  Map<String, Map<String, String>> suarmiQuoteInput(
      {required String targetCurrency}) {
    return {
      "quoteInput": {
        "from_amount": "1",
        "from_currency": "MXN",
        "network": targetCurrency == "USDC" ? "MATIC" : "CELO",
        "to_currency": targetCurrency == 'USDC' ? 'USDC' : 'mcUSD',
      }
    };
  }

  Map<String, Map<String, String>> alcanciaQuoteInput(
      {required String targetCurrency}) {
    return {
      "quoteInput": {
        "from_amount": "1",
        "from_currency": "DOP",
        "to_currency": targetCurrency,
      }
    };
  }

  getSuarmiExchange(String targetCurrency) async {
    var response = await _swapService
        .getSuarmiQuote(suarmiQuoteInput(targetCurrency: targetCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    return response.data?['getSuarmiQuote']['to_amount'];
  }

  Future<double> getAlcanciaExchange(String targetCurrency) async {
    var response = await _swapService
        .getAlcanciaQuote(alcanciaQuoteInput(targetCurrency: targetCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final exchange = response.data?['getAlcanciaQuote']['sellRate'];
    return double.parse(exchange);
  }

  getCurrentAPY(String cryptoToken) async {
    var response = await _swapService.getCurrentAPY(cryptoToken);
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

  Future<AlcanciaOrder> sendOrder(Map<String, dynamic> orderInput) async {
    var response = await _swapService.sendOrder(orderInput);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['sendUserTransaction'];
    return AlcanciaOrder.fromJson(data);
  }
}
