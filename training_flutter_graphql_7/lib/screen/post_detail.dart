import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:training_flutter/main_models/main_model.dart';
import 'package:training_flutter/model_grapql/post.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatelessWidget {

  // Attribute
  final Post post;

  // Constructor
  PostDetail({this.post}):super();

  @override
  Widget build(BuildContext context) {
    String _authorCreateDate = post.author;
    _authorCreateDate += " - Create date: ";
    _authorCreateDate += DateFormat("yyyy-MM-dd HH:mm").format(DateTime.parse(post.createdDate));
    
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
                    style: Theme.of(context).textTheme.title,
                  ),

                  // Author and create date
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(_authorCreateDate),
                  ),

                  SizedBox(height: 10.0),

                  // Images post
                  Hero(
                    tag: "${post.id}",
                    child: Center(
                      child: Container(
                        width: 360.0,
                        height: 240.0,
                        child: Image.network(
                          post.image,
                          fit: BoxFit.contain,
                        ),
                      ),
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
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                  Wrap(children: _createTags(context, model)),
                ]
              ),
            ),
          );
        },
      ),
    );
  }

  // Create tags from data
  List<Widget> _createTags(BuildContext context, MainModel model){
    List _tagsData = post.tags.split(', ');
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
        tags.add(
          SizedBox(width: 5.0)
        );
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
