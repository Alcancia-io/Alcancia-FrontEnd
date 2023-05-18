import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';

class WithdrawController {
  final _exceptionHandler = ExceptionService();
  final _suarmiService = SuarmiService();

  Map<String, dynamic> suarmiQuoteInput({required String sourceCurrency}) {
    return {
      "quoteInput": {
        "from_amount": "1",
        "from_currency": sourceCurrency == 'USDC' ? 'aPolUSDC' : 'mcUSD',
        "network": sourceCurrency == "USDC" ? "MATIC" : "CELO",
        "to_currency": "MXN",
      }
    };
  }

  Future<String> getSuarmiExchange({required String sourceCurrency}) async {
    final response = await _suarmiService.getSuarmiQuote(suarmiQuoteInput(sourceCurrency: sourceCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    return response.data?['getSuarmiQuote']['to_amount'];
  }

  Future<SuarmiOrder> sendSuarmiOrder(Map<String, dynamic> orderInput) async {
    final response = await _suarmiService.sendSuarmiOrder(orderInput);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['sendSuarmiOrder'];
    return SuarmiOrder.fromJson(data);
  }
}
