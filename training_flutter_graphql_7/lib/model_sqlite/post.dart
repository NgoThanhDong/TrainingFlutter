class Post {
  
  int _id;
  String _title;
  String _image;
  String _description;
  String _content;
  String _author;
  String _postType;
  String _category;
  String _tags;
  String _url;
  String _createdDate;
  

  Post(this._title, this._image, this._description, this._content, this._author,
      this._postType, this._category, this._tags, this._url, this._createdDate);

  Post.withId(this._id, this._title, this._image, this._description, this._content,
      this._author, this._postType, this._category, this._tags, this._url, this._createdDate);
  

  int get id => _id;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get postType => _postType;

  set postType(String value) {
    _postType = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get tags => _tags;

  set tags(String value) {
    _tags = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get createdDate => _createdDate;

  set createdDate(String value) {
    _createdDate = value;
  }

  
  // Convert a Post object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['image'] = _image;
    map['description'] = _description;
    map['content'] = _content;
    map['author'] = _author;
    map['postType'] = _postType;
    map['category'] = _category;
    map['tags'] = _tags;
    map['url'] = _url;
    map['createdDate'] = _createdDate;

    return map;
  }

  // Extract a Post object from map object
  Post.fromMapObject(Map<String, dynamic> obj){
    this._id = obj['id'];
    this._title = obj['title'];
    this._image = obj['image'];
    this._description = obj['description'];
    this._content = obj['content'];
    this._author = obj['author'];
    this._postType = obj['postType'];
    this._category = obj['category'];
    this._tags = obj['tags'];
    this._url = obj['url'];
    this._createdDate = obj['createdDate'];
  }

}