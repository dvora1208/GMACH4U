import 'package:flutter/cupertino.dart';

class GmachModel {
  final String name;
  final String description;
  final List products;
  final String phone;
  final String address;
  final String remarks;
  final List<String> myProducts;
  final String email;
  final List<String> borrowedProducts;


  GmachModel({
    @required this.name,
    this.description,
    this.products,
    this.phone,
    this.address,
    this.remarks,
    this.myProducts,
    this.email,
    this.borrowedProducts,
  });

  static GmachModel fromMap(Map map) {
    return GmachModel(
      name: map['name'],
      products: map['product'],
      description: map['description'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      remarks: map['remarks'],
      myProducts: (map['myProducts'] ?? []).cast<String>(),
      borrowedProducts: (map['borrowedProducts'] ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'product': products,
    'phone': phone,
    'email': email,
    'myProducts': myProducts,
    'remarks': remarks,
    'address':address,
    'description':description,
  };
}
