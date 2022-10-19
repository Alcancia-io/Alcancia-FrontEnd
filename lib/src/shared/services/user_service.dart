import 'package:alcancia/src/shared/graphql/queries/me_query.dart';
import 'package:alcancia/src/shared/services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserService {
  late GraphQLConfig graphQLConfig;
  late GraphQLClient client;

  UserService() {
    graphQLConfig = GraphQLConfig();
    client = graphQLConfig.clientToQuery();
  }

  Future<QueryResult> getUser() async {
    return await client.query(
      QueryOptions(
        document: gql(meQuery),
      ),
    );
  }
}
