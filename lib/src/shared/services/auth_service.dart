import 'package:alcancia/src/shared/graphql/mutations/login_mutation.dart';
import 'package:alcancia/src/shared/graphql/mutations/complete_forgot_password_mutation.dart';
import 'package:alcancia/src/shared/graphql/queries/index.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CompletePasswordInput {
  CompletePasswordInput({this.email, this.newPassword, this.verificationCode});
  String? email = "email";
  String? newPassword = "newPassword";
  String? verificationCode = "123";

  Map<String, dynamic> toMap() {
    return {
      "email": email?.toLowerCase(),
      "newPassword": newPassword,
      "verificationCode": verificationCode,
    };
  }
}

class AuthService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  AuthService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  static String deleteAccountQuery = """
  mutation  {
    deleteUserAccount(){
      status
    }
  }
  """;

  static String completeSignInQuery = """
  query(\$verificationCode: String!){
    completeSignIn(verificationCode: \$verificationCode)
  }
  """;

  Future<bool> deleteAccount() async {
    try {
      final clientResponse = await client;
      QueryResult result = await clientResponse.mutate(
        MutationOptions(
          document: gql(deleteAccountQuery),
        ),
      );

      if (result.hasException) {
        return Future.error(
            result.exception?.graphqlErrors[0].message ?? "Exception");
      } else if (result.data != null) {
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
      QueryOptions(
          document: gql(completeSignInQuery),
          variables: {"verificationCode": verificationCode}),
    );
  }

  Future<QueryResult> login(
      String email, String password, String deviceToken) async {
    final clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(
        document: gql(loginMutation),
        variables: {
          "loginUserInput": {
            "email": email.toLowerCase(),
            "password": password,
            "deviceToken": deviceToken
          }
        },
      ),
    );
  }

  Future<QueryResult> forgotPassword(String email) async {
    var clientResponse = await client;
    return clientResponse.query(
      QueryOptions(
        document: gql(forgotPasswordQuery),
        variables: {"email": email.toLowerCase()},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<QueryResult> completeForgotPassword(
      CompletePasswordInput queryVariables) async {
    var clientResponse = await client;
    return clientResponse.mutate(
      MutationOptions(
        document: gql(completeForgotPasswordMutation),
        variables: queryVariables.toMap(),
      ),
    );
  }
}
