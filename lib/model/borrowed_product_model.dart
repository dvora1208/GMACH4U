import 'package:flutter/cupertino.dart';
import 'package:gmach1/model/product_model.dart';

import 'user_model.dart';

class BorrowedProductDetailedModel {
  final ProductModel product;
  final int daysToBorrow;
  final int quantity;
  final DateTime borrowedDate;
  final UserModel user;

  BorrowedProductDetailedModel({
    this.product,
    this.daysToBorrow,
    this.quantity,
    this.borrowedDate,
    this.user,
  });

  DateTime get returnDate => borrowedDate.add(Duration(days: daysToBorrow));
}

class BorrowedProductModel {
  final String productId;

  final String gmachId;
  final String userId;

  final int daysToBorrow;
  final int quantity;
  final DateTime borrowedDate;

  BorrowedProductModel({
    @required this.productId,
    @required this.gmachId,
    @required  this.userId,
    this.daysToBorrow,
    this.quantity,
    this.borrowedDate,
  });

  static BorrowedProductModel fromMap(Map<String, dynamic> map) =>
      BorrowedProductModel(
        productId: map['productId'] ?? '',
        daysToBorrow: map['daysToBorrow'] ?? 0,
        quantity: map['quantity'] ?? 0,
        gmachId: map['gmachId'] ?? '',
        userId: map['userId'] ?? '',
        borrowedDate: DateTime.fromMillisecondsSinceEpoch(map['borrowedDate'] ?? 0),
      );

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'daysToBorrow': daysToBorrow,
    'quantity': quantity,
    'userId': userId,
    'gmachId': gmachId,
    'borrowedDate': borrowedDate.millisecondsSinceEpoch,
  };
//   num DateToMillisec = DateTime.now().millisecondsSinceEpoch;
//   DateTime msToDate = DateTime.fromMillisecondsSinceEpoch(sec);

}
