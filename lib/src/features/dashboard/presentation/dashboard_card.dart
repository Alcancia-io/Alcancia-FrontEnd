import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MyWidget extends StatelessWidget {
  MyWidget({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storageService.readSecureData("token"),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          const uri = "http://localhost:8000/graphql";
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
                  return Text("is loading...");
                }
                var balance = result.data?['me']['balance'];
                print(result.data);

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(15, 35, 70, 0.47),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 198,
                            decoration: const BoxDecoration(
                              color: Color(0xff3554C4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                child: DropdownButton<String>(
                                  isDense: true,
                                  selectedItemBuilder: (context) {
                                    return [
                                      Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          "Balance",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      )
                                    ];
                                  },
                                  dropdownColor: const Color(0xff1F318C),
                                  items: [
                                    DropdownMenuItem(
                                      child: Text(
                                        "Balance",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            "lib/src/resources/images/ojo.svg",
                            width: 24,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        child: Text(
                          "\$ ${balance} USDC",
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
                          if (result.hasException) {
                            return Text("error");
                          }
                          if (result.isLoading) {
                            return Text("is loading...");
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
                                    const EdgeInsets.only(top: 16, bottom: 8),
                                child: Text(
                                  "\$ ${userProfit} USDC",
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
                                  SizedBox(
                                    width: 116,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xff3554C4),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Retirar",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 116,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xff3554C4),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Depositar",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
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
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
