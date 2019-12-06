import 'package:flutter/material.dart';
import 'package:training_flutter/controller/user_controller.dart';
import 'package:training_flutter/global.dart';

class AccountDrawer extends StatefulWidget {
  @override
  _AccountDrawerState createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  
  String _accountNameText = '_____ _________';
  String _accountEmailText = '_______________@gmail.com';
  Widget _currentAccountPictureWidget = CircleAvatar(
    backgroundColor: Colors.white,
    child: Text(
      "Avatar",
      style: TextStyle(
        fontSize: 18.0,
        color: Colors.blue,
      ),
    ),
  );
  
  @override
  void initState() {
    _getUser();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(_accountNameText),
            accountEmail: Text(_accountEmailText),
            currentAccountPicture: _currentAccountPictureWidget,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.green,
                  ),
                  title: Text('My Account'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: Text('Favorites'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // This container holds the align
          Container(
            // This align moves the children to the bottom
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              // This container holds all the children that will be aligned
              // on the bottom and should not scroll with the above ListView
              child: Container(
                child: Column(
                  children: <Widget>[
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help and Feedback'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _getUser() async {
    if (ACCESS_TOKEN.isNotEmpty){
      await UserController.getUser();
    }
    
    if(USER_LOGIN.isNotEmpty){
      setState(() {
        _accountNameText = USER_LOGIN['username'];
        _accountEmailText = USER_LOGIN['email'];
        _currentAccountPictureWidget = Image.network(USER_LOGIN['avatar']);
      });
    }
  }
  
}
