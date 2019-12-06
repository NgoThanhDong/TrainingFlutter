import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:training_flutter/theme/accent_color_override.dart';
import 'package:training_flutter/theme/color.dart';
import 'package:training_flutter/model_graphql/post.dart';
import 'package:training_flutter/global.dart';
import 'package:slugify/slugify.dart';
import 'package:training_flutter/controller/post_controller.dart';


class CreatePost extends StatefulWidget {
  
  final String appBarTitle;
  final Post post;
  
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
  
  final List<String> _postType = ['News', 'Blog']; // List object of PostType
  
  // Post Type, Category, Tags dropdown value
  String _postTypeDropdownValue;
  String _categoryDropdownValue;
  List _tagsDropdownValue;
  
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
  
  // Controller for title, description, content, url
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  
  bool _autoValidateTags = false;
  
  @override
  void initState() {
    _getInitData();
    super.initState();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
                    maxLength: 64,
                    decoration: InputDecoration(labelText: 'Title'),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    minLines: 1,
                    maxLines: 3,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      post.title = _titleController.text;
                      _autoValidateTags = true;
                    },
                  ),
                ),
                
                SizedBox(height: 10),
                
                // Select Image
                GestureDetector(
                  child: Center(
                    child: post.image == ''
                        ? _noImageSelected
                        : Container(
                      width: 360.0,
                      height: 240.0,
                      child: _imageSelected,
                    ),
                  ),
                  onTap: () {
                    _showImageDialog();
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
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLength: 300,
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
                
                // Post type dropdown button
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    value: _postTypeDropdownValue,
                    hint: Text(
                      'Select post type',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _postTypeDropdownValue = newValue;
                      });
                    },
                    validator: (String value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select one option';
                      }
                      return null;
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
                  ),
                ),
                
                SizedBox(height: 10),
                
                // Category dropdown button
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<dynamic>(
                    value: _categoryDropdownValue,
                    hint: Text(
                      'Select category',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    onChanged: (var newValue) {
                      setState(() {
                        _categoryDropdownValue = newValue;
                      });
                    },
                    validator: (var value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select one option';
                      }
                      return null;
                    },
                    items: CATEGORIES.map<DropdownMenuItem<dynamic>>((var category) {
                      return DropdownMenuItem<dynamic>(
                        value: category['id'],
                        child: Text(
                          category['name'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                SizedBox(height: 10),
                
                // Tags dropdown button
                Container(
                  child: MultiSelect(
                    initialValue: _tagsDropdownValue,
                    autovalidate: _autoValidateTags,
                    titleText: 'Select tags',
                    validator: (value) {
                      if (value == null || value.length == 0) {
                        return 'Please select one or more options';
                      }
                      return null;
                    },
                    dataSource: _dataSourceTags(),
                    textField: 'display',
                    valueField: 'value',
                    filterable: false,
                    required: true,
                    value: _tagsDropdownValue,
                    onSaved: (value) {
                      if (value == null) return;
                      setState(() {
                        _tagsDropdownValue = value;
                      });
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
          ),
        ),
      ),
    );
  }
  
  // Data source of Tags dropdown
  List _dataSourceTags(){
    List _tagsDS = new List();
    for (var tag in TAGS){
      _tagsDS.add({
        'display': tag['name'],
        'value': tag['id'],
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
        
        post.image = _image.path;
      }
    });
  }
  
  // Show Camera/Gallery dialog
  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          title: Text('Camera/Gallery'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);   // close the dialog box
                _getImage(ImageSource.gallery);
              },
              child: const Text(
                'Pick From Gallery',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: const Text(
                'Take A New Picture',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _saveForm() async {
    if (post.image == '') {
      setState(() {
        _imageError = new Text(
          '    Please choose a image',
          style: TextStyle(
            color: kPostErrorRed,
            fontSize: 12,
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
          ),
        );
      });
    } else {
      var form = _formKey.currentState;
      if (form.validate()) {
        form.save();

        post.title = post.title.trim();
        post.description = post.description.trim();
        post.content = post.content.trim();
        post.author = USER_LOGIN['id'];
        post.postType = _postTypeDropdownValue.toLowerCase();
        post.categoryId = _categoryDropdownValue;
        post.tagsId = _tagsDropdownValue;
        post.url = Slugify(post.title);

        // Upload image
        if (_image != null) {
          String resultUploadImage = await PostController.uploadImage(_image);

          if (resultUploadImage.contains('Problem Uploading Image')){
            _showResultAlertDialog('Upload Image', resultUploadImage);
            return;
          } else {
            post.image = resultUploadImage;
          }
        }

        // Create / Edit post
        if (post.id == null) {  // Case 1:  Create post
          String resultCreatePost = await PostController.createPost(post);
  
          if (resultCreatePost.contains('Problem Creating Post')) {
            _showResultAlertDialog('Create Post', resultCreatePost);
          } else {
            Navigator.pop(context, true);
            _showResultAlertDialog('Create Post', 'Post Created Successfully');
          }
        } else {  // Case 2: Edit post
          String resultEditPost = await PostController.editPost(post);
  
          if (resultEditPost.contains('Problem Editing Post')) {
            _showResultAlertDialog('Edit Post', resultEditPost);
          } else {
            Navigator.pop(context, true);
            _showResultAlertDialog('Edit Post', 'Post Edited Successfully');
          }
        }
      }
    }
  }
  
  void _showResultAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Text(message),
      ),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
  
  void _getInitData() {
    // Get data fields of the post
    _titleController.text = post.title;
    _descriptionController.text = post.description;
    _contentController.text = post.content;
    
    // Keyboard cursor should go to end of line
    _titleController.selection = TextSelection.collapsed(offset: _titleController.text.length);
    _descriptionController.selection = TextSelection.collapsed(offset: _descriptionController.text.length);
    _contentController.selection = TextSelection.collapsed(offset: _contentController.text.length);
    
    if (post.id != null) {
      _postTypeDropdownValue = post.postType;
      _categoryDropdownValue = post.categoryId;
      _tagsDropdownValue = post.tagsId;
      
      _imageSelected = Image.network(
        post.image,
        fit: BoxFit.contain,
      );
    }
  }
  
}
