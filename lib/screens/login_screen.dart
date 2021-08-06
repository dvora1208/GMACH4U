import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dialogs.dart';
import 'customer/customer_user_register_screen.dart';
import 'customer/home/customer_tab_maneger.dart';
import 'gmach screen/gmach_user_register_screen.dart';
import 'gmach screen/tab_maneger.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  final Dialogs dialog = new Dialogs();
  bool _isGmach = true;

  bool _isLoading = false;

  //function that build the screen
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Dialogs.exitConfirm(
            context, 'Exit Gmach', 'Are you sure you want to Exit Gmach?'),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Login'),
            ),
            body: Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      child: TextFormField(
                        onSaved: (val) => _email = val,
                        validator: (val) {
                          if (!val.isNotEmpty)
                            return "Email can't be blank";
                          else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_email))
                            return "email format not corect";
                          else
                            return null;
                          // return val.isNotEmpty ? null : "Email can't be blank";
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your mail..',
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: TextFormField(
                        //    keyboardType: TextInputType.number,
                        obscureText: true,
                        onSaved: (val) => _password = val,
                        validator: (val) {
                          return val.isNotEmpty
                              ? null
                              : "Password can't be blank";
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password..',
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    if (_isLoading) ...[
                      CircularProgressIndicator(),
                    ],
                    RaisedButton(
                      child: Text('Login as Gmach'),
                      onPressed: loginGmach,
                      color: Colors.green[600],
                    ),
                    RaisedButton(
                      child: Text('Login as user'),
                      onPressed: loginUser,
                      color: Colors.green[600],
                    ),
                    RaisedButton(
                      child: Text(' Register as Gmach  '),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => GmachUserRegisterScreen()));
                      },
                    ),
                    RaisedButton(
                      child: Text('Register as customer'),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CustomerUserRegisterScreen()));
                      },
                    ),
                    // FlatButton(
                    //   onPressed: _sendEmailVerification,
                    //   child: Text('Verify email'),
                    // )
                  ],
                ),
              ),
            )));
  }

  void loginGmach() async {
    final form = _formKey.currentState;
    form.save();
    if (!form.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // if we got here form is valid
    print('create user using firebase auth');
    try {
      // user == null
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      // user == FirebseUser

      if (!FirebaseAuth.instance.currentUser.emailVerified) {
        print('user email not verified!');

        final dialog = AlertDialog(
          title: Text('Email is not verified'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Please verify your email"),
              InkWell(
                child: Text(
                  'send me an email',
                  style: TextStyle(
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.currentUser.sendEmailVerification();
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );

        showDialog(context: context, builder: (_) => dialog, useRootNavigator: false);

        setState(() {
          _isLoading = false;
        });
        return;
      }

      //navigate to tab manager screen

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => TabManager()));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isGmach', true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // dialog error
      print(e);
      Dialogs.information(
          context, "Authentication problem", "Username or password incorrect");
    }
  }

  //if the validation is corect change is loading(the gif) is true its start to thinking
  void loginUser() async {
    final form = _formKey.currentState;
    form.save();
    if (!form.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    // if we got here form is valid
    print('create user using firebase auth');
    try {
      // user == null
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      // user == FirebseUser

      if (!FirebaseAuth.instance.currentUser.emailVerified) {
        print('user email not verified!');

        final dialog = AlertDialog(
          title: Text('Email is not verified'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Please verify your email"),
              InkWell(
                child: Text(
                  'send me an email',
                  style: TextStyle(
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.currentUser.sendEmailVerification();
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );

        showDialog(context: context, builder: (_) => dialog);

        setState(() {
          _isLoading = false;
        });
        return;
      }

      //navigate to tab manager screen

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => CustomerTabManager()));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isGmach', false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // dialog error
      print(e);
      Dialogs.information(
          context, "Authentication problem", "Username or password incorrect");
    }
  }
}
