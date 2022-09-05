import 'package:alcancia/src/features/dashboard/data/transactions_query.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions.dart';
import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TransactionsList extends StatelessWidget {
  TransactionsList({Key? key}) : super(key: key);

  final GraphqlService _gqlService = GraphqlService();
  final getUserTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 10,
    },
  };

  @override
  Widget build(BuildContext context) {
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
                      return const Text("is loading...");
                    }

                    Map<String, dynamic> response =
                        result.data?['getUserTransactions'];
                    var transactionsList = Data.fromJson(response);

                    return Container(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 24),
                      child:
                          AlcanciaTransactions(transactions: transactionsList),
                    );
                  },
                ),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
