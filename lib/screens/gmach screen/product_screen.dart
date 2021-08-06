import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/database.dart';
import 'package:gmach1/model/product_model.dart';
import 'package:gmach1/screens/customer/product_item_details_screen.dart';

import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class MyGmachProductScreen extends StatefulWidget {
  MyGmachProductScreen({Key key}) : super(key: key);

  @override
  _MyGmachProductScreenState createState() => _MyGmachProductScreenState();
}

class _MyGmachProductScreenState extends State<MyGmachProductScreen> {
  StreamSubscription<DocumentSnapshot> subscription;

  @override
  void initState() {
    //
    super.initState();
    subscription = FirebaseFirestore.instance
        .collection('gmachs')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildData(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddProductScreen()));
        },
      ),
    );
  }

  Widget _buildData() {
    return FutureBuilder<List<MapEntry<String, ProductModel>>>(
        future: DatabaseService.getGamchProducts(
            FirebaseAuth.instance.currentUser.uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<MapEntry<String, ProductModel>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                    child: Text(
                  'There are no products in your plant\n click the + button to add products.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                )),
              );
              //add condition for no products.
            }
//j
            var products = snapshot.data;

            if (products.isEmpty) {
              return Center(
                  child: Text(
                'There are no products in your plant\n click the + button to add products.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.green[900]),
              ));
              // Text('no products yet..click to add one');
            }

            // return the list widget
            return ListView.builder(
              itemBuilder: (_, index) {
                return ProductItem(
                  product: products[index].value,
                  productId: products[index].key,
                  onPress: (){
                    final dialog = AlertDialog(
                      title: Text("Choose Action"),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        )
                      ],
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text("Edit"),
                            leading: Icon(Icons.edit),
                            onTap: () {
                              Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (_)=> EditProductScreen(
                                  productModel: products[index].value,
                                    productId: products[index].key,
                                )));
                            },
                          ),
                          ListTile(
                            title: Text("Delete"),
                            leading: Icon(Icons.delete),
                            onTap: () async {
                              Navigator.pop(context);
                              await DatabaseService.removeMyProduct(products[index].key, FirebaseAuth.instance.currentUser.uid);
                            },
                          ),
                        ],
                      ),
                    );

                    showDialog(
                        context: context,
                        builder: (_) => dialog,
                        useRootNavigator: false);
                  },
                );
              },
              itemCount: products.length,
            );
          }
          // waiting for completion
          return Center(child: CircularProgressIndicator());
        });
  }
}

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final String productId;
  final VoidCallback onPress;

  const ProductItem({Key key, @required this.product, @required this.productId, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return ListTile(
      title: Text(product.name, style: TextStyle(fontSize: 20)),
      subtitle: FutureBuilder(
        // future: DatabaseService.,
        builder: (context, snapshot) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("total: ${product.count} (left : 12)", style: textStyle.copyWith(color:Colors.black)),
              Text("Broken: ${product.count}",style: textStyle.copyWith(color:Colors.red[900])),
            ],
          );
        }
      ),
      leading: CachedNetworkImage(
        width: 80,
        height: 80,
        imageUrl: product.image,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/not_found.png'),
        fit: BoxFit.cover,
      ),
      onTap: () {
        onPress?.call();


      },
    );
  }
}


