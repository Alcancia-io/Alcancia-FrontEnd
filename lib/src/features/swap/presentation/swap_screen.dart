import 'dart:convert';
import 'package:alcancia/src/features/swap/data/exchange_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SwapScreen extends StatelessWidget {
  SwapScreen({Key? key}) : super(key: key);

  String baseCurrency = "USD";
  String targetCurrency = "MXN";
  late String uri =
      "${dotenv.env["EXCHANGE_API_URL"]}${dotenv.env["EXCHANGE_API_KEY"]}/pair/$baseCurrency/$targetCurrency";

  Future<ExchangeApi> fetchAlbum() async {
    final response = await http.get(
      Uri.parse(uri),
    );
    if (response.statusCode == 200) {
      return ExchangeApi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ExchangeApi>(
          future: fetchAlbum(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("${snapshot.data!.conversionRate}");
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
