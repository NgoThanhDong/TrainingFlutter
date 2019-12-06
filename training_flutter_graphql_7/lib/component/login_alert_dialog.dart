import 'package:flutter/material.dart';
import 'package:training_flutter/controller/user_controller.dart';
import 'package:training_flutter/global.dart';
import 'package:training_flutter/theme/color.dart';


class LoginAlertDialog extends StatefulWidget {
  @override
  _LoginAlertDialogState createState() => _LoginAlertDialogState();
}

class _LoginAlertDialogState extends State<LoginAlertDialog> {
  
  // Controller for username, password
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  
  String errors = '';
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Login account'),
      content: Container(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 90.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
                
                if (errors.isNotEmpty) Container(
                    padding: EdgeInsets.only(top: 160.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        errors,
                        style: TextStyle(color: kPostErrorRed),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
            child: Text('Login'),
            
            onPressed: () {
              _loginAccount();
            }
        ),
      ],
    );
  }
  
  void _loginAccount() async {
    final String _username = _usernameController.text.trim();
    final String _password = _passwordController.text.trim();
    
    String resultLogin = await UserController.login(_username, _password);
    
    if (ACCESS_TOKEN.isEmpty) {
      if(resultLogin.isNotEmpty) {
        setState(() {
          errors = resultLogin;
        });
      }
    } else {
      USERNAME = _username;
      Navigator.of(context).pop();
      _showLoginSuccessDialog();
    }
  }
  
  void _showLoginSuccessDialog() {
    Widget loginSuccessWidget = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'Logged in successfully ',
          style: TextStyle(
            fontSize: 18,
            color: Colors.green,
          ),
        ),
        WidgetSpan(
          child: new Icon(
            Icons.insert_emoticon,
            color: Colors.amber,
          ),
        ),
      ]),
    );
    
    // Show login success message
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: loginSuccessWidget,
        )
    );
  }
}
