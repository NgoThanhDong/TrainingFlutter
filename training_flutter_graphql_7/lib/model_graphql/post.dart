class Post {
  
  String _id;
  String _title;
  String _image;
  String _description;
  String _content;
  String _author;
  String _postType;
  String _categoryId;
  String _categoryName;
  List _tagsId;
  String _tagsName;
  String _url;
  String _createdDate;
  
  
  Post(this._title, this._image, this._description, this._content, this._author, this._postType,
      this._categoryId, this._categoryName, this._tagsId, this._tagsName, this._url, this._createdDate);
  
  Post.withId(this._id, this._title, this._image, this._description, this._content, this._author, this._postType,
      this._categoryId, this._categoryName, this._tagsId, this._tagsName, this._url, this._createdDate);
  
  
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
  
  String get categoryId => _categoryId;
  
  set categoryId(String value) {
    _categoryId = value;
  }
  
  String get categoryName => _categoryName;
  
  set categoryName(String value) {
    _categoryName = value;
  }
  
  List get tagsId => _tagsId;
  
  set tagsId(List value) {
    _tagsId = value;
  }
  
  String get tagsName => _tagsName;
  
  set tagsName(String value) {
    _tagsName = value;
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