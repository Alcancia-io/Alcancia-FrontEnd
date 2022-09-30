import 'package:alcancia/src/shared/components/alcancia_components.dart';
import 'package:alcancia/src/shared/graphql/queries.dart';
import 'package:alcancia/src/shared/provider/user.dart';
import 'package:alcancia/src/shared/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:alcancia/src/shared/components/alcancia_toolbar.dart';

class AlcanciaNavbar extends ConsumerWidget {
  AlcanciaNavbar({Key? key}) : super(key: key);
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return FutureBuilder(
        future: _storageService.readSecureData("token"),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var uri = dotenv.env['API_URL'] as String;
            var token = snapshot.data;

            final HttpLink httpLink = HttpLink(
              uri,
              defaultHeaders: <String, String>{
                'Authorization': 'Bearer $token'
              },
            );

            final ValueNotifier<GraphQLClient> myClient = ValueNotifier(
              GraphQLClient(
                cache: GraphQLCache(),
                link: httpLink,
              ),
            );
            return GraphQLProvider(
              client: myClient,
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
                  // user = User.fromJSON(result.data?["me"]);

                  return AlcanciaToolbar(
                    state: StateToolbar.profileTitleIcon,
                    userName: "${user?.name}",
                    logoHeight: 38,
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
