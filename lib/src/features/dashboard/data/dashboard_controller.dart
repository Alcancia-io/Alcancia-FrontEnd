import 'package:alcancia/src/features/dashboard/data/transactions_query.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/models/transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import '../../../shared/graphql/queries.dart';
import '../../../shared/provider/user.dart';
import '../../../shared/services/storage_service.dart';

class DashboardController {

  final getUserTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 3,
    },
  };

  Future<List<Transaction>?> _getUserTransactions() async {
    StorageService service = StorageService();
    var token = await service.readSecureData("token");
    GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
    GraphQLClient client = graphQLConfiguration.clientToQuery();
    var result = await client.query(QueryOptions(document: gql(transactionsQuery), variables: getUserTransactionsInput));
    Map<String, dynamic> response =
    result.data?['getUserTransactions'];
    final transactionsList = AlcanciaTransactions.fromJson(
      response,
    ).getTransactions();
    return transactionsList;
  }

  Future<double> _getUserProfit() async {
    StorageService service = StorageService();
    var token = await service.readSecureData("token");
    GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
    GraphQLClient client = graphQLConfiguration.clientToQuery();
    var result = await client.query(QueryOptions(document: gql(userProfitQuery)));
    double response = result.data?['getUserProfit'];
    return response;
  }

  Future<User> _getUser() async {
    StorageService service = StorageService();
    var token = await service.readSecureData("token");
    GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
    GraphQLClient client = graphQLConfiguration.clientToQuery();
    var result = await client.query(QueryOptions(document: gql(meQuery)));

    if (result.hasException) {
      print("Exception");
      final e = result.exception?.graphqlErrors[0].message;
      return Future.error(e!);
    } else if (result.data != null) {
      final data = result.data!["me"] as Map<String, dynamic>;
      final user = User.fromJSON(data);
      return user;
    }
    return Future.error("Error getting user information");
    // print(result.hasException);
  }

  Future<User> getAllUserInformation() async {
    try {
      final user = await _getUser();
      //final userProfit = await _getUserProfit();
      final transactions = await _getUserTransactions();
      //user.userProfit = userProfit;
      user.transactions = transactions;
      return user;
    } catch (e) {
      return Future.error(e);
    }
  }
}



final dashboardControllerProvider = Provider((ref) => DashboardController());
final userInformationProvider = FutureProvider.autoDispose<User>((ref) {
  final dashboardController = ref.watch(dashboardControllerProvider);
  final userInfo = dashboardController.getAllUserInformation();
  userInfo.then((value) => ref.read(userProvider.notifier).state = value);
  return userInfo;
});
