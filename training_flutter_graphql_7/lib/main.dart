import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:training_flutter/screen/post_list.dart';
import 'package:training_flutter/theme/theme.dart';
import 'main_models/main_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'service/graphql_conf.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
  GraphQLProvider(
    client: graphQLConfiguration.client,
    child: CacheProvider(child: MyApp()),
  ),
);

class MyApp extends StatelessWidget {
  
  final MainModel _model = MainModel();
  final ThemeData _kPostTheme = buildPostTheme();
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child:  MaterialApp(
        title: 'Training Flutter',
        theme: _kPostTheme,
        home: PostList(),
      ),
    );
  }
}

