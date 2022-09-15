import 'package:alcancia/src/shared/provider/user.dart';
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
        print("Exception");
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        print("data");
        print(result.data);
        final valid = result.data!["verifyOTP"]["valid"] as bool;
        return valid;
      }
      return false;
    } catch (e) {
      print("Error");
      print(e);
      return false;
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
      "dob": DateFormat('dd/MM/yyyy').format(user.dob)
    };
    try {
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: token);
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
          MutationOptions(
            document: gql(signupMutation),
            variables: {"signupUserInput": signupInput}
            //onCompleted: (resultData) {
            //  if (resultData != null) {
            //    context.go("/login");
            //  }
            //},
          )
      );

      if (result.hasException) {
        print("Exception");
        print(result.exception?.graphqlErrors[0].message);
      } else if (result.data != null) {
        print("data");
        print(result.data);
        final data = result.data!["data"] as Map<String, dynamic>;
        final user = User.fromJSON(data);
        print("Success!");
        return user;
      }
      return null;
    } catch (e) {
      print("Error");
      print(e);
      return null;
    }
  }
}
