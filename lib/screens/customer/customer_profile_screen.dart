import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/dialogs.dart';
import 'package:gmach1/model/gmach_model.dart';
import 'package:gmach1/model/user_model.dart';

import '../../database.dart';

class CustomerProfileScreen extends StatefulWidget {
  final UserModel profile;

  const CustomerProfileScreen({Key key, this.profile}) : super(key: key);

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _email;
  String _phone;
  String _address;
  String _description;
  String _remarks;

  @override
  void initState() {
    super.initState();

    // init state vars
    _name = widget.profile?.name;
    _email = widget.profile?.email;
    _phone = widget.profile?.phone;
    _address = "?"; //widget.profile?.address;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Profile'),
          actions: [
            FlatButton(onPressed: _saveChanges, child: Text("Save changes"))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue)),
                        const SizedBox(height: 12),
                        Text(_email),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue)),
                      TextFormField(
                        initialValue: _name,
                        onSaved: (val) => _name = val,
                        decoration: InputDecoration(hintText: "name.."),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ListTile(
                  //   title: FutureBuilder<String>(
                  //       future: DatabaseService.getGamchEmail(
                  //           FirebaseAuth.instance.currentUser.uid),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.done) {
                  //           if (snapshot.hasData) {
                  //             return Text(snapshot.data);
                  //           }
                  //         }
                  //         return Text('');
                  //       }),
                  // ),
                  // ListTile(
                  //   title: FutureBuilder<String>(
                  //       future: DatabaseService.getGamchPhone(
                  //           FirebaseAuth.instance.currentUser.uid),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.done) {
                  //           if (snapshot.hasData) {
                  //             return Text(snapshot.data);
                  //           }
                  //         }
                  //         return Text('');
                  //       }),
                  // ),
                  // ListTile(
                  //   title: FutureBuilder<String>(
                  //       future: DatabaseService.getGamchAddress(
                  //           FirebaseAuth.instance.currentUser.uid),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.connectionState ==
                  //             ConnectionState.done) {
                  //           if (snapshot.hasData) {
                  //             return Text(snapshot.data);
                  //           }
                  //         }
                  //         return Text('');
                  //       }),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

//
//
// title: FutureBuilder<String>(
// future:  DatabaseService.getGamchModel(FirebaseAuth.instance.currentUser.uid),
// builder: (context, snapshot) {
// if(snapshot.connectionState == ConnectionState.done){
// if(snapshot.hasData){
// return Text('Welcome ${snapshot.data}!');
// }
// }
// return Text('');
// }
// ),

//
// Widget _buildData() {
//   return FutureBuilder<List<GmachModel>>(
//       future: DatabaseService.getGamchProduct(
//           FirebaseAuth.instance.currentUser.uid),
//       builder:
//           (BuildContext context, AsyncSnapshot<List<GmachModel>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return Text('error');
//             //add one more condition for no products at all(first enter for example).
//           }
//
//           List<GmachModel> products = snapshot.data;
//
//
//           if(products.isEmpty){
//             return Text('no products yet..click to add one');
//           }
//
//           // return the list widget
//           return ListView.builder(
//             itemBuilder: (context, index) {
//               return ProductItem(product: products[index]);
//             },
//             itemCount: products.length,
//           );
//         }
//         // waiting for completion
//         return Center(child: CircularProgressIndicator());
//       });
// }

  void _saveChanges() {
    // bool _approveChanges;
    // final dialoga = AlertDialog(
    //
    //   title: Text("aaa"),
    //   content: Text("bbbb"),
    //   actions: [
    //     //Navigator.pop(context);
    //     FlatButton(
    //         onPressed: () {
    //           // _approveChanges = true;
    //           Navigator.pop(context);
    //         },
    //         child: Text("NO")),
    //     FlatButton(
    //         onPressed: () {
    //           // _approveChanges = false;
    //           Navigator.pop(context);
    //         },
    //         child: Text("yes")),
    //   ],
    // );
    // showDialog(context: context, builder: (_) => dialoga);
    // if (!_approveChanges) {
    //   return;
    // }
    final form = _formKey.currentState;
    form.save();

    if (!form.validate()) {
      return;
    }

    // update the db
    final gid = FirebaseAuth.instance.currentUser.uid;

    Map<String, dynamic> childrenMap = {
      'name': _name,
      'phone': _phone,
      'address': _address,
      'description': _description,
      'remarks': _remarks,
    };

    DatabaseService.updateGmachProfile(gid, childrenMap);
  }
}

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String userName ="";
//   String userName2 ="";
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       body: Column(
//         children: [
//           ListTile(title: Text('fff'),subtitle: Text(userName2),),
//           FlatButton(child: Text('clickMe'), onPressed: () async{
//             print('dkjfkdf');
//             ddd();
//             userName = await ddd();
//             setState(() async {
//               userName2 = userName;
//             });
//
//
//              print(userName);
//           } )
//         ],
//       ),
//     );
//     // return Container(
//     //   child: Column(
//     //     children :[
//     //
//     //   floatingActionButton: FloatingActionButton()
//     //     ListTile(title: Text('Name:'),subtitle:Text('ss'),),
//     //    //      ListTile(title: Text('Address:'),subtitle:Text(document["address"]) ,),
//     //    //      ListTile(title: Text('Description:'),subtitle:Text(document["description"]) ,),
//     //    //      ListTile(title: Text('OpeningHours:'),subtitle:Text(document["openingHours"]) ,),
//     //    //      ListTile(title: Text('Phone number:'),subtitle:Text(document["phone"]) ,),
//     //   ]),
//     // );
//   }
//
//
//   Future<String>  ddd() async
//   {
//     DocumentSnapshot abc = await  FirebaseFirestore.instance.collection('gmachs').doc(FirebaseAuth.instance.currentUser.uid).get();
//     String dataField =abc.get('name');
//     return dataField;
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProfileScreen extends StatefulWidget {
//   ProfileScreen({Key key}) : super(key: key);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final db = FirebaseFirestore.instance;
//   final uid = FirebaseAuth.instance.currentUser.uid;
//   //
//   // List<int> items = new List();
//   //
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   for (int i = 0; i < 20; ++i) {
//   //     items.add(i);
//   //   }
//   //   super.initState();
//   // }
//
//    Future<List<Widget>>  makeListWidget(AsyncSnapshot snapshot) async {
//     return snapshot.data.documents.map<Widget>((document) async {
//       return Center(
//         child: Column(
//           children: [
//             // await FirebaseFirestore.instance.collection('gmachs').doc('FQAbBSV9ZnfOg4d0DVRpyw3Qmbf1').update({'address': 'Jerusalem Har Nof'});
//
//
//
//             ListTile(title: Text('Name:'),subtitle:Text(await db.collection('gmachs').doc(uid).get().then((value) => value.data()['name'])) ,),
//             ListTile(title: Text('Address:'),subtitle:Text(document["address"]) ,),
//             ListTile(title: Text('Description:'),subtitle:Text(document["description"]) ,),
//             ListTile(title: Text('OpeningHours:'),subtitle:Text(document["openingHours"]) ,),
//             ListTile(title: Text('Phone number:'),subtitle:Text(document["phone"]) ,),
//
//
//
//           ],
//         ),
//       );
//     }).toList();
//   }
//
//   //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: StreamBuilder(
//             stream: FirebaseFirestore.instance.collection('gmachs').snapshots(),
//             builder: (context, snapshot) {
//               if(snapshot.data == null) return CircularProgressIndicator();
//               return ListView(children: makeListWidget(snapshot));
//             }),
//       ),
//     );
//   }
// }
//
// // backgroundColor: Colors.white,
// // body: new ListView.builder(
// // itemCount: items.length,
// // itemBuilder: (BuildContext context, int index) {
// // return new ListTile(
// // title: new Text('item no: $index'),
// // trailing: new Icon(Icons.arrow_forward),
// // );
// // }),
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class ProfileScreen extends StatefulWidget {
// //   ProfileScreen({Key key}) : super(key: key);
// //
// //   @override
// //   _ProfileScreenState createState() => _ProfileScreenState();
// // }
// //
// // class _ProfileScreenState extends State<ProfileScreen> {
// //   //
// //   // List<int> items = new List();
// //   //
// //   // @override
// //   // void initState() {
// //   //   // TODO: implement initState
// //   //   for (int i = 0; i < 20; ++i) {
// //   //     items.add(i);
// //   //   }
// //   //   super.initState();
// //   // }
// //
// //   List<Widget> makeListWidget(AsyncSnapshot snapshot) {
// //     return snapshot.data.documents.map<Widget>((document) {
// //       return Center(
// //         child: Column(
// //           children: [
// //
// //             ListTile(title: Text('Name:'),subtitle:Text(document["name"]) ,),
// //             ListTile(title: Text('Address:'),subtitle:Text(document["address"]) ,),
// //             ListTile(title: Text('Description:'),subtitle:Text(document["description"]) ,),
// //             ListTile(title: Text('OpeningHours:'),subtitle:Text(document["openingHours"]) ,),
// //             ListTile(title: Text('Phone number:'),subtitle:Text(document["phone"]) ,),
// //
// //
// //
// //           ],
// //         ),
// //       );
// //     }).toList();
// //   }
// //
// //   //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         child: StreamBuilder(
// //             stream: FirebaseFirestore.instance.collection('gmachs').snapshots(),
// //             builder: (context, snapshot) {
// //               if(snapshot.data == null) return CircularProgressIndicator();
// //               return ListView(children: makeListWidget(snapshot));
// //             }),
// //       ),
// //     );
// //   }
// // }
// //
// // // backgroundColor: Colors.white,
// // // body: new ListView.builder(
// // // itemCount: items.length,
// // // itemBuilder: (BuildContext context, int index) {
// // // return new ListTile(
// // // title: new Text('item no: $index'),
// // // trailing: new Icon(Icons.arrow_forward),
// // // );
// // // }),
