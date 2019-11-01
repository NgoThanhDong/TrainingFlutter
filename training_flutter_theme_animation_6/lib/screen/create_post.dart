import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:intl/intl.dart';
import 'package:training_flutter/data_sqlite/query/post_query.dart';
import 'package:training_flutter/model_sqlite/post.dart';
import 'package:training_flutter/theme/accent_color_override.dart';
import 'package:training_flutter/theme/color.dart';


class CreatePost extends StatefulWidget {

  // Attribute
  final String appBarTitle;
  final Post post;

  // Constructor
  CreatePost(this.appBarTitle, this.post);

  @override
  _CreatePostState createState() => _CreatePostState(this.appBarTitle, this.post);
}

class _CreatePostState extends State<CreatePost> {

  String appBarTitle;
  Post post;
  _CreatePostState(this.appBarTitle, this.post);


  /// ATTRIBUTE

  final _formKey = new GlobalKey<FormState>(); // form key

  // List object of Author, Post Type, Category, Tag
  final List<String> _author = ['Author 1', 'Author 2', 'Author 3'];
  final List<String> _postType = ['News', 'Blog'];
  final _category = ['Game', 'Phần Mềm', 'Học Lập Trình'];
  final _tags = ['Hành động', 'Thể thao', 'Chiến thuật', 'Nhập vai', 'Lập trình', 'Học tập', 'Công cụ', 'Python', 'Java'];

  // Author, Post Type, Category, Tags dropdown value
  String authorDropdownValue;
  String postTypeDropdownValue;
  String categoryDropdownValue;
  List tagsDropdownValue;

  // Image
  File _image; // File select image from Camera/Gallery
  Widget _imageError; // Error message for image
  Widget _noImageSelected = new Container(
    width: 360.0,
    height: 240.0,
    child: Image.asset(
      'images/no_image_selected.png',
      fit: BoxFit.fill,
    ),
  );
  Widget _imageSelected;

  PostQuery postQuery = new PostQuery(); // Post query

  // Controller for title, description, content, url
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Get data fields of the post
    _titleController.text = post.title;
    _descriptionController.text = post.description;
    _contentController.text = post.content;
    _urlController.text = post.url;

