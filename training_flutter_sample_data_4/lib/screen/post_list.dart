import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:training_flutter/main_models/main_model.dart';
import 'package:training_flutter/model_sample_data/post.dart';
import 'package:training_flutter/model_sample_data/posts_repository.dart';
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
  final List<String> _categories = ['All', 'Game', 'Phần Mềm', 'Học Lập Trình'];
  final List<String >_tags = ['All', 'Hành động', 'Thể thao', 'Chiến thuật', 'Nhập vai', 'Lập trình', 'Học tập', 'Công cụ', 'Python', 'Java'];

  // Category, Tag dropdown value
  String categoryDropdownValue;
  String tagDropdownValue;

  // BorderSide All, News, Blog button
  BorderSide _allButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
  BorderSide _newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
  BorderSide _blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);

  // Sample data of the post list
  var _postListData = new List<Post>();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          if(model.categorySelect != ''){
            categoryDropdownValue = model.categorySelect;
          }

          if(model.tagSelect != ''){
            tagDropdownValue = model.tagSelect;
          }

          _postListData = PostsRepository.loadPosts(model.searchText, model.categorySelect, model.tagSelect, model.postTypeSelect);

          return Scaffold(
            appBar: _buildBar(context, model),
            body: _buildBody(context),
            resizeToAvoidBottomInset: false,
          );
        }
    );
  }

  /// APP BAR
  Widget _buildBar(BuildContext context, MainModel model) {
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,

      // Search button
      leading: IconButton(
        icon: _searchIcon,
        onPressed:() => _searchPressed(model),
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
        child: _bottomAppBar(model),
      ) ,
    );
  }

  /// BOTTOM APP BAR
  Widget _bottomAppBar(MainModel model) {
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
                          model.categorySelect = categoryDropdownValue;
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
                            model.tagSelect = tagDropdownValue;
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
                          onPressed:() => _allPressed(model),
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
                          onPressed:() => _newsPressed(model),
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
                          onPressed:() => _blogPressed(model),
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
    if (_postListData.length > 0) {
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
                        _postListData[index].title,
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
                            child: Image.memory(
                                Base64Decoder().convert(_postListData[index].image),
                                fit: BoxFit.contain
                            ),
                          ),

                          SizedBox(width: 10.0),

                          // Description
                          Container(
                              child: Expanded(
                                child: Text(
                                  _postListData[index].description,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetail(post: _postListData[index])));
              },
            );
          }
      );
    } else {
      return  ListTile(
        title:  Card(
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'No data or your search terms did not match any definitions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }


  /// EVENT PRESS BUTTON

  void _searchPressed(model) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        _searchController.text = model.searchText;
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _searchController,
          autofocus: true,
          decoration:  InputDecoration(
              hintText: 'Search...'
          ),
          onChanged: (value) {
            setState(() {
              model.searchText = value;
            });
          },
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

  void _allPressed(model) {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      model.postTypeSelect = '';
    });
  }

  void _newsPressed(model) {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      model.postTypeSelect = 'News';
    });
  }

  void _blogPressed(model) {
    setState(() {
      this._allButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._newsButtonBorderSide =  BorderSide(color: Colors.blue, width: 4.0);
      this._blogButtonBorderSide =  BorderSide(color: Colors.white, width: 4.0);
      model.postTypeSelect = 'Blog';
    });
  }

  void _createPostPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost()));
  }

}
