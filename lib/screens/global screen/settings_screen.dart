import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen( {Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new Center(
      child: Column(
        children: [
          RaisedButton(
            child: Text('Register as customer'),
            onPressed: () {
              changeColor();
            },
          ),
        ],
      ),
      ),
      backgroundColor: Colors.yellow,
    );
  }
 void changeColor (){
    print ("bamba");
  }
}
