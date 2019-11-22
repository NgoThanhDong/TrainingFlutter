import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:training_flutter/global.dart';

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    uri: "${SERVER_NAME}graphql/"    // http://127.0.0.1:8000/graphql/
  );

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      link: httpLink,
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    );
  }
}
