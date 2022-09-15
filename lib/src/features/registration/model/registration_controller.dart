import 'package:graphql_flutter/graphql_flutter.dart';
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
        final valid = result.data!["verifyOTP"]["valid"];
        return valid;
      }
      return false;
    } catch (e) {
      print("Error");
      print(e);
      return false;
    }
  }
}
