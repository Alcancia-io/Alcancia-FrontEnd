import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/registration/data/signup_mutation.dart';
import 'package:intl/intl.dart';
import '../../../shared/services/services.dart';
import 'graphql_config.dart';

class RegistrationController {
  RegistrationController({required this.token});

  String token;

  static String verifyOTPQuery = """
  query(\$verificationCode: String!, \$email: String!) {
    verifyOTP(verificationCode: \$verificationCode, email: \$email, isAuthRequired: false)
  }
""";

  static String resendVerificationQuery = """
  query(\$email: String!) {
    resendVerification(email: \$email) {
      DeliveryMedium
    }
  }
  """;

  static String userExists = """
query(\$email: String!){
  userExists(email: \$email)
}
""";

  Future<bool> checkUserExists(String email) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      var response = await client.query(QueryOptions(
          document: gql(userExists),
          variables: {"email": email.toLowerCase()}));
      if (response.data != null) {
        Map<String, dynamic> data = response.data!["userExists"];
        var res = data as bool;
        return res;
      }
    } catch (error) {
      return Future.error(error);
    }
    return Future.error('Error checking user exists');
  }

  Future<void> resendVerificationCode(String email) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(resendVerificationQuery),
            variables: {"email": email.toLowerCase()}),
      );
      if (result.hasException) {
        final e = result.exception?.graphqlErrors[0].message;
        return Future.error(e!);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> verifyOTP(String otp, String email) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(verifyOTPQuery),
            variables: {"verificationCode": otp, "email": email.toLowerCase()}),
      );
      if (result.hasException) {
        final e = result.exception?.graphqlErrors[0].message;
        return Future.error(e!);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signUp(User user, String password) async {
    final signupInput = {
      "name": user.name,
      "surname": user.surname,
      "email": user.email.toLowerCase(),
      "phoneNumber": user.phoneNumber,
      "gender": user.gender,
      "password": password,
      "dob": DateFormat('yyyy-MM-dd').format(user.dob),
      "country": user.country,
      "deviceToken": ""
    };
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(MutationOptions(
          document: gql(signupMutation),
          variables: {"signupUserInput": signupInput}
          //onCompleted: (resultData) {
          //  if (resultData != null) {
          //    context.go("/login");
          //  }
          //},
          ));

      if (result.hasException) {
        final e = result.exception;
        return Future.error(e!);
      }
      return;
    } catch (e) {
      return Future.error(e);
    }
  }
}
