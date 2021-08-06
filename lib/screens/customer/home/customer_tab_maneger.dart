import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:gmach1/dialogs.dart';
import 'package:gmach1/model/gmach_model.dart';
import 'package:gmach1/model/user_model.dart';
import 'package:gmach1/screens/about_screen.dart';
import 'package:gmach1/screens/global%20screen/settings_screen.dart';
// import 'package:gmach1/screens/try_screen.dart';

import '../cart_screen.dart';
import '../customer_profile_screen.dart';
import 'tabs.dart';
import '../../../database.dart';

//change number 1
//change222
//change Debo 3
class CustomerTabManager extends StatefulWidget {
  @override
  _CustomerTabManagerState createState() => _CustomerTabManagerState();
}

class _CustomerTabManagerState extends State<CustomerTabManager> {
  final Dialogs dialog =  Dialogs();
  String data = "";


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: choices.length,
        child: Scaffold(
          drawer:  Drawer(
            child:  ListView(
              children: [
                // FutureBuilder<String>(
                //     future: DatabaseService.getGamchModel(
                //         FirebaseAuth.instance.currentUser.uid),
                //     builder:
                //         (BuildContext context,
                //         AsyncSnapshot<String> snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         if (snapshot.hasError) {
                //           return Text('error');
                //           //add one more condition for no products at all(first enter for example).
                //         }
                //
                //         //products = name
                //       String products = snapshot.data;
                //         print("4444444444444444444444 " + products);
                //
                //
                //         if (products.isEmpty) {
                //           return Text('no products yet..click to add one');
                //         }
                //         //return products;
                //         List<ProductModel> aa ;
                //      //   return the list widget
                //         return ListView.builder(
                //           itemBuilder: (context, index) {
                //             return ProductItem(product: aa[index]);
                //           },
                //           itemCount: 1,
                //         );
                //
                //         // return the list widget
                //         // return ListView.builder(
                //         //   itemBuilder: (context, index) {
                //         //     return ProductItem(product: products[index]);
                //         //   },
                //         //   itemCount: products.length,
                //         // );
                //       }
                //       // waiting for completion
                //       return Center(child: CircularProgressIndicator());
                //     }),
                 ListTile (

                  //(uid).get().then((value) => value.data()['name'])) ,)
                  // // await FirebaseFirestore.instance.collection('gmachs').doc('FQAbBSV9ZnfOg4d0DVRpyw3Qmbf1').set({'name' : 'bamba'});
                  title: FutureBuilder<UserModel>(
                    future:  DatabaseService.getUSerModel(FirebaseAuth.instance.currentUser.uid),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                          if(snapshot.hasData){
                             return Text('Welcome ${snapshot.data.name ?? 'User'}!');
                          }
                      }
                      return Text('');
                    }
                  ),
                 // leading:  Icon(Icons.person),
                ),
                ListTile(
                  title:  Text("Settings"),
                  leading:  Icon(Icons.settings),
                  onTap: () =>
                      Navigator.of(context).push( MaterialPageRoute(
                          builder: (
                              BuildContext context) =>  SettingsScreen())),
                ),
                 ListTile(
                  title:  Text("About"),
                  leading:  Icon(Icons.copyright),
                  onTap: () =>
                      Navigator.of(context).push( MaterialPageRoute(
                          builder: (
                              BuildContext context) =>  AboutScreen())),
                ),
                ListTile(
                  title: Text("Profile"),
                  leading: Icon(Icons.account_circle),
                  onTap: () async {

                    // calling api

                    UserModel profile = await DatabaseService.getUSerModel(FirebaseAuth.instance.currentUser.uid);
                    Navigator.of(context).push( MaterialPageRoute(
                      builder: (
                          BuildContext context) => CustomerProfileScreen(
                        profile: profile,
                      )));
                  },
                ),
                ListTile(
                  title: Text("Terms"),
                  leading: Icon(Icons.adb_rounded),
                  onTap: () => Dialogs.showTerms(context),
                ),
                ListTile(
                  title: Text("My Carrt"),
                  leading: Icon(Icons.shopping_cart),
                  onTap: () async {

                    // calling api


                    // GmachModel profile = await DatabaseService.getGamchModel2(FirebaseAuth.instance.currentUser.uid);
                    // Navigator.of(context).push( MaterialPageRoute(
                    //     builder: (
                    //         BuildContext context) => CustomerProfileScreen(
                    //       profile: profile,
                    //     )));

                    Navigator.of(context).push( MaterialPageRoute(
                        builder: (
                            BuildContext context) => CartScreen(

                        )));

                  },
                ),

              ],
            ),
          ),
          appBar: AppBar(
            title: const Text('GMACH4U'),
            actions: [
              FlatButton.icon(
                icon: Icon(Icons.logout),
                onPressed: () {
                  dialog.confirm(
                      context, 'Log Out', 'Are you sure you want to Log Out?');
                },
                label: Text('Log  Out'),
              )
            ],
            bottom: TabBar(
                isScrollable: true,
                tabs: choices
                    .map((choice) =>
                    Tab(text: choice.title, icon: Icon(choice.icon)),)
                    .toList()),
          ),
          body: TabBarView(
            children: [
              SearchProductsTab(),
              MyBorrowedProductsTab(),
              GmachesTab(),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getUserName() async
  {
    DocumentSnapshot abc = await FirebaseFirestore.instance.collection('gmachs')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    String dataField = abc.get('name');
    return dataField;
  }


}

class Choise {
  final String title;
  final IconData icon;

  const Choise({this.title, this.icon});
}

const List<Choise> choices = <Choise>[
  Choise(title: 'Search Products', icon: Icons.search),
  Choise(title: 'My Borrowed products', icon: Icons.hail),
  Choise(title: 'Gmaches', icon: Icons.business),
  //Choise(title: 'Profile', icon: Icons.account_circle),
  // Choise(title: 'Try', icon: Icons.account_tree_outlined),
];

class ChoicePage extends StatelessWidget {
  const ChoicePage({Key key, this.choice}) : super(key: key);
  final Choise choice;

  @override
  Widget build(BuildContext context) {
    //final TextStyle textStyle = Theme.of(context).textTheme.display1;
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              choice.icon,
              size: 150.0,
              color: textStyle.color,
            ),
            Text(
              choice.title,
              style: textStyle,
            )
          ],
        ),
      ),
    );
    //throw UnimplementedError();
  }
}
