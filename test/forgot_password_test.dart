import 'package:alcancia/src/screens/forgot_password/forgot_password.dart';
import 'package:alcancia/src/shared/graphql/queries/forgot_password_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';

bool validatePassword(String password) {
  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  bool hasDigits = password.contains(RegExp(r'[0-9]'));
  bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length > 7;

  return hasUppercase & hasLowercase & hasDigits & hasSpecialChar & hasMinLength;
}

class MockGraphQLClient extends Mock implements GraphQLClient {
  // Future<QueryResult> completeForgotPassword() async {
  //   var clientResponse = await client;
  //   return clientResponse.mutate(
  //     MutationOptions(
  //       document: gql(completeForgotPasswordMutation),
  //       variables: queryVariables.toMap(),
  //     ),
  //   );
  // }
}

void main() {
  group('mocking graphql', () {
    MockGraphQLClient client = MockGraphQLClient();
    testWidgets('forgotpassword widget', (tester) async {
      // var response = QueryResult<Object?>(
      //   source: QueryResultSource.network,
      //   options: QueryOptions(
      //     document: gql(forgotPasswordQuery),
      //   ),
      // );
      var response = QueryResult<Object?>(
        source: QueryResultSource.network,
        options: QueryOptions(document: gql(forgotPasswordQuery)),
        data: {"message": "hello"},
        exception: OperationException(),
        context: Context(),
      );
      try {
        when(client.query(
          QueryOptions(
            document: gql(forgotPasswordQuery),
            variables: const {"email": "email@gmail.com"},
          ),
        )).thenAnswer((hey) async {
          print('hey!!!!!!!!!!!!!!!!!!!!!!!');
          print(hey);
          return response;
        });
      } catch (err) {
        print(err);
      }
      // await tester.pumpWidget(const MaterialApp(home: ForgotPassword()));
      // final hola = find.byType(CircularProgressIndicator);

      // expect(hola, findsOneWidget);
    });

    // when(client.query(QueryOptions(document: gql(forgotPasswordQuery)))).thenAnswer(
    //   (_) async => QueryResult.internal(
    //     parserFn: (Map<String, dynamic> data) {
    //       return {"hola": "adios"};
    //     },
    //     source: QueryResultSource.network,
    //   ),
    // );
  });

  // group('password validation', () {
  //   test('password missing uppercase', () {
  //     expect(validatePassword('alcancia1'), false);
  //   });

  //   test('password missing lowercase', () {
  //     expect(validatePassword('ALCANCIA'), false);
  //   });

  //   test('password missing digit', () {
  //     expect(validatePassword('alcancia'), false);
  //   });

  //   test('password missing invalid special char', () {
  //     expect(validatePassword('Alcancia123'), false);
  //   });

  //   test('password missing min length', () {
  //     expect(validatePassword('pass'), false);
  //   });

  //   test('valid password', () {
  //     expect(validatePassword('Alcancia123!'), true);
  //   });
  // });
}
