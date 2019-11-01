import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  String _searchText = '';
  String _categorySelect = '';
  String _tagSelect = '';
  String _postTypeSelect = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
  }

  String get categorySelect => _categorySelect;

  set categorySelect(String value) {
    _categorySelect = value;
  }

  String get postTypeSelect => _postTypeSelect;

  set postTypeSelect(String value) {
    _postTypeSelect = value;
  }

  String get tagSelect => _tagSelect;

  set tagSelect(String value) {
    _tagSelect = value;
  }

}