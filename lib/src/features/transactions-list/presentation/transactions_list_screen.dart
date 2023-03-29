import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions_list.dart';
import 'package:alcancia/src/shared/graphql/queries/transactions_query.dart';
import 'package:alcancia/src/shared/services/graphql_client_service.dart';
import 'package:alcancia/src/shared/services/services.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionsListScreen extends StatelessWidget {
  TransactionsListScreen({Key? key}) : super(key: key);

  final GraphqlService _gqlService = GraphqlService();
  final TransactionsService txnsService = TransactionsService();
  final getUserTransactionsInput = {
    "userTransactionsInput": {
      "currentPage": 0,
      "itemsPerPage": 20,
    },
  };

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: _gqlService.createClient(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AlcanciaToolbar(
              state: StateToolbar.titleIcon,
              title: appLoc.labelActivity,
              logoHeight: 38,
            ),
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

                    var transactionsList =
                        txnsService.getTransactionsFromJson(response);

                    return Container(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                      ),
                      child: AlcanciaTransactions(
                        txns: transactionsList,
                        bottomText: appLoc.labelStartTransactionActivity,
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
}
