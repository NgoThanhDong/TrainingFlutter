import 'package:flutter/material.dart';
import 'package:training_flutter/screen/create_post.dart';
import 'package:training_flutter/screen/post_detail.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  /// ATTRIBUTE

  // Search app bar
  final _searchController =  TextEditingController();
  Widget _appBarTitle = Text('Search for posts');
  Icon _searchIcon = Icon(Icons.search);
  Icon _arrowDrop = Icon(
    Icons.arrow_drop_up,
    semanticLabel: 'arrow drop up',
  );

  // Height bottom appbar = height 2 dropdown + height 3 button
  var _heightBottomAppBar = 90.0;

  // List objects of Category, Tag
  final List<String> _categories = ['All', 'Category 1', 'Category 2'];
  final List<String >_tags = ['All', 'Tag 1', 'Tag 2', 'Tag 3', 'Tag 4'];

  // Category, Tag dropdown value
  String categoryDropdownValue;
  String tagDropdownValue;

  // BorderSide All, News, Blog button
  BorderSide _allButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
  BorderSide _newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
  BorderSide _blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);

  // Sample data of the post list
  final List _postListData = [
    {
      'title': '1 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '1 Description, description, description, description, description, description, description, description, description, description'
    },
    {
      'title': '2 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '2 Description, description, description, description, description, description, description, description, description, description'
    },
    {
      'title': '3 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '3 Description, description, description, description, description, description, description, description, description, description'
    },
    {
      'title': '4 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '4 Description, description, description, description, description, description, description, description, description, description'
    },
    {
      'title': '5 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '5 Description, description, description, description, description, description, description, description, description, description'
    },
    {
      'title': '6 title title title title title title title title title',
      'image': 'images/sample.jpg',
      'description': '6 Description, description, description, description, description, description, description, description, description, description'
    }
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: _buildBody(context),
    );
  }

  /// APP BAR
  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,

      // Search button
      leading: IconButton(
        icon: _searchIcon,
        onPressed:() => _searchPressed(),
      ),

      // Dropdown button
      actions: <Widget>[
        IconButton(
            icon: _arrowDrop,
            onPressed: _arrowDropPressed,
        ),
      ],

      // Bottom AppBar
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(_heightBottomAppBar),
        child: _bottomAppBar(),
      ) ,
    );
  }

  /// BOTTOM APP BAR
  Widget _bottomAppBar() {
    return Container(
      height: _heightBottomAppBar,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[

          // Category dropdown button and Tag dropdown button
          Container(
            height: 48.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                // Category dropdown button
                Expanded(
                  flex: 5,
                  child: Container(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: categoryDropdownValue,
                        hint: Text(
                          'Category',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        style: null,
                        underline: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                        onChanged: (String value) {
                          setState(() {
                            categoryDropdownValue = value;
                          });
                        },
                        items: _categories.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                // Tag dropdown button
                Expanded(
                  flex: 5,
                  child: Container(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          value: tagDropdownValue,
                          hint: Text(
                            'Tag',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          style: null,
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                          onChanged: (String value) {
                            setState(() {
                              tagDropdownValue = value;
                            });
                          },
                          items: _tags.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                      ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
          ),

          SizedBox(height: 4.0),

          // All, News, Blog button
          Container(
              height: 38.0,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // All button
                    Expanded(
                        flex: 1,
                        child:  RaisedButton(
                          color: Colors.blue,
                          shape: UnderlineInputBorder(
                            borderSide: _allButtonBorderSide,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Text(
                            'All',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed:() => _allPressed(),
                        )
                    ),

                    // News button
                    Expanded(
                        flex: 1,
                        child:  RaisedButton(
                          color: Colors.blue,
                          shape: UnderlineInputBorder(
                            borderSide: _newsButtonBorderSide,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Text(
                            'News',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed:() => _newsPressed(),
                        )
                    ),

                    // Blog button
                    Expanded(
                        flex: 1,
                        child:  RaisedButton(
                          color: Colors.blue,
                          shape: UnderlineInputBorder(
                            borderSide: _blogButtonBorderSide,
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Text(
                            'Blog',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed:() => _blogPressed(),
                        )
                    )
                  ]
              )
          )
        ],
      ),
    );
  }

  /// BODY
  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
          children: <Widget>[
            // Post list
            Expanded(
              child: _buildPostList(context),
            ),

            // Create post button
            Container(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        "Create Post",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                      onPressed: _createPostPressed,
                    )
                )
            )
          ]
      ),
    );
  }

  /// Posts ListView
  Widget _buildPostList(BuildContext context) {
    // Post List
      return ListView.builder(
        itemCount: _postListData.length,
        itemBuilder: (context, index) {
          return  ListTile(
            title:  Card(
                elevation: 2,
                child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Title
                          Text(
                            _postListData[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(height: 10.0),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Image
                              Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                    _postListData[index]['image'],
                                    fit: BoxFit.contain
                                ),
                              ),

                              SizedBox(width: 10.0),

                              // Description
                              Container(
                                  child: Expanded(
                                      child: Text(
                                          _postListData[index]['description'],
                                      ),
                                  )
                              ),
                            ],
                          ),
                        ],
                    ),
                ),
            ),

            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetail()));
            },
          );
        }
      );
  }


  /// EVENT PRESS BUTTON

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _searchController,
          autofocus: true,
          decoration:  InputDecoration(
              hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Search for posts');
        _searchController.clear();
      }
    });
  }

  void _arrowDropPressed() {
    setState(() {
      if (this._arrowDrop.icon == Icons.arrow_drop_up) {
        this._arrowDrop = Icon(
          Icons.arrow_drop_down,
          semanticLabel: 'arrow drop down',
        );

        _heightBottomAppBar = 0.0;
      } else {
        this._arrowDrop = Icon(
          Icons.arrow_drop_up,
          semanticLabel: 'arrow drop up',
        );

        _heightBottomAppBar = 90.0;
      }
    });
  }

  void _allPressed() {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
    });
  }

  void _newsPressed() {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
    });
  }

  void _blogPressed() {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
    });
  }

  void _createPostPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost()));
  }

}





