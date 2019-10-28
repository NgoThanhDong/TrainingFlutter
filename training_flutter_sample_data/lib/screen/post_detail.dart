import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:training_flutter/main_models/main_model.dart';
import 'package:training_flutter/model_sample_data/post.dart';

class PostDetail extends StatelessWidget {

  // Attribute
  final Post post;

  // Constructor
  PostDetail({this.post}):super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Detail'),
        ),
        body: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Title
                          Text(
                            post.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          // Author and create date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('Author: '),
                              Text(post.author),
                              Text(' - '),
                              Text('Create date: '),
                              Text(post.createdDate),
                            ],
                          ),

                          SizedBox(height: 10.0),

                          // Images post
                          Container(
                            width: double.infinity,
                            child: Image.memory(
                                Base64Decoder().convert(post.image),
                                fit: BoxFit.contain
                            ),
                          ),

                          SizedBox(height: 10.0),

                          // Content
                          Text(
                            post.content,
                            softWrap: true,
                          ),

                          SizedBox(height: 30.0),

                          // Category
                          Wrap(
                            children: <Widget>[
                              Text(
                                'Catalory: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RawMaterialButton(
                                constraints: BoxConstraints(),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                child: Text(
                                  post.category,
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () => _categoryPressed(post.category, context, model),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.0),

                          // Tags
                          Wrap(
                              children: _createTags(context, model)
                          ),
                        ]
                    )
                ),
              );
            }
        ),
    );
  }

  // Create tags
  List<Widget> _createTags(BuildContext context, MainModel model){
    List _tagsData = post.tags;
    List tags = new List<Widget>();

    tags.add(
        Text('Tags: ', style: TextStyle(fontWeight: FontWeight.bold))
    );

    int tagsLength = _tagsData.length;
    for(int i = 0; i < tagsLength; i++){
      tags.add(
        RawMaterialButton(
          constraints: BoxConstraints(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
            (i == tagsLength - 1) ? _tagsData[i] : _tagsData[i] + ',',
            style: TextStyle(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: () => _tagsPressed(_tagsData[i], context, model),
        ),
      );

      if(i < tagsLength - 1) {
        tags.add(SizedBox(width: 5.0));
      }
    }
    return tags;
  }


  /// EVENT PRESS BUTTON

  void _categoryPressed(category, context, model) {
    model.categorySelect = category;
    Navigator.pop(context);
  }

  void _tagsPressed(tag, context, model) {
    model.tagSelect = tag;
    Navigator.pop(context);
  }

}
