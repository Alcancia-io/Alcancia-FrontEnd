import 'dart:developer';

import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SwapController {
  final _exceptionHandler = ExceptionService();
  final _suarmiService = SuarmiService();

  final suarmiQuoteInput = {
    "quoteInput": {
      "from_amount": "1",
      "from_currency": "MXN",
      "network": "MATIC",
      "to_currency": "USDC",
    }
  };

  getSuarmiExchange() async {
    var response = await _suarmiService.getSuarmiQuote(suarmiQuoteInput);
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
