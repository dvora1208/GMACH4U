import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmach1/local_database/local_database.dart';
import 'package:gmach1/model/cart_product_model.dart';
import 'package:gmach1/model/enum.dart';
import 'package:gmach1/model/gmach_model.dart';
import 'package:gmach1/model/user_model.dart';
import 'dart:async';



import 'model/borrowed_product_model.dart';
import 'model/product_model.dart';


class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserDate(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  Stream<QuerySnapshot> get brews {
    return brewCollection.snapshots();
  }

  static Future<List<MapEntry<String, ProductModel>>> getGamchProducts(String gid) async{
    List<MapEntry<String, ProductModel>> products = [];
    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var ids = (gmachSnapshot.get('myProducts') as List).cast<String>();
    for(String productId in ids){
      var productSnapshot = await FirebaseFirestore.instance.doc('products/$productId').get();

      var product = ProductModel.fromMap(productSnapshot.data());
      products.add(MapEntry<String, ProductModel>(productSnapshot.id, product));
    }

    return products;
  }



  static Future<List<String>> getProfileDate(String gid) async{

    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.get('name') as String);
    var email = (gmachSnapshot.get('email') as String);
    var address = (gmachSnapshot.get('address') as String);

    List<String> profileData;
    profileData.add(name);
    return profileData;
  }


  static Future<GmachModel> getGamchModel2(String gid) async{
    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    final gmach = GmachModel.fromMap(gmachSnapshot.data() ?? {});
    return gmach;
  }

  static Future<UserModel> getUSerModel(String gid) async{
    var userSnapshot = await FirebaseFirestore.instance.doc('users/$gid').get();
    final user = UserModel.fromMap(userSnapshot.data());
    return user;
  }



  static Future<void> updateGmachProfile(
      String gid, Map<String, dynamic> children) async {
    await FirebaseFirestore.instance.doc('gmachs/$gid').update(children);
  }

  //return the name of user
  static Future<String> getGamchModel(String gid) async{


    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.data()['name'] ?? '?');


    return name ?? '';
  }

  /////


  static Future<String> getGamchName(String gid) async{


    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.get('name') as String);


    return name ?? '';
  }


  static Future<String> getGamchEmail(String gid) async{


    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.get('email') as String);


    return name ?? '';
  }


  static Future<String> getGamchAddress(String gid) async{


    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.get('address') as String);


    return name ?? '';
  }


  static Future<String> getGamchPhone(String gid) async{


    var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$gid').get();
    var name = (gmachSnapshot.get('phone') as String);


    return name ?? '';
  }



  static Future<void> updateIteam(String gid, Map<String, dynamic> children) async
  {
    await FirebaseFirestore.instance.doc('gmachs/$gid').update(children);
  }

  static Future<void> removeMyProduct(String productId, String userId) async{
    // delete from collection product
    // await FirebaseFirestore.instance.doc('products/$productId').delete();

    // delete from my list
    await FirebaseFirestore.instance.doc('gmachs/$userId').update({
      "myProducts": FieldValue.arrayRemove([productId])
    });
  }

  static Future<List<MapEntry<String, ProductModel>>> getProducts() async {
    List<MapEntry<String, ProductModel>> products = [];
    var productsSnapshot = await FirebaseFirestore.instance.collection('products').get();

    for(var doc in productsSnapshot.docs){
      var product = ProductModel.fromMap(doc.data());
      products.add(MapEntry<String, ProductModel>(doc.id, product));
    }

    return products;
  }

  static Future<int> readProcuctCountLeft(String productId)  async{
    var productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productId).get();
    return productSnapshot.get('count') ?? 0;
  }

  static Future<List<MapEntry<String, BorrowedProductDetailedModel>>> readBorrowedProducts(String userId, UserType usertype)  async{
    var products = <MapEntry<String, BorrowedProductDetailedModel>>[];

    if(usertype == UserType.USER){
      var userSnapshot = await FirebaseFirestore.instance.doc('users/$userId').get();
      UserModel user = UserModel.fromMap(userSnapshot.data());

      for(String borrowedProductId in user.borrowedProducts){
        var borrowedProductSnapshot = await FirebaseFirestore.instance.collection('borrowedProducts').doc(borrowedProductId).get();
        var product = BorrowedProductModel.fromMap(borrowedProductSnapshot.data());

        var detailedProductSnapshot = await FirebaseFirestore.instance.collection('products').doc(product.productId).get();

        var detailedProduct = BorrowedProductDetailedModel(
          borrowedDate: product.borrowedDate,
          daysToBorrow: product.daysToBorrow,
          quantity: product.quantity,
          product: ProductModel.fromMap(detailedProductSnapshot.data())
        );

        products.add(MapEntry<String, BorrowedProductDetailedModel>(borrowedProductSnapshot.id, detailedProduct));
      }

    }
    else if (usertype == UserType.GMACH){
      var gmachSnapshot = await FirebaseFirestore.instance.doc('gmachs/$userId').get();
      var gmach = GmachModel.fromMap(gmachSnapshot.data());

      for(String borrowedProductId in gmach.borrowedProducts){
        var productSnapshot = await FirebaseFirestore.instance.collection('borrowedProducts').doc(borrowedProductId).get();

        try {
          var product = BorrowedProductModel.fromMap(productSnapshot.data());

          var detailedProductSnapshot = await FirebaseFirestore.instance
              .collection('products').doc(product.productId).get();

          var userSnapshot = await FirebaseFirestore.instance.doc(
              'users/${product.userId}').get();

          var detailedProduct = BorrowedProductDetailedModel(
            borrowedDate: product.borrowedDate,
            daysToBorrow: product.daysToBorrow,
            quantity: product.quantity,
            product: ProductModel.fromMap(detailedProductSnapshot.data()),
            user: UserModel.fromMap(userSnapshot.data() ?? {}),
          );


          products.add(MapEntry<String, BorrowedProductDetailedModel>(
              productSnapshot.id, detailedProduct));
        }
        catch(e){
          print(e);
        }
      }
    }

    return products;
  }

  static List<CartProductModel> readCart(){
    return LocalDatabaseHelper().cart;
  }

  static void clearCart(){
    return LocalDatabaseHelper().clear();
  }

  static Future<String> addBorrowedProduct(BorrowedProductModel borrowedProduct) async {
    var newRef =  FirebaseFirestore.instance.collection('borrowedProducts').doc();
    await newRef.set(borrowedProduct.toMap());
    return newRef.id;
  }

  static Future<void> addToBorrowedList(String userId, UserType usertype, String borrowedProductId) async {
    if(usertype == UserType.USER){
      FirebaseFirestore.instance.doc('users/$userId').update({
        "borrowedProducts": FieldValue.arrayUnion([borrowedProductId]),
      });
    }

    if (usertype == UserType.GMACH){
      FirebaseFirestore.instance.doc('gmachs/$userId').update({
          "borrowedProducts": FieldValue.arrayUnion([borrowedProductId]),
      });
    }
  }

}
