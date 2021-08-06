import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TryScreen extends StatefulWidget {
  TryScreen({Key key}) : super(key: key);

  final _uid = FirebaseAuth.instance.currentUser.uid;

  get uid => _uid;


  @override
  _TryScreenState createState() => _TryScreenState();
}


void createData(String uid) async{

  //===========================================================
 // DocumentReference ref = await FirebaseFirestore.instance.collection('users').add({'name' : 'hello3'});
  // await FirebaseFirestore.instance.collection('gmachs').doc('FQAbBSV9ZnfOg4d0DVRpyw3Qmbf1').set({'name' : 'bamba'});
  // await FirebaseFirestore.instance.collection('gmachs').doc('FQAbBSV9ZnfOg4d0DVRpyw3Qmbf1').update({'address': 'Jerusalem Har Nof'});
  // await FirebaseFirestore.instance.collection('gmachs').doc('FQAbBSV9ZnfOg4d0DVRpyw3Qmbf1').update({'phone': '021112223'});
   //await FirebaseFirestore.instance.collection('gmachs').doc(uid).update({'phone': '789'}); //update
  final db = FirebaseFirestore.instance;
  //String ccData;
 //await db.collection('gmachs').doc(uid).get().then((DocumentSnapshot documentSnapshot) => ccData = documentSnapshot.data()['name']);
 //await db.collection('gmachs').doc(uid).get().then((value) => value.data()['name']);
 print('aaaaaaaaaaaaaaaaaaaaaaaa');
 print(await db.collection('gmachs').doc(uid).get().then((value) => value.data()['name']));
 print('aaaaaaaaaaaaaaaaaaaaaaaa');

  //===========================================================

  print('fffffffffffffffff');
  print(FirebaseAuth.instance.currentUser.uid);
  print('fffffffffffffffff');
  print(uid);
}
//
// String Future<String> bee() async {
//   DocumentSnapshot abc = await  FirebaseFirestore.instance.collection('gmachs').doc(FirebaseAuth.instance.currentUser.uid).get();
//   String dataField =abc.get('name');
//   return dataField;
//   //String abc = await  FirebaseFirestore.instance.collection('gmachs').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) => value.get('data'));
//   // return await FirebaseFirestore.instance
//   //     .collection('gmachs')
//   //     .doc(FirebaseAuth.instance.currentUser.uid)
//   //     .get()
//   //     .then((value) => value.data()['name']);
// }

Future<String>  ddd() async
{
  DocumentSnapshot abc = await  FirebaseFirestore.instance.collection('gmachs').doc(FirebaseAuth.instance.currentUser.uid).get();
  String dataField =abc.get('name');
  return dataField;
}

class _TryScreenState extends State<TryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () async{
          //createData(TryScreen()._uid);
          String nametext = await ddd();
          print(nametext);

        },
        textColor: Colors.red, child: Text('hello'),
      ),
    );
  }
}
