import 'package:alcancia/src/features/dashboard/data/transactions_query.dart';
import 'package:alcancia/src/features/dashboard/presentation/dashboard_card.dart';
import 'package:alcancia/src/features/dashboard/presentation/navbar.dart';
import 'package:alcancia/src/shared/components/alcancia_button.dart';
import 'package:alcancia/src/shared/components/alcancia_transactions.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    var ctx = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _storageService.readSecureData("token"),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var uri = dotenv.env['API_URL'] as String;
              var token = snapshot.data;

              final HttpLink httpLink = HttpLink(
                uri,
                defaultHeaders: <String, String>{
                  'Authorization': 'Bearer $token'
                },
              );

              final ValueNotifier<GraphQLClient> anotherClient = ValueNotifier(
                GraphQLClient(
                  cache: GraphQLCache(),
                  link: httpLink,
                ),
              );

              return GraphQLProvider(
                client: anotherClient,
                child: Query(
                  options: QueryOptions(
                    document: gql(transactionsQuery),
                    variables: const {
                      "userTransactionsInput": {
                        "currentPage": 0,
                        "itemsPerPage": 3,
                      },
                    },
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
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 24,
                        top: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Navbar(),
                          Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DashboardCard(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  onPressed: () {},
                                  color: const Color(0x00FFFFFF),
                                  rounded: true,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                          AlcanciaTransactions(
                            transactions: transactionsList,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
