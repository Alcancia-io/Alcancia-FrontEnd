import 'package:alcancia/src/features/dashboard/data/transactions_query.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import '../../../shared/graphql/queries.dart';
import '../../../shared/models/user.dart';
import '../../../shared/services/storage_service.dart';
import '../../../shared/services/user_service.dart';

class DashboardController {
  final UserService userService = UserService();

  Future<User> fetchUser() async {
    var response = await userService.getUser();
    if (response.hasException) {
      print(response);
      return Future.error(response.exception!.graphqlErrors[0].toString());
    }
    if (response.data != null) {
      Map<String, dynamic> data = response.data!["me"];
      final user = User.fromJSON(data);
      return user;
    }
    return Future.error('Error getting user information');
  }
  // } else if (result.data != null) {
  //     final data = result.data!["me"] as Map<String, dynamic>;
  //     final user = User.fromJSON(data);
  //     return user;
  //   }
  // final getUserTransactionsInput = {
  //   "userTransactionsInput": {
  //     "currentPage": 0,
  //     "itemsPerPage": 3,
  //   },
  // };

  // Future<List<Transaction>?> _getUserTransactions() async {
  //   StorageService service = StorageService();
  //   var token = await service.readSecureData("token");
  //   GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
  //   GraphQLClient client = graphQLConfiguration.clientToQuery();
  //   var result = await client.query(QueryOptions(
  //       document: gql(transactionsQuery), variables: getUserTransactionsInput));
  //   Map<String, dynamic> response = result.data?['getUserTransactions'];
  //   final transactionsList = AlcanciaTransactions.fromJson(
  //     response,
  //   ).getTransactions();
  //   return transactionsList;
  // }

  // Future<double> _getUserProfit() async {
  //   StorageService service = StorageService();
  //   var token = await service.readSecureData("token");
  //   GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
  //   GraphQLClient client = graphQLConfiguration.clientToQuery();
  //   var result =
  //       await client.query(QueryOptions(document: gql(userProfitQuery)));
  //   double response = result.data?['getUserProfit'];
  //   return response;
  // }

  // Future<User> _getUser() async {
  //   StorageService service = StorageService();
  //   var token = await service.readSecureData("token");
  //   GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
  //   GraphQLClient client = graphQLConfiguration.clientToQuery();
  //   var result = await client.query(QueryOptions(document: gql(meQuery)));

  //   if (result.hasException) {
  //     print("Exception");
  //     final e = result.exception?.graphqlErrors[0].message;
  //     return Future.error(e!);
  //   } else if (result.data != null) {
  //     final data = result.data!["me"] as Map<String, dynamic>;
  //     final user = User.fromJSON(data);
  //     return user;
  //   }
  //   return Future.error("Error getting user information");
  //   // print(result.hasException);
  // }

  // Future<User> getAllUserInformation() async {
  //   try {
  //     final user = await _getUser();
  //     //final userProfit = await _getUserProfit();
  //     final transactions = await _getUserTransactions();
  //     //user.userProfit = userProfit;
  //     user.transactions = transactions;
  //     return user;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }
}

final userInformationProvider = FutureProvider<User>((ref) {
  final dashboardController = DashboardController();
  final user = dashboardController.fetchUser();
  return user;
});

//   final dashboardController = ref.watch(dashboardControllerProvider);
//   final userInfo = dashboardController.getAllUserInformation();
//   return userInfo
//       .then((value) => ref.read(userProvider.notifier).state = value);
// });
