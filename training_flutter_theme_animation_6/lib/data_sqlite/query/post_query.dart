import 'package:sqflite/sqflite.dart';
import 'package:training_flutter/data_sqlite/database_helper.dart';
import 'package:training_flutter/model_sqlite/post.dart';

class PostQuery {

  /// Attribute

  DatabaseHelper databaseHelper = new DatabaseHelper(); // DatabaseHelper

  String postTable = 'post_table';
  String colId = 'id';
  String colTitle = 'title';
  String colImage = 'image';
  String colDescription = 'description';
  String colContent = 'content';
  String colAuthor = 'author';
  String colPostType = 'postType';
  String colCategory = 'category';
  String colTags = 'tags';
  String colUrl = 'url';
  String colCreatedDate = 'createdDate';

  /// Method

  // Fetch Operation: Get all Post objects from database
  Future<List<Map<String, dynamic>>> getPostMapList() async {
    Database db = await databaseHelper.database;
    // var result = await db.rawQuery('SELECT * FROM $postTable order by datetime($colCreatedDate) DESC');
    var result = await db.query(postTable, orderBy: 'datetime($colCreatedDate) DESC');
    return result;
  }

  // Insert Operation: Insert a Post object to database
  Future<int> insertPost(Post post) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(postTable, post.toMap());
    return result;
  }

  // Update Operation: Update a Post object and save it to database
  Future<int> updatePost(Post post) async {
    var db = await databaseHelper.database;
    var result = await db.update(postTable, post.toMap(), where: '$colId = ?', whereArgs: [post.id]);
    return result;
  }

  // Delete Operation: Delete a Post object from database
  Future<int> deletePost(int id) async {
    var db = await databaseHelper.database;
    int result = await db.rawDelete('DELETE FROM $postTable WHERE $colId = $id');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Post List' [ List<Post> ]
  Future<List<Post>> getPostList()  async {
    var postMapList = await getPostMapList(); // Get 'Map List' from database
    int count = postMapList.length;         // Count the number of map entries in db table

    List<Post> postList = List<Post>();
    // For loop to create a 'Post List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      postList.add(Post.fromMapObject(postMapList[i]));
    }
    return postList;
  }

}