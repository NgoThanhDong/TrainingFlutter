import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:training_flutter/global.dart';
import 'package:training_flutter/service/graphql_conf.dart';
import 'package:training_flutter/service/query_mutation.dart';

class TagController {

  static getTags() async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryMutation queryMutation = QueryMutation();

    QueryResult result = await _client.query(
      QueryOptions(document: queryMutation.getTags()),
    );

    if (!result.hasErrors) {
      int tagsLen = result.data['tags']['edges'].length;

      for (int i = 0; i < tagsLen; i++) {
        TAGS.add(
          result.data['tags']['edges'][i]['node']['name']
        );
      }
    }
  }
}