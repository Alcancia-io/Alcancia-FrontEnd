import 'package:alcancia/src/shared/graphql/mutations/external_withdraw_query.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CryptoWalletService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  CryptoWalletService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  Future<QueryResult> sendExternalWithdraw(
      {required String amount, required String address}) async {
    final clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(
        document: gql(externalWithdrawQuery),
        variables: {
          "cryptoWithdrawalInput": {
            "amount": double.parse(amount),
            "receiverAddress": address,
          }
        },
      ),
    );
  }
}
