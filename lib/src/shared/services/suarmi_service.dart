// late GraphQLConfig graphQLConfig;
// late Future<GraphQLClient> client;

// TransactionsService() {
//   graphQLConfig = GraphQLConfig();
//   client = graphQLConfig.clientToQuery();
// }

import 'package:alcancia/src/shared/graphql/queries/index.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SuarmiService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  SuarmiService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  Future<QueryResult> getSuarmiQuote(Map<String, dynamic> quoteInput) async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(suarmiQuota),
        variables: quoteInput,
      ),
    );
  }
}
