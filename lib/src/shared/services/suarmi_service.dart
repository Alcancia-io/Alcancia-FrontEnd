import 'package:alcancia/src/shared/graphql/queries/alcancia_quote_query.dart';
import 'package:alcancia/src/shared/graphql/queries/index.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SwapService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  SwapService() {
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

  Future<QueryResult> sendOrder(Map<String, dynamic> orderInput) async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(sendUserTransactionQuery),
        variables: orderInput,
      ),
    );
  }

  Future<QueryResult> getAlcanciaQuote(Map<String, dynamic> quoteInput) async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(getAlcanciaQuoteQuery),
        variables: quoteInput,
      ),
    );
  }

  // APY -> Anual Percentage Yield
  Future<QueryResult> getCurrentAPY(String cryptoToken) async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(getCurrentAPYQuery),
        variables: {"token": cryptoToken},
      ),
    );
  }
}
