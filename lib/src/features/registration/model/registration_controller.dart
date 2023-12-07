import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../../../shared/graphql/mutations/signup_mutation.dart';
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

  Future<void> resendVerificationCode(String email) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(requestNewVerificationCodeMutation),
            variables: {
              "input": {"email": email.toLowerCase()}
            }),
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
    var confirmSignUpInput = {"code": otp, "email": email, "deviceToken": ""};
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(confirmSignUpMutation),
            variables: {"input": confirmSignUpInput}),
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
      "birthdate": DateFormat('yyyy-MM-dd').format(user.dob),
      "country": user.country,
      "deviceToken": "",
      "email": user.email.toLowerCase(),
      "gender": user.gender,
      "lastName": user.surname,
      "name": user.name,
      "password": password,
      "phoneNumber": user.phoneNumber,
    };
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      QueryResult result = await client.mutate(MutationOptions(
          document: gql(signupMutation), variables: {"input": signupInput}
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
