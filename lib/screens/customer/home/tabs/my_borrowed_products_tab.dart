import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/model/borrowed_product_model.dart';
import 'package:gmach1/model/enum.dart';
import 'package:gmach1/utils/extesions/date_ext.dart';

import '../../../../database.dart';

class MyBorrowedProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildCart());
  }

  Widget _buildCart() {
    return FutureBuilder<List<MapEntry<String, BorrowedProductDetailedModel>>>(
      future: DatabaseService.readBorrowedProducts(FirebaseAuth.instance.currentUser.uid, UserType.USER),
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
          : ListView.builder(
        itemCount: productsList.length,
          itemBuilder: (context, index) =>
              ProductListItem(item: productsList[index].value));
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
               children: [
                 Expanded(child: Text(item.product.name)),
                 // Text("Borrowed at: ${DateExtensions.getSimpleDay(item.borrowedDate)}"),
                 Text("Borrowed at: ${item.borrowedDate.getSimpleDay}"),   // NEW
                 Text("Date To return: ${item.returnDate.getSimpleDay}"),
                 Text("Gmach Id: ${item.product.gid}"),
               ],
             ),
           ),
         ],
      ),
    );
  }
}
