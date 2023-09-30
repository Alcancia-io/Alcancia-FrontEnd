import 'package:alcancia/src/shared/graphql/queries/get_currently_supported_app_version_query.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class VersionService {
  late GraphQLConfig graphQLConfig;
  late Future<GraphQLClient> client;

  VersionService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  Future<QueryResult> getCurrentlySupportedAppVersion() async {
    var clientResponse = await client;
    return await clientResponse.query(
      QueryOptions(
        document: gql(getCurrentlySupportedAppVersionQuery),
      ),
    );
  }
}
