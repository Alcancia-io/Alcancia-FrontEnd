import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  final StorageService _storageService = StorageService();
  final uri = dotenv.env["API_URL"];

  Future<Object?> createClient() async {
    try {
      var token = await _storageService.readSecureData("token");
      // create http link with token
      final HttpLink httpLink = HttpLink(
        uri as String,
        defaultHeaders: <String, String>{'Authorization': 'Bearer $token'},
      );
      // create client
      final ValueNotifier<GraphQLClient> client = ValueNotifier(
        GraphQLClient(
          cache: GraphQLCache(),
          link: httpLink,
        ),
      );
      return client;
    } catch (exception) {
      return exception;
    }
  }
}
