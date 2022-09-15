import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../features/swap/data/exchange_api.dart';

class ExchangeApiService {
  ExchangeApiService({required this.baseCurrencyCode});
  final String baseCurrencyCode;
  Future<ExchangeApi> fetchCurrency(String targetCurrencyCode) async {
    var baseUrl = dotenv.env["EXCHANGE_API_URL"];
    var apiKey = dotenv.env["EXCHANGE_API_KEY"];
    var exchangeUrl =
        "$baseUrl${apiKey}pair/$baseCurrencyCode/$targetCurrencyCode";
    final response = await http.get(
      Uri.parse(exchangeUrl),
    );
    if (response.statusCode == 200) {
      return ExchangeApi.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load exchange api data');
    }
  }
}
