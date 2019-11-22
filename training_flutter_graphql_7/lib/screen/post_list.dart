import 'package:flare_flutter/flare_actor.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:training_flutter/animation/fading_circle.dart';
import 'package:training_flutter/animation/slide_right_route.dart';
import 'package:training_flutter/main_models/main_model.dart';
import 'package:training_flutter/screen/create_post.dart';
import 'package:training_flutter/screen/post_detail.dart';
import 'package:training_flutter/theme/color.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:training_flutter/global.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:training_flutter/controller/category_controller.dart';
import 'package:training_flutter/controller/tag_controller.dart';
import 'package:training_flutter/service/query_mutation.dart';
import 'package:training_flutter/model_grapql/post.dart';


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
  List<String> _categories = ['All'];
  List<String >_tags = ['All'];

  // Category, Tag dropdown value
  String categoryDropdownValue;
  String tagDropdownValue;

  static final BorderSide selectedBorderSide = BorderSide(color: Colors.white, width: 4.0);
  static final BorderSide noSelectedBorderSide = BorderSide(color: kPostPink300, width: 4.0);

  // BorderSide All, News, Blog button
  BorderSide _allButtonBorderSide = selectedBorderSide;
  BorderSide _newsButtonBorderSide =  noSelectedBorderSide;
  BorderSide _blogButtonBorderSide =  noSelectedBorderSide;

  var _postListData = new List<Post>(); // Posts list contains search results
  Set<Post> _allPosts = new Set<Post>(); // List post get from server
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getInitData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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

        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(context, model),
          body: _buildBody(context, model),
          resizeToAvoidBottomInset: false,
        );
      }
    );
  }

  /// APP BAR
  Widget _buildAppBar(BuildContext context, MainModel model) {
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
        child: _buildBottomAppBar(model),
      ),
    );
  }

  /// BOTTOM APP BAR
  Widget _buildBottomAppBar(MainModel model) {
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
                ),
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
                  ),
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
                  ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// BODY
  Widget _buildBody(BuildContext context, MainModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          // Post list
          Expanded(
            child: _buildPostsQuery(context, model),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create posts query to get posts data from server
  Widget _buildPostsQuery(BuildContext context, MainModel model) {
    QueryMutation queryMutation = QueryMutation();
    int _nRepositories = 3;
    
    return Query(
      options: QueryOptions(
        document: queryMutation.getPosts(),
        variables: {
          'nRepositories': _nRepositories,
        },
      ),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if (result.loading && result.data == null) {
          return _buildLoading();
        }

        if (result.hasErrors) {
          String errors = result.errors.join(', \n');
          return _buildErrorPostsQuery(context, errors);
        }

        if (result.data == null) {
          return _buildNoData();
        }

        // CASE: get post data from server successful
        final List<dynamic> posts = result.data['posts']['edges'] as List<dynamic>;
        _fillPostList(posts);
        _postListData = _searchPosts(model.searchText, model.categorySelect, model.tagSelect, model.postTypeSelect);

        // This is returned by the GraphQL API for pagination purpose
        final Map pageInfo = result.data['posts']['pageInfo'];
        final String fetchMoreCursor = pageInfo['endCursor'];
        
        final int totalCount = result.data['posts']['totalCount']; // total count items in post list

        FetchMoreOptions opts = FetchMoreOptions(
          variables: {'cursor': fetchMoreCursor},
          updateQuery: (previousResultData, fetchMoreResultData) {
            List<dynamic> previousList = previousResultData['posts']['edges'];
            List<dynamic> fetchMoreList = fetchMoreResultData['posts']['edges'];
            bool duplicate = false;
    
            int fetchMoreListLen = fetchMoreList.length;
            int previousListLen = previousList.length;
            for(int i = 0; i < fetchMoreListLen; i++) {
              for(int j = previousListLen - 1; j >= 0; j--) {
                if(fetchMoreList[i]['node']['id'] == previousList[j]['node']['id']){
                  duplicate = true;
                  break;
                }
              }
            }
    
            // this is where you combine your previous data and response
            // in this case, we want to display previous repos plus next repos
            // so, we combine data in both into a single list of repos
            List<dynamic> repos = [];
            if(duplicate) {
              repos = [...previousList];
            } else {
              repos = [
                ...previousList,
                ...fetchMoreList
              ];
            }
    
            // to avoid a lot of work, lets just update the list of repos in returned
            // data with new data, this also ensure we have the endCursor already set correctly
            fetchMoreResultData['posts']['edges'] = repos;
    
            return fetchMoreResultData;
          },
        );

        _scrollController
          ..addListener(() {
            if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
              if (!result.loading && _allPosts.length < totalCount) {
                fetchMore(opts);
              }
            }
          });

        return _buildPostList(context, result.loading);
      }
    );
  }
  
  Widget _buildLoading() {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                'Loading',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SpinKitFadingCircle(
                itemBuilder: (_, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? kPostPink100 : kPostPink400
                    ),
                  );
                },
                size: 80.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNoData() {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text(
                'No data',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: FlareActor(
                  'assets/nodata.flr',
                  animation: 'idle',
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPostsQuery(BuildContext context, String errors) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Errors',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child:  SingleChildScrollView(
                      child: Text('$errors'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: FlareActor(
                      'assets/error.flr',
                      animation: 'Error',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  /// Fill posts data into list view
  Widget _buildPostList(BuildContext context, bool loading) {
    if (_postListData.length == 0) {
      return _buildNoData();
    }

    return ListView(
      controller: _scrollController,
      children: <Widget>[
        for (var post in _postListData)
          GestureDetector(
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
                            post.title,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                    
                        PopupMenuButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.more_vert),
                          onSelected: (value) => _showMenuSelection(context, value, post),
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              ),
                            ),
                            
                            PopupMenuDivider(height: 10),
                            
                            PopupMenuItem<String>(
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
                          tag: "${post.id}",
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
                                      curve: PeakQuadraticCurve(),
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
                                          curve: ValleyQuadraticCurve(),
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
                            child: Image.network(
                              post.image,
                              fit: BoxFit.contain
                            ),
                          ),
                        ),
                    
                        SizedBox(width: 10.0),
                    
                        // Description
                        Container(
                          child: Expanded(
                            child: Text(
                              post.description,
                            ),
                          ),
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
                SlideRightRoute(widget: PostDetail(post: post)),
              );
            },
          ),
    
        SizedBox(height: 10.0),
    
        if (loading)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
    
        SizedBox(height: 10.0),
      ],
    );
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
    }
  }

  // Load the post list after searching
  List<Post> _searchPosts(String searchText, String categorySelect, String tagSelect, String postTypeSelect) {
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
//    if (value == 'Edit') {
//      Post postTemp = new Post.withId(post.id, post.title, post.image, post.description,
//        post.content, post.author, post.postType, post.category, post.tags, post.url, post.createdDate);
//      _navigateToDetail('Edit Post', postTemp);
//    } else {
//      _showDeleteDialog(context, post);
//    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _deletePost(BuildContext context, Post post) async {
//    int result = await postQuery.deletePost(post.id);
//    if (result != 0) { // Success
//      _showSnackBar(context, 'Post Deleted Successfully');
//      updateListView();
//    } else {  // Failure
//      _showSnackBar(context, 'Problem Deleted Post');
//    }
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
                Navigator.pop(context); // close the dialog box
                _deletePost(context, post);
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // close the dialog box
              },
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ]
        );
      }
    );
  }

  // Get categories and tags data
  void _getInitData() async {
    await CategoryController.getCategories();
    await TagController.getTags();

    setState(() {
      for(var category in CATEGORIES) {
        _categories.add(category['name']);
      }
  
      for(var tag in TAGS) {
        _tags.add(tag['name']);
      }
    });
  }

  // Fill posts data from server into _allPosts list
  void _fillPostList(List<dynamic> posts) {
    int postsLen = posts.length;

    for (int i = 0; i < postsLen; i++) {
      String tags = '';
      int tagsLen = posts[i]['node']['tags']['edges'].length;

      for (int j = 0; j < tagsLen; j++) {
        tags += posts[i]['node']['tags']['edges'][j]['node']['name'];
        if (j != tagsLen - 1) {
          tags += ', ';
        }
      }

      _allPosts.add(
        Post.withId(
          posts[i]['node']['id'],
          posts[i]['node']['title'],
          "${SERVER_NAME}public/images/" + posts[i]['node']['image'],
          posts[i]['node']['description'],
          posts[i]['node']['content'],
          posts[i]['node']["author"]['username'],
          toBeginningOfSentenceCase(posts[i]['node']['postType'].toLowerCase()),
          posts[i]['node']['category']['name'],
          tags,
          posts[i]['node']['url'],
          posts[i]['node']['createdDate'],
        )
      );
    }
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
