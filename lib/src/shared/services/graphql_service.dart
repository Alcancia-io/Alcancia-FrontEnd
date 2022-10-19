import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  final StorageService _storageService = StorageService();
  String? token;

  GraphQLConfig() {
    fetchToken();
  }

  fetchToken() async {
    token = await _storageService.readSecureData("token");
  }

  static HttpLink httpLink = HttpLink(
    dotenv.env["API_URL"] as String,
  );

  GraphQLClient clientToQuery() {
    AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}
