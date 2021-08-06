import 'package:checkbox_formfield/checkbox_list_tile_formfield.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/model/gmach_model.dart';
import 'package:gmach1/screens/shared/search_city/search_city_dialog.dart';
import 'package:gmach1/utils/location_helper.dart';

import '../../dialogs.dart';
import '../login_screen.dart';

// int selectedUserType;
//
// @override
// void initState() {
//   super.initState();
//   selectedUserType = 0;
// }
//
// setSelectUserType(int val)
// {
//   setState((){
//     selectedUserType =val;
//   });
// }

class GmachUserRegisterScreen extends StatefulWidget {
  @override
  _GmachUserRegisterScreenState createState() => _GmachUserRegisterScreenState();
}

class _GmachUserRegisterScreenState extends State<GmachUserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  String _phone;
  String _address;
  String _userType = "";
  bool _termsAgree = false;
  bool _isLoading = false;
  GmachModel currentUser;

  TextEditingController _addressTextController;

  @override
  void initState() {
    super.initState();
    _addressTextController = TextEditingController();
  }


  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  // String _groupValue;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Dialogs.exitConfirm(
            context, 'Exit Gmach', 'Are you sure you want to Exit Gmach?'),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Gmach register'),
            ),
            body: Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: TextFormField(
                          onSaved: (val) => _name = val,
                          validator: (val) {
                            return val.isNotEmpty
                                ? null
                                : "name can't be blank";
                          },
                          decoration: InputDecoration(
                            hintText: 'Name:',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          onSaved: (val) => _phone = val,
                          validator: (val) {
                            return val.isNotEmpty
                                ? null
                                : "phone  can't be blank";
                          },
                          decoration: InputDecoration(
                            hintText: 'Phone:',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          readOnly: true,
                          onTap: _openCityDialog,
                          controller: _addressTextController,
                          onSaved: (val) => _address = val,
                          validator: (val) {
                            return val.isNotEmpty
                                ? null
                                : "Address  can't be blank";
                          },
                          decoration: InputDecoration(
                            hintText: 'Address:',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          onSaved: (val) => _email = val,
                          validator: (val) {
                            return val.isNotEmpty
                                ? null
                                : "Email can't be blank";
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your mail..',
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          //  keyboardType: TextInputType.number,
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
                      SizedBox(height: 5),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CheckboxListTileFormField(
                                title: Text("Agree Terms of use"),
                                initialValue: _termsAgree,
                                onSaved: (val) => _termsAgree = val,
                                validator: (val) {
                                  return _termsAgree
                                      ? null
                                      : "You must agree to the terms!";
                                },
                              ),
                            ),
                            TextButton(
                              child: Text('Show Terms'),
                              onPressed: () {
                                Dialogs.showTerms(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   child: CheckboxListTileFormField(
                      //     initialValue: _termsAgree,
                      //     onSaved: (val) => _termsAgree = val,
                      //     validator: (val) {
                      //       return _termsAgree
                      //           ? null
                      //           : "You must agree to the terms!";
                      //     },
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      if (_isLoading) ...[
                        CircularProgressIndicator(),
                      ],
                      SizedBox(height: 5),
                      RaisedButton(
                        child: Text('Register'),
                        onPressed: registerUser,
                        color: Colors.green[600],
                      ),
                      RaisedButton(
                        child: Text('Go To Login'),
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                      ),

                    ],
                  ),
                ),
              ),
            )));
  }

  void registerUser() async {
    final form = _formKey.currentState;
    form.save();

    if (!form.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print('create user using firebase auth');
    var createdUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );



    // await DatabaseService(uid: FirebaseAuth.instance.currentUser.uid)
    //.updateUserDate('0', 'davidlevi', 3);
    // move to home screen

    //$ add uid for gmach collection:
    currentUser = new GmachModel(name: _name, address: _address, phone: _phone);
    await FirebaseFirestore.instance
        .collection('gmachs')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'name': _name,
      'address': _address,
      'email': _email,
      'phone': _phone,
      'userType': _userType,
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));

    createdUser.user.sendEmailVerification();

    //await FirebaseFirestore.instance.collection('gmachs').add()
  }

  void _openCityDialog() async {
    var dialog = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 400,
        child: SearchCityScreen(),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('close'),
          //AppLocalizations().translate("close")),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );

    City city = await showDialog(context: context, builder: (_) => dialog, useRootNavigator: false);

    if(city != null){

      setState(() {
        _addressTextController.text = city.englishName;
      });

    }
  }
}
