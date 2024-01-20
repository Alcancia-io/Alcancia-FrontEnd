import 'package:alcancia/src/shared/models/external_withdrawal.dart';
import 'package:alcancia/src/shared/models/suarmi_order_model.dart';
import 'package:alcancia/src/shared/services/crypto_wallet_service.dart';
import 'package:alcancia/src/shared/services/exception_service.dart';
import 'package:alcancia/src/shared/services/suarmi_service.dart';

class WithdrawController {
  final _exceptionHandler = ExceptionService();
  final _swapService = SwapService();
  final _cryptoWalletService = CryptoWalletService();

  Map<String, dynamic> suarmiQuoteInput({required String sourceCurrency}) {
    return {
      "quoteInput": {
        "from_amount": "1",
        "from_currency": sourceCurrency == 'USDC' ? 'USDC' : 'mcUSD',
        "network": sourceCurrency == "USDC" ? "MATIC" : "CELO",
        "to_currency": "MXN",
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

  Future<double> getAlcanciaExchange(String targetCurrency) async {
    var response = await _swapService
        .getAlcanciaQuote(alcanciaQuoteInput(targetCurrency: targetCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final exchange = response.data?['getAlcanciaQuote']['buyRate'];
    return double.parse(exchange);
  }

  Future<String> getSuarmiExchange({required String sourceCurrency}) async {
    final response = await _swapService
        .getSuarmiQuote(suarmiQuoteInput(sourceCurrency: sourceCurrency));
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    return response.data?['getSuarmiQuote']['to_amount'];
  }

  Future<AlcanciaOrder> sendOrder(Map<String, dynamic> orderInput) async {
    final response = await _swapService.sendOrder(orderInput);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['sendUserTransaction'];
    return AlcanciaOrder.fromJson(data);
  }

  Future<ExternalWithdrawal> sendExternalWithdrawal(
      {required String amount, required String address}) async {
    final response = await _cryptoWalletService.sendExternalWithdraw(
        amount: amount, address: address);
    if (response.hasException) {
      var exception = _exceptionHandler.handleException(response.exception);
      throw Exception(exception);
    }
    final data = response.data?['executeCryptoWithdrawal'];
    return ExternalWithdrawal.fromJSON(data);
  }
}