    if (post.author != '') authorDropdownValue = post.author;
    if (post.postType != '') postTypeDropdownValue = post.postType;
    if (post.category != '') categoryDropdownValue = post.category;
    if (post.tags != '') tagsDropdownValue = post.tags.split(', ');
    if (post.image != '') {
      _imageSelected = Image.memory(
        Base64Decoder().convert(post.image),
        fit: BoxFit.contain,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Form(
            key: _formKey,
            autovalidate: true,
            child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Title Text Field
                      AccentColorOverride(
                        color: kPostBrown900,
                        child: TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            post.title = _titleController.text;
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      // Select Image
                      GestureDetector(
                        child: Center(
                          child: post.image == ''
                              ? _noImageSelected
                              :  Container(
                            width: 360.0,
                            height: 240.0,
                            child: _imageSelected,
                          ),
                        ),
                        onTap: () {
                          _showDialog();
                        },
                      ),

                      // Validation image
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: _imageError,
                      ),

                      SizedBox(height: 10),

                      // Description Text Field
                      AccentColorOverride(
                        color: kPostBrown900,
                        child:TextFormField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          minLines: 3,
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            post.description = _descriptionController.text;
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      // Content Text Field
                      AccentColorOverride(
                        color: kPostBrown900,
                        child: TextFormField(
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          minLines: 10,
                          maxLines: 100,
                          decoration: InputDecoration(
                            labelText: 'Content',
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            post.content = _contentController.text;
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      // Author dropdown button
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                          value: authorDropdownValue,
                          hint: Text(
                            'Select author',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              authorDropdownValue = newValue;
                              post.author = authorDropdownValue;
                            });
                          },
                          validator: (String value) {
                            if (value?.isEmpty ?? true) {
                              return '\t\t\t\tPlease select one option';
                            }
                          },
                          items: _author.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onSaved: (val) => setState(() => post.author = val),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Post type dropdown button
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                          value: postTypeDropdownValue,
                          hint: Text(
                            'Select post type',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              postTypeDropdownValue = newValue;
                              post.postType = postTypeDropdownValue;
                            });
                          },
                          validator: (String value) {
                            if (value?.isEmpty ?? true) {
                              return '\t\t\t\tPlease select one option';
                            }
                          },
                          items: _postType.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onSaved: (val) => setState(() => post.postType = val),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Category dropdown button
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<String>(
                          value: categoryDropdownValue,
                          hint: Text(
                            'Select category',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              categoryDropdownValue = newValue;
                              post.category = categoryDropdownValue;
                            });
                          },
                          validator: (String value) {
                            if (value?.isEmpty ?? true) {
                              return '\t\t\t\tPlease select one option';
                            }
                          },
                          items: _category.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onSaved: (val) => setState(() => post.category = val),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Tags dropdown button
                      Container(
                        child: MultiSelect(
                          autovalidate: false,
                          titleText: 'Select tags',
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return '\tPlease select one or more options';
                            }
                          },
                          dataSource: _dataSourceTags(),
                          textField: 'display',
                          valueField: 'value',
                          filterable: false,
                          required: true,
                          value: tagsDropdownValue,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              tagsDropdownValue = value;
                            });
                            post.tags = this.tagsDropdownValue.toString();
                          },
                          initialValue: tagsDropdownValue,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Url Text Field
                      AccentColorOverride(
                        color: kPostBrown900,
                        child: TextFormField(
                          controller: _urlController,
                          decoration: InputDecoration(
                            labelText: 'URL',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }

                            final _urlPattern = r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                            final _result = new RegExp(_urlPattern, caseSensitive: false).firstMatch(value);
                            if (_result == null) {
                              return 'Please enter a valid url';
                            }
                            return null;
                          },
                          onChanged: (text) {
                            post.url = _urlController.text;
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      // Create post button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            appBarTitle,
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: _saveForm,
                        ),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }

  // Data source of Tags dropdown
  List _dataSourceTags(){
    List _tagsDS = new List();
    for(int i=0; i < _tags.length; i++){
      _tagsDS.add({
        "display": _tags[i],
        "value": _tags[i],
      });
    }
    return _tagsDS;
  }

  // Get image from source (Camera/Gallery)
  Future _getImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    setState(() {
      _image = image;
      if (image != null) {
        _imageError = new Text('');
        _imageSelected = Image.file(
          _image,
          fit: BoxFit.contain,
        );

        List<int> imageBytes = image.readAsBytesSync();
        post.image = base64Encode(imageBytes);
      }
    });
  }

  // Show Camera/Gallery dialog
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
              title: Text('Camera/Gallery'),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context); //close the dialog box
                    _getImage(ImageSource.gallery);
                  },
                  child: const Text(
                    'Pick From Gallery',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context); //close the dialog box
                    _getImage(ImageSource.camera);
                  },
                  child: const Text(
                    'Take A New Picture',
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

  void _saveForm() async {
    if(post.image == '') {
      setState(() {
        _imageError = new Text(
          '\t\t\t\tPlease choose a image',
          style: TextStyle(
              color: kPostErrorRed,
              fontSize: 12
          ),
        );

        _noImageSelected = Container(
            width: 360.0,
            height: 240.0,
            decoration: BoxDecoration(
                border: Border.all(color: kPostErrorRed),
            ),
            child:  Image.asset(
              'images/no_image_selected.png',
              fit: BoxFit.fill,
            )
        );
      });
    } else {
      var form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        Navigator.pop(context, true);

        int result;
        post.tags = post.tags.substring(1, post.tags.length - 1);
        if(post.id != null) { // Case 1: Update operation
          result = await postQuery.updatePost(post);
        } else { // Case 2: Insert Operation
          post.createdDate = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
          result = await postQuery.insertPost(post);
        }

        if (result != 0) {  // Success
          _showAlertDialog('Status', 'Post Saved Successfully');
        } else {  // Failure
          _showAlertDialog('Status', 'Problem Saving Note');
        }
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
