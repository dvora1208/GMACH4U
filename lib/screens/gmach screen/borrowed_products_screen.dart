import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmach1/model/enum.dart';
import '../../database.dart';
import '../../model/borrowed_product_model.dart';
import '../../utils/extesions/date_ext.dart';

class BorrowedProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildCart());
  }

  Widget _buildCart() {
    return FutureBuilder<List<MapEntry<String, BorrowedProductDetailedModel>>>(
      future: DatabaseService.readBorrowedProducts(FirebaseAuth.instance.currentUser.uid, UserType.GMACH),
      builder: (context, AsyncSnapshot<List<MapEntry<String, BorrowedProductDetailedModel>>> snapshot) {
        if(snapshot.connectionState != ConnectionState.done){
          return Center(child: CircularProgressIndicator());
        }

        // if(snapshot.hasError){
        //   return Center(child: Text("error : ${snapshot.error ?? ''}"));
        // }

        var productsList = snapshot.data ?? [];
        return productsList.isEmpty
            ? _buildEmptyMessage()
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
          separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 2,
                  thickness: 1,
                  color: Colors.blueAccent,
                ),
              );
          },
              itemCount: productsList.length,
              itemBuilder: (context, index) =>
                  ProductListItem(item: productsList[index].value)),
            );
      },);

  }
  Widget _buildEmptyMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.list, size: 48),
        Text("There aren't items here, they will be added as you borrow one")
      ],
    );
  }
}

class ProductListItem extends StatelessWidget {
  final BorrowedProductDetailedModel item;

  const ProductListItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: CachedNetworkImage(
              imageUrl: item.product.image,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(item.product.name)),
                // Text("Borrowed at: ${DateExtensions.getSimpleDay(item.borrowedDate)}"),
                Text("Borrowed at: ${item.borrowedDate.getSimpleDay}"),
                // $$$$
                Text("Date To return: ${item.returnDate.getSimpleDay}"),
                Text("Borrowed By: ${item.user.name}"),
                Text("Items Borrowed: ${item.quantity}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
