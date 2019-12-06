import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:training_flutter/global.dart';


class GraphQLConfiguration {
  
  static HttpLink httpLink = HttpLink(
    uri: '${SERVER_NAME}graphql/',
  );
  
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject
      ),
      link: httpLink,
    ),
  );
  
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject
      ),
      link: httpLink,
    );
  }
  
}

class GraphQLConfigurationAuth {
  
  static HttpLink httpLink = HttpLink(
    uri: '${SERVER_NAME}graphql/',
  );
  
  static final AuthLink authLink = AuthLink(
    getToken: () async => 'JWT $ACCESS_TOKEN',
  );
  
  static final Link link = authLink.concat(httpLink);
  
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject
      ),
      link: link,
    ),
  );
  
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject
      ),
      link: link,
    );
  }
}