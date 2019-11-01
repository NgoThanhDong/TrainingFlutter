import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  /// ATTRIBUTE

  final _formKey = new GlobalKey<FormState>(); // form key

  // List object of Author, Post Type, Category, Tag
  final List<String> _author = ['Author 1', 'Author 2', 'Author 3'];
  final List<String> _postType = ['News', 'Blog'];
  final _category = ['Category 1', 'Category 2'];
  final _tags = ['Tag 1', 'Tag 2', 'Tag 3', 'Tag 4'];

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
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
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),

                      SizedBox(height: 10),

                      // Select Image
                      GestureDetector(
                        child: Center(
                          child: _image == null
                              ? _noImageSelected
                              :  Container(
                            width: 360.0,
                            height: 240.0,
                            child: Image.file(
                              _image,
                              fit: BoxFit.contain,
                            ),
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
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        minLines: 3,
                        maxLines: 10,
                        decoration: InputDecoration(
                          labelText: "Description",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
                      ),

                      SizedBox(height: 10),

                      // Content Text Field
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        minLines: 10,
                        maxLines: 100,
                        decoration: InputDecoration(
                          labelText: "Content",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontSize: 18.0),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (text) {},
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
                              }).toList()
                          )
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
                              }).toList()
                          )
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
                              }).toList()
                          )
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
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      // Url Text Field
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "URL",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 18.0)
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
                        onChanged: (text) {},
                      ),

                      SizedBox(height: 20),

                      // Create post button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Create Post",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18
                            ),
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

  void _saveForm() {
    if(_image == null) {
      setState(() {
        _imageError =  new Text(
          '\t\t\t\tPlease choose a image',
          style: TextStyle(color: Colors.red[700], fontSize: 12),
        );

        _noImageSelected = Container(
            width: 360.0,
            height: 240.0,
            decoration: BoxDecoration(border: Border.all(color: Colors.red[700])),
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
        Navigator.pop(context);
      }
    }
  }

}
