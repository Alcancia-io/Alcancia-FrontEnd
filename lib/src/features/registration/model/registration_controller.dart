import 'package:alcancia/src/shared/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/registration/data/signup_mutation.dart';
import 'package:intl/intl.dart';
import 'GraphQLConfig.dart';

class RegistrationController {
  RegistrationController({required this.token});
  String token;

  static String sendOTPAuthQuery = """
  query(\$phoneNumber: String!) {
    sendOTP(phoneNumber: \$phoneNumber, isAuthRequired: true) {
      status
    }
  }
""";
  static String sendOTPQuery = """
  query(\$phoneNumber: String!) {
    sendOTP(phoneNumber: \$phoneNumber, isAuthRequired: false) {
      status
    }
  }
""";

  static String verifyOTPQuery = """
  query(\$verificationCode: String!, \$phoneNumber: String!) {
    verifyOTP(verificationCode: \$verificationCode, phoneNumber: \$phoneNumber, isAuthRequired: false) {
      status,
      to,
      valid
    }
  }
""";

  Future<void> sendOTP(String phoneNumber) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(
        QueryOptions(
            document: gql(sendOTPQuery),
            variables: {"phoneNumber": phoneNumber}),
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

  Future<bool> verifyOTP(String otp, String phoneNumber) async {
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.query(
        QueryOptions(
            document: gql(verifyOTPQuery),
            variables: {"verificationCode": otp, "phoneNumber": phoneNumber}),
      );
      if (result.hasException) {
        final e = result.exception?.graphqlErrors[0].message;
        return Future.error(e!);
      } else {
        final valid = result.data!["verifyOTP"]["valid"] as bool;
        if (valid) return valid;
        return Future.error("Código inválido");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User?> signUp(User user, String password) async {
    final signupInput = {
      "name": user.name,
      "surname": user.surname,
      "email": user.email,
      "phoneNumber": user.phoneNumber,
      "gender": user.gender,
      "password": password,
      "dob": DateFormat('yyyy-MM-dd').format(user.dob),
      "country": user.country,
    };
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(MutationOptions(
          document: gql(signupMutation),
          variables: {"signupUserInput": signupInput}
          ));

      if (result.hasException) {
        final e = result.exception?.graphqlErrors[0].message;
        return Future.error(e!);
      } else if (result.data != null) {
        result.data!["signup"]["balance"] = 0.0;
        result.data!["signup"]["walletAddress"] = "";
        final data = result.data!["signup"] as Map<String, dynamic>;
        final user = User.fromJSON(data);
        return user;
      }
      return null;
    } catch (e) {
      return Future.error(e);
    }
  }
}
