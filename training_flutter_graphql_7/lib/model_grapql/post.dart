class Post {
  
  String _id;
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
  
  
  String get id => _id;

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


  @override
  bool operator ==(other) => other is Post && other.id == id;

  @override
  int get hashCode => id.hashCode;
  
}