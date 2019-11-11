import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:training_flutter/animation/fading_circle.dart';
import 'package:training_flutter/animation/slide_right_route.dart';
import 'package:training_flutter/main_models/main_model.dart';
import 'package:training_flutter/screen/create_post.dart';
import 'package:training_flutter/screen/post_detail.dart';
import 'package:training_flutter/model_sqlite/post.dart';
import 'package:training_flutter/data_sqlite/database_helper.dart';
import 'package:training_flutter/data_sqlite/query/post_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:training_flutter/theme/color.dart';
import 'dart:math' as math;

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

  static final BorderSide selectedBorderSide = BorderSide(color: Colors.white, width: 4.0);
  static final BorderSide noSelectedBorderSide = BorderSide(color: kPostPink300, width: 4.0);

  // BorderSide All, News, Blog button
  BorderSide _allButtonBorderSide = selectedBorderSide;
  BorderSide _newsButtonBorderSide =  noSelectedBorderSide;
  BorderSide _blogButtonBorderSide =  noSelectedBorderSide;

  var _postListData = new List<Post>(); // SQLite data of the post list
  List<Post> _allPosts; // List all posts
  bool _isLoading;

  PostQuery postQuery = new PostQuery(); // post query

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

          if (_allPosts == null) {
            _allPosts = new List<Post>();
            _isLoading = true;
            updateListView();
          }
          _postListData = loadPosts(model.searchText, model.categorySelect, model.tagSelect, model.postTypeSelect);

          return Scaffold(
            key: _scaffoldKey,
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
                    ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Text(
                        "Create Post",
                        style: Theme.of(context).textTheme.button,
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
            return GestureDetector(
              child: Card(
                elevation: 4.0,
                margin: EdgeInsets.all(10.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // Title
                          Expanded(
                            child: Text(
                              _postListData[index].title,
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),

                          PopupMenuButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) => _showMenuSelection(context, value, _postListData[index]),
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                ),
                              ),
                              PopupMenuDivider(height: 10),
                              const PopupMenuItem<String>(
                                value: 'Delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Image
                          Hero(
                            tag: "${_postListData[index].id}",
                            flightShuttleBuilder: (
                              BuildContext flightContext,
                              Animation<double> animation,
                              HeroFlightDirection flightDirection,
                              BuildContext fromHeroContext,
                              BuildContext toHeroContext,
                            ) {
                              final Hero toHero = toHeroContext.widget;

                              return ScaleTransition(
                                scale: animation.drive(
                                  Tween<double>(begin: 0.0, end: 1.0).chain(
                                    CurveTween(
                                      curve: Interval(0.0, 1.0,
                                          curve: PeakQuadraticCurve()
                                      ),
                                    ),
                                  ),
                                ),
                                child: flightDirection == HeroFlightDirection.push
                                    ? RotationTransition(
                                        turns: animation,
                                        child: toHero.child,
                                    )
                                    : FadeTransition(
                                        opacity: animation.drive(
                                          Tween<double>(begin: 0.0, end: 1.0).chain(
                                            CurveTween(
                                              curve: Interval(0.0, 1.0,
                                                  curve: ValleyQuadraticCurve()
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: toHero.child,
                                    ),
                              );
                            },
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              child: Image.memory(
                                  Base64Decoder().convert(_postListData[index].image),
                                  fit: BoxFit.contain
                              ),
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
                Navigator.push(
                  context,
                  SlideRightRoute(widget: PostDetail(post: _postListData[index])),
                );
              },
            );
          }
      );
    } else {
      return Card(
        elevation: 4.0,
        margin: EdgeInsets.all(10.0),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _isLoading
              ? Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Loading',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Expanded(
                        child: SpinKitFadingCircle(
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven ? kPostPink100 : kPostPink400
                              ),
                            );
                          },
                          size: 100.0,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'No data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Expanded(
                      child: FlareActor(
                        'assets/nodata.flr',
                        animation: 'idle',
                      )
                    )
                  ],
                ),
              )
            ],
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
      this._allButtonBorderSide = selectedBorderSide;
      this._newsButtonBorderSide = noSelectedBorderSide;
      this._blogButtonBorderSide = noSelectedBorderSide;
      model.postTypeSelect = '';
    });
  }

  void _newsPressed(model) {
    setState(() {
      this._allButtonBorderSide = noSelectedBorderSide;
      this._newsButtonBorderSide =  selectedBorderSide;
      this._blogButtonBorderSide =  noSelectedBorderSide;
      model.postTypeSelect = 'News';
    });
  }

  void _blogPressed(model) {
    setState(() {
      this._allButtonBorderSide = noSelectedBorderSide;
      this._newsButtonBorderSide = noSelectedBorderSide;
      this._blogButtonBorderSide = selectedBorderSide;
      model.postTypeSelect = 'Blog';
    });
  }

  void _createPostPressed() {
    final Post post = new Post('', '', '', '', '', '', '', '', '', '');
    _navigateToDetail('Create Post', post);
  }

  // Redirect to Create/Edit post screen and update all post list
  void _navigateToDetail(String title, Post post) async {
    var result = await Navigator.push(
      context,
      SlideRightRoute(widget: CreatePost(title, post)),
    );

    if (result == true) {
      updateListView();
    }
  }

  // Get Post list from database
  void updateListView() {
    DatabaseHelper databaseHelper = DatabaseHelper();

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Post>> postListFuture = postQuery.getPostList();
      postListFuture.then((postList) {
        setState(() {
          _allPosts = postList;
          _isLoading = false;
        });
      });
    });
  }

  // Load the post list after searching
  List<Post> loadPosts(String searchText, String categorySelect, String tagSelect, String postTypeSelect) {
    List<Post> dummySearchList = List<Post>();
    dummySearchList.addAll(_allPosts);

    if(searchText != '') {
      dummySearchList = dummySearchList.where((Post p) {
        return p.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }

    if(categorySelect != '' && categorySelect != 'All') {
      dummySearchList = dummySearchList.where((Post p) {
        return p.category == categorySelect;
      }).toList();
    }

    if(tagSelect != '' && tagSelect != 'All') {
      dummySearchList = dummySearchList.where((Post p) {
        return p.tags.contains(tagSelect);
      }).toList();
    }

    if(postTypeSelect != '') {
      dummySearchList = dummySearchList.where((Post p) {
        return p.postType == postTypeSelect;
      }).toList();
    }

    return dummySearchList;
  }

  // Delete or edit the post
  void _showMenuSelection(BuildContext context, String value, Post post) {
    if (value == 'Edit') {
      Post postTemp = new Post.withId(post.id, post.title, post.image, post.description,
          post.content, post.author, post.postType, post.category, post.tags, post.url, post.createdDate);
      _navigateToDetail('Edit Post', postTemp);
    } else {
      _showDeleteDialog(context, post);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _deletePost(BuildContext context, Post post) async {
    int result = await postQuery.deletePost(post.id);
    if (result != 0) { // Success
      _showSnackBar(context, 'Post Deleted Successfully');
      updateListView();
    } else {  // Failure
      _showSnackBar(context, 'Problem Deleted Post');
    }
  }

  void _showDeleteDialog(BuildContext context, Post post) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
              title: Text('Are you want to delete?'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context); //close the dialog box
                    _deletePost(context, post);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context); //close the dialog box
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ]
          );
        }
    );
  }

}


class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return 4 * math.pow(t - 0.5, 2);
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return -15 * math.pow(t, 2) + 15 * t + 1;
  }
}
