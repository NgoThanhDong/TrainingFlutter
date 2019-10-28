import 'package:flutter/material.dart';

class PostDetail extends StatelessWidget {

  // Sample data of the category, tags
  final String _category = 'CategoryX';
  final List<String> _tagsData = ['Tag1', 'Tag2', 'Tag3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Post Detail'),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title
                    Text(
                      'Title title title title title title title title title',
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
                        Text('Alex'),
                        Text(' - '),
                        Text('Create date: '),
                        Text('2019/10/10 12:00'),
                      ],
                    ),

                    SizedBox(height: 10.0),

                    // Images post
                    Container(
                        width: double.infinity,
                        child: Image.asset(
                            'images/sample.jpg',
                            fit: BoxFit.contain
                        )
                    ),

                    SizedBox(height: 10.0),

                    // Content
                    Text(
                      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                          'Alps. Situated 1,578 meters above sea level, it is one of the '
                          'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                          'half-hour walk through pastures and pine forest, leads you to the '
                          'lake, which warms to 20 degrees Celsius in the summer. Activities '
                          'enjoyed here include rowing, and riding the summer toboggan run.'
                          'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                          'Alps. Situated 1,578 meters above sea level, it is one of the '
                          'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                          'half-hour walk through pastures and pine forest, leads you to the '
                          'lake, which warms to 20 degrees Celsius in the summer. Activities '
                          'enjoyed here include rowing, and riding the summer toboggan run.'
                          'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                          'half-hour walk through pastures and pine forest, leads you to the '
                          'lake, which warms to 20 degrees Celsius in the summer. Activities '
                          'enjoyed here include rowing, and riding the summer toboggan run.'
                          'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
                          'Alps. Situated 1,578 meters above sea level, it is one of the '
                          'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
                          'half-hour walk through pastures and pine forest, leads you to the '
                          'lake, which warms to 20 degrees Celsius in the summer. Activities '
                          'enjoyed here include rowing, and riding the summer toboggan run.',
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
                            _category,
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () => _categoryPressed(_category, context),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.0),

                    // Tags
                    Wrap(
                        children: _createTags(context)
                    ),

                  ]
              )
          ),
        )
    );
  }


  // Create tags
  List<Widget> _createTags(BuildContext context){
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
          onPressed: () => _tagsPressed(_tagsData[i], context),
        ),
      );

      if(i < tagsLength - 1) {
        tags.add(SizedBox(width: 5.0));
      }
    }
    return tags;
  }


  /// EVENT PRESS BUTTON

  void _categoryPressed(category, context) {
    Navigator.pop(context);
  }

  void _tagsPressed(tag, context) {
    Navigator.pop(context);
  }

}
