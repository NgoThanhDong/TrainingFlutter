import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:training_flutter/global.dart';
import 'package:training_flutter/model_graphql/post.dart';
import 'package:training_flutter/service/graphql_conf.dart';
import 'package:training_flutter/service/query_mutation.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

GraphQLConfigurationAuth graphQLConfigurationAuth = GraphQLConfigurationAuth();
GraphQLClient _client = graphQLConfigurationAuth.clientToQuery();
QueryMutation _queryMutation = QueryMutation();

class PostController {
  
  static Future<String> uploadImage(File file) async {
    var byteData = file.readAsBytesSync();
    var multipartFile = MultipartFile.fromBytes(
      'image',
      byteData,
      filename: '${DateTime.now().millisecond}.jpeg',
      contentType: MediaType("image", "jpeg"),
    );
    
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: _queryMutation.uploadImage,
        variables: {
          'file': multipartFile
        },
      ),
    );
    
    if (!result.hasErrors) {
      return result.data['upload']['uploadedFileName'];
    }
    
    // Syntax Error GraphQL
    String _errorsMessages = 'Problem Uploading Image\n\n';
    int _resultErrorsLen = result.errors.length;
    for (int i = 0; i < _resultErrorsLen; i++) {
      _errorsMessages += result.errors[i].message;
      _errorsMessages += '\n\n';
    }
    
    return  _errorsMessages;
  }
  
  static Future<List<Map<String, dynamic>>> getPosts() async {
    GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    
    QueryResult result = await _client.query(
      QueryOptions(
        document: _queryMutation.getPosts,
        variables: {
          'nRepositories': REPOSITORIES,
        },
      ),
    );
    
    if (!result.hasErrors) {
      List<Map<String, dynamic>> _posts =
      result.data['posts']['edges'].cast<Map<String, dynamic>>();
      return _posts;
    }
    
    return null;
  }
  
  static Future<String> createPost(Post post) async {
    List _tagsId = [];
    for(var tag in post.tagsId) {
      _tagsId.add('"' +  tag + '"');
    }
    
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: _queryMutation.createPost,
        variables: {
          'title': post.title,
          'image': post.image,
          'description': post.description,
          'content': post.content,
          'author': post.author,
          'postType': post.postType,
          'category': post.categoryId,
          'tags': _tagsId,
          'url': post.url
        },
      )
    );
    
    String _errorsMessages = '';
    if (!result.hasErrors) {    // Post with this Title, Description, Url already exits.
      int _resultErrorsLen = result.data['post']['errors'].length;
      
      if (_resultErrorsLen > 0 ) {
        _errorsMessages = 'Problem Creating Post\n\n';
        for(int i = 0; i < _resultErrorsLen; i++) {
          _errorsMessages += (i+1).toString();
          _errorsMessages += '. ';
          _errorsMessages += toBeginningOfSentenceCase(result.data['post']['errors'][i]['field']);
          _errorsMessages += '\n';
          _errorsMessages += result.data['post']['errors'][i]['messages'][0];
          _errorsMessages += '\n\n';
        }
      }
    } else {    // Syntax Error GraphQL
      _errorsMessages = 'Problem Creating Post\n\n';
      int _resultErrorsLen = result.errors.length;
      
      for (int i = 0; i < _resultErrorsLen; i++) {
        _errorsMessages += result.errors[i].message;
        _errorsMessages += '\n\n';
      }
    }
    
    return _errorsMessages;
  }
  
  static Future<String> editPost(Post post) async {
    List _tagsId = [];
    for(var tag in post.tagsId) {
      _tagsId.add('"' +  tag + '"');
    }
    String image = post.image;
    if (image.contains(SERVER_NAME)) {
      image = image.split('/').last;
    }
    
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: _queryMutation.editPost,
        variables: {
          'id': post.id,
          'title': post.title,
          'image': image,
          'description': post.description,
          'content': post.content,
          'postType': post.postType,
          'category': post.categoryId,
          'tags': _tagsId,
          'url': post.url
        },
      )
    );
    
    String _errorsMessages = '';
    if (!result.hasErrors) {    // Post with this Title, Description, Url already exits.
      int _resultErrorsLen = result.data['post']['errors'].length;
      if (_resultErrorsLen > 0 ) {
        _errorsMessages = 'Problem Editing Post\n\n';
        for(int i = 0; i < _resultErrorsLen; i++) {
          _errorsMessages += (i+1).toString();
          _errorsMessages += '. ';
          _errorsMessages += toBeginningOfSentenceCase(result.data['post']['errors'][i]['field']);
          _errorsMessages += '\n';
          _errorsMessages += result.data['post']['errors'][i]['messages'][0];
          _errorsMessages += '\n\n';
        }
      }
    } else {    // Syntax Error GraphQL
      _errorsMessages = 'Problem Editing Post\n\n';
      int _resultErrorsLen = result.errors.length;
      for (int i = 0; i < _resultErrorsLen; i++) {
        _errorsMessages += result.errors[i].message;
        _errorsMessages += '\n\n';
      }
    }
    return _errorsMessages;
  }
  
  static Future<String> deletePost(Post post) async {
    List _tagsId = [];
    for(var tag in post.tagsId) {
      _tagsId.add('"' +  tag + '"');
    }
    
    String image = post.image;
    if (image.contains(SERVER_NAME)) {
      image = image.split('/').last;
    }
    
    String deletedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
    
    QueryResult result = await _client.mutate(
      MutationOptions(
        document: _queryMutation.deletePost,
        variables: {
          'id': post.id,
          'title': post.title,
          'image': image,
          'description': post.description,
          'content': post.content,
          'postType': post.postType.toLowerCase(),
          'category': post.categoryId,
          'tags': _tagsId,
          'url': post.url,
          'deletedDate': deletedDate
        },
      )
    );
    
    if (result.hasErrors) {    // Syntax Error GraphQL
      String _errorsMessages = 'Problem Deleting Post\n\n';
      int _resultErrorsLen = result.errors.length;
      
      for (int i = 0; i < _resultErrorsLen; i++) {
        _errorsMessages += result.errors[i].message;
        _errorsMessages += '\n\n';
      }
      
      return _errorsMessages;
    }
    
    return null;
  }
  
}