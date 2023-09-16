import 'package:alcancia/src/shared/graphql/mutations/subscribe_to_campaign_mutation.dart';
import 'package:alcancia/src/shared/graphql/queries/get_referral_code_query.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ReferralService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  ReferralService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  Future<QueryResult> subscribeToCampaign({required String? code}) async {
    var clientResponse = await client;
    return await clientResponse.mutate(
      MutationOptions(
        document: gql(subscribeToCampaignMutation),
        variables: {"input": {"code": code}},
      ),
    );
  }

  Future<QueryResult> getReferralCode() async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(getReferralCodeQuery),
      ),
    );
  }


}
