import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _storageService.readSecureData("token"),
      builder: (context, AsyncSnapshot snapshot) {
        const uri = "http://localhost:3000/graphql";
        var token = snapshot.data;

        final HttpLink httpLink = HttpLink(
          uri,
          defaultHeaders: <String, String>{'Authorization': 'Bearer $token'},
        );

        final ValueNotifier<GraphQLClient> anotherClient = ValueNotifier(
          GraphQLClient(
            cache: GraphQLCache(store: HiveStore()),
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
              var userName = result.data?['me']['name'];

              return Container(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "lib/src/resources/images/profile.png",
                          width: 38,
                          height: 38,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Hola, ${userName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "lib/src/resources/images/icon_alcancia_dark_no_letters.svg",
                      width: 38,
                      height: 38,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
