import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  final StorageService _storageService = StorageService();

  static HttpLink httpLink = HttpLink(
    dotenv.env["API_URL"] as String,
  );

  Future<GraphQLClient> clientToQuery() async {
    var token = await _storageService.readSecureData("token");
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
