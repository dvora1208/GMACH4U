import 'package:flutter/material.dart';
import 'package:gmach1/model/product_model.dart';

class CartProductModel {
  final String productId;
  final ProductModel product;
  int daysToBorrow;
  int quantity;

  CartProductModel({
    @required this.productId,
    @required this.product,
    this.daysToBorrow = 1,
    this.quantity = 1,
  });
}
