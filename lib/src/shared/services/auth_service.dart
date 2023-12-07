import 'package:alcancia/src/shared/graphql/mutations/complete_mfa_sign_in_mutation.dart';
import 'package:alcancia/src/shared/graphql/mutations/login_mutation.dart';
import 'package:alcancia/src/shared/graphql/mutations/complete_forgot_password_mutation.dart';
import 'package:alcancia/src/shared/graphql/mutations/signin_mutation.dart';
import 'package:alcancia/src/shared/graphql/queries/index.dart';
import 'package:alcancia/src/shared/models/MFAModel.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

enum AuthChallengeType { MFA_SETUP, SMS_MFA, SOFTWARE_TOKEN_MFA }

class CompleteForgotPasswordInput {
  CompleteForgotPasswordInput(
      {this.email, this.newPassword, this.verificationCode});
  String? email = "email";
  String? newPassword = "newPassword";
  String? verificationCode = "123";
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

  Future<QueryResult> completeSignIn(MFAInputModel data) async {
    final clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(document: gql(completeMFASignInMutation), variables: {
        "input": {
          "code": data.verificationCode,
          "email": data.email.toLowerCase(),
          "token": data.token,
          "type": data.type.toString().split('.').last,
          "deviceToken": data.deviceToken
        }
      }),
    );
  }

  @Deprecated("Use signIn instead")
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

  Future<QueryResult> signIn(String email, String password) async {
    final clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(
        document: gql(signInMutation),
        variables: {
          "signInInput": {"email": email.toLowerCase(), "password": password}
        },
      ),
    );
  }

  Future<QueryResult> forgotPassword(String email) async {
    var clientResponse = await client;
    return clientResponse.mutate(
      MutationOptions(
        document: gql(forgotPasswordQuery),
        variables: {
          "input": {"email": email.toLowerCase()}
        },
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
  }

  Future<QueryResult> completeForgotPassword(
      CompleteForgotPasswordInput queryVariables) async {
    var clientResponse = await client;
    return clientResponse.mutate(
      MutationOptions(
        document: gql(completeForgotPasswordMutation),
        variables: {
          "input": {
            "code": queryVariables.verificationCode,
            "email": queryVariables.email?.toLowerCase(),
            "newPassword": queryVariables.newPassword,
          }
        },
      ),
    );
  }
}
