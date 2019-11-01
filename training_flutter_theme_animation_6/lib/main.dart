import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:training_flutter/screen/post_list.dart';
import 'package:training_flutter/theme/theme.dart';
import 'main_models/main_model.dart';

void main() => runApp(MyApp());

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
