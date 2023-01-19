import 'package:alcancia/src/features/login/data/login_mutation.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AuthService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  AuthService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

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

  static String completeSignInQuery = """
  query(\$verificationCode: String!){
    completeSignIn(verificationCode: \$verificationCode)
  }
  """;

  Future<void> logout() async {
    try {
      final clientResponse = await client;
      QueryResult result = await clientResponse.query(
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
      final clientResponse = await client;
      QueryResult result = await clientResponse.query(
        QueryOptions(
          document: gql(deleteAccountQuery),
        ),
      );
      print("deleting user");

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

  Future<QueryResult> completeSignIn(String verificationCode) async {
    final clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(document: gql(completeSignInQuery), variables: {"verificationCode": verificationCode}),
    );
  }

  Future<QueryResult> login(String email, String password, String deviceToken) async {
    final clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: {
          "loginUserInput": {"email": email, "password": password, "token": deviceToken}
        },
      ),
    );
  }
}
