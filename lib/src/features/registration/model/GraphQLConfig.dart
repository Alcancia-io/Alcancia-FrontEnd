import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";

class GraphQLConfig  {
  GraphQLConfig({required this.token});

  String token;
  static HttpLink httpLink = HttpLink(
    'http://localhost:8000/graphql',
  );

  ///if you want to pass token
  ValueNotifier<GraphQLClient> graphInit()  {
    // We're using HiveStore for persistence,
    // so we need to initialize Hive.


    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(
          store: HiveStore(),
        ),
      ),
    );

    return client;
  }

  GraphQLClient clientToQuery() {
    AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    final Link link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}