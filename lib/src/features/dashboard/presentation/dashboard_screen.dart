import 'dart:async';

import 'package:alcancia/src/features/dashboard/data/transactions_query.dart';
import 'package:alcancia/src/features/dashboard/presentation/dashboard_card.dart';
import 'package:alcancia/src/features/dashboard/presentation/navbar.dart';
import 'package:alcancia/src/features/registration/model/GraphQLConfig.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/balance_provider.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? timer;

  final GraphqlService _gqlService = GraphqlService();
  final getUserTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 3,
    },
  };

  @override
  Widget build(BuildContext context) {
    void getUserBalance() async {
      StorageService service = StorageService();
      var token = await service.readSecureData("token");
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      var result = await client.query(QueryOptions(document: gql(userBalance)));
      print(result);
      if (!result.hasException) {
        ref
            .read(balanceProvider.notifier)
            .setBalance(Balance.fromJSON(result.data));
      }

      // print(result.hasException);
    }

    timer =
        Timer.periodic(Duration(seconds: 15), (Timer t) => getUserBalance());

    Future<QueryResult<Object?>> getUserInformation() async {
      StorageService service = StorageService();
      var token = await service.readSecureData("token");
      GraphQLConfig graphQLConfiguration = GraphQLConfig(token: "${token}");
      GraphQLClient client = graphQLConfiguration.clientToQuery();
      var result = await client.query(QueryOptions(document: gql(meQuery)));
      return result;
      // print(result.hasException);
    }

    Future.delayed(Duration.zero, () async {
      var result = await getUserInformation();
      if (!result.hasException) {
        var user = User.fromJSON(result.data?["me"]);
        ref.read(userProvider.notifier).setUser(user);
      }
      getUserBalance();
    });

    return FutureBuilder(
      future: _gqlService.createClient(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: SafeArea(
              child: GraphQLProvider(
                client: snapshot.data,
                child: Query(
                  options: QueryOptions(
                    document: gql(transactionsQuery),
                    variables: getUserTransactionsInput,
                  ),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text("${result.exception?.graphqlErrors.first}");
                    }

                    if (result.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Map<String, dynamic> response =
                        result.data?['getUserTransactions'];
                    var transactionsList = AlcanciaTransactions.fromJson(
                      response,
                    ).getTransactions();

                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 24,
                          top: 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AlcanciaNavbar(),
                            Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DashboardCard(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 22, top: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Actividad",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AlcanciaButton(
                                    buttonText: "Ver más",
                                    onPressed: () {
                                      // context.push("/homescreen/1");
                                      context.go("/homescreen/1");
                                    },
                                    color: const Color(0x00FFFFFF),
                                    rounded: true,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                            AlcanciaTransactions(
                              transactions: transactionsList,
                              height: 200,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
