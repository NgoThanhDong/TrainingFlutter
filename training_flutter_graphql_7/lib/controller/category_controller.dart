import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:training_flutter/global.dart';
import 'package:training_flutter/service/graphql_conf.dart';
import 'package:training_flutter/service/query_mutation.dart';

class CategoryController {

   static getCategories() async {
     GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
     GraphQLClient _client = graphQLConfiguration.clientToQuery();
     QueryMutation queryMutation = QueryMutation();

     QueryResult result = await _client.query(
       QueryOptions(document: queryMutation.getCategories()),
     );

     if (!result.hasErrors) {
       int categoriesLen = result.data['categories']['edges'].length;

       for (int i = 0; i < categoriesLen; i++) {
         CATEGORIES.add(
           result.data['categories']['edges'][i]['node']['name']
         );
       }
     }
  }
  
}