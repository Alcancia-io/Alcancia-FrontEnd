import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  AuthService({required this.graphQLService});

  GraphqlService graphQLService;

  static String logoutQuery = """
  query {
    logout
  }
""";

  static String deleteAccountQuery = """
  query {
    deleteAccount
  }
  """;

  Future<GraphQLClient> _graphQLClient() async {
    final asyncClient = await graphQLService.createClient();
    return asyncClient.value;
  }

  Future<void> logout() async {
    try {
      GraphQLClient client = await _graphQLClient();
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(logoutQuery),
        ),
      );

      if (result.hasException) {
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        print(result.data);
        print(result.data!["logout"]);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> deleteAccount() async {
    try {
      GraphQLClient client = await _graphQLClient();
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(deleteAccountQuery),
        ),
      );

      if (result.hasException) {
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        print(result.data);
        return result.data!["deleteAccount"] as bool;
      }
      return false;
    } catch (e) {
      return Future.error(e);
    }
  }
}
