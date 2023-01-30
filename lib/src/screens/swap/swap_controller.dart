import 'package:alcancia/src/shared/services/exception_service.dart';
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
      print('exception:');
      var exception = _exceptionHandler.handleException(response.exception);
      print(exception);
      throw Exception(exception);
    }
    print(response.data);
    return response.data?['getSuarmiQuote']['to_amount'];
  }
}
