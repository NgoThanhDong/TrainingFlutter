import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:training_flutter/global.dart';
import 'package:training_flutter/service/graphql_conf.dart';
import 'package:training_flutter/service/query_mutation.dart';


QueryMutation _queryMutation = QueryMutation();

class UserController {
  
  static Future<String> login(String username, String password) async {
    GraphQLConfiguration _graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = _graphQLConfiguration.clientToQuery();
    
    QueryResult result = await _client.mutate(
        MutationOptions(
          document: _queryMutation.login,
          variables: {
            'username': username,
            'password': password
          },
        )
    );
    
    String errorsMessage = '';
    if (!result.hasErrors) {
      try {
        ACCESS_TOKEN = result.data['tokenAuth']['token'];
      }
      catch(e) {}
    } else {
      errorsMessage = result.errors[0].message;
    }
    
    return errorsMessage;
  }

  static getUser() async {
    GraphQLConfigurationAuth _graphQLConfigurationAuth = GraphQLConfigurationAuth();
    GraphQLClient _client = _graphQLConfigurationAuth.clientToQuery();
  
    QueryResult result = await _client.query(
      QueryOptions(
        document: _queryMutation.getUser,
        variables: {
          'username': USERNAME
        },
      ),
    );
  
    if (!result.hasErrors) {
      USER_LOGIN['id'] = result.data['users']['edges'][0]['node']['id'];
      USER_LOGIN['username'] =
      result.data['users']['edges'][0]['node']['username'];
      USER_LOGIN['email'] = result.data['users']['edges'][0]['node']['email'];
      USER_LOGIN['avatar'] = '${SERVER_NAME}public/images/' +
          result.data['users']['edges'][0]['node']['avatar'];
    }
  }
  
}
