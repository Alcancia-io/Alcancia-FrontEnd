import 'package:alcancia/src/resources/colors/colors.dart';
import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    var ctx = Theme.of(context);
    return FutureBuilder(
      future: _storageService.readSecureData("token"),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var uri = dotenv.env['API_URL'] as String;
          var token = snapshot.data;

          final HttpLink httpLink = HttpLink(
            uri,
            defaultHeaders: <String, String>{'Authorization': 'Bearer $token'},
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
                document: gql(meQuery),
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text("error");
                }

                if (result.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                var balance = result.data?['me']['balance'];
                var balanceFormatted = "0";
                if (balance != 0) balanceFormatted = balance.toStringAsFixed(3);

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: ctx.brightness == Brightness.dark
                        ? alcanciaCardDark2
                        : alcanciaCardLight2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Balance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        child: Text(
                          "\$${balanceFormatted} USDC",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                      ),
                      Query(
                        options: QueryOptions(
                          document: gql(userProfit),
                        ),
                        builder: (QueryResult result,
                            {VoidCallback? refetch, FetchMore? fetchMore}) {
                          // if (result.hasException) {
                          //   return Text("error");
                          // }
                          if (result.isLoading) {
                            return CircularProgressIndicator();
                          }
                          var userProfit = result.data?['getUserProfit'];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: const Text(
                                  "Ganancias",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 20),
                                child: Text(
                                  "\$0 USDC",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AlcanciaButton(
                                    buttonText: "Depositar",
                                    onPressed: () {
                                      context.push("/swap");
                                    },
                                    width: 116,
                                    height: 38,
                                    color: alcanciaMidBlue,
                                  ),
                                  AlcanciaButton(
                                    buttonText: "Retirar",
                                    onPressed: () {},
                                    width: 116,
                                    height: 38,
                                    color: alcanciaMidBlue,
                                  )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
