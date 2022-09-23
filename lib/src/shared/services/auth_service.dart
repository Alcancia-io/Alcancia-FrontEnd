import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  AuthService({required this.graphQLClient});

  GraphQLClient graphQLClient;

  static String logoutQuery = """
  query {
    logout
  }
""";

  Future<void> logout() async {
    try {
      QueryResult result = await graphQLClient.query(
        QueryOptions(
          document: gql(logoutQuery),
        ),
      );

      if (result.hasException) {
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        print(result.data);
      }
    } catch (e) {
      print(e);
    }
  }
}
