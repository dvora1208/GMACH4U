import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/local_database/local_database.dart';
import 'package:gmach1/model/borrowed_product_model.dart';
import 'package:gmach1/model/cart_product_model.dart';
import 'package:gmach1/model/enum.dart';

import '../../database.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cart")),
        body: Column(
          children: [
            Expanded(child: _buildCart()),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  child: Text("Order"),
                  onPressed: _completePurchase,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildCart() {
    var cart = DatabaseService.readCart();
    return cart.isEmpty
        ? _buildEmptyMessage()
        : ListView.builder(
            itemBuilder: (context, index) =>
                CartItem(item: cart[index], index: index, refresh: update),
            itemCount: cart.length,
          );
  }

  void update() {
    setState(() {});
  }

  Widget _buildEmptyMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.add_shopping_cart_outlined, size: 48),
        Text("There aren't items here, they will be added as you choose them")
      ],
    );
  }

  Future<void> _completePurchase() async{
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var cart = DatabaseService.readCart();
    for (var item in cart){
      var borrowedProduct= BorrowedProductModel(
        gmachId: item.product.gid,
        userId: FirebaseAuth.instance.currentUser.uid,
        productId: item.productId,
        quantity: item.quantity,
        daysToBorrow: item.daysToBorrow,
        borrowedDate: today,
      );

      String borrowedProductId = await DatabaseService.addBorrowedProduct(borrowedProduct);

      DatabaseService.addToBorrowedList(FirebaseAuth.instance.currentUser.uid, UserType.USER, borrowedProductId);
      DatabaseService.addToBorrowedList(item.product.gid, UserType.GMACH, borrowedProductId);
    }

    setState(() {
      DatabaseService.clearCart();
    });
  }
}

class CartItem extends StatelessWidget {
  final CartProductModel item;
  final int index;
  final VoidCallback refresh;

  const CartItem({Key key, @required this.item, this.index, this.refresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              SizedBox(
                  width: 64,
                  height: 64,
                  child: CachedNetworkImage(
                    imageUrl: item.product.image ?? '',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/not_found.png'),
                    fit: BoxFit.cover,
                  )),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item.product.name}",
                       overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("(${item.quantity} items)",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text("For ${item.daysToBorrow} days"),
                  ],
                ),
              ),
            ],
          )),
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () => _deleteItem(index)),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _editProduct(index, context))
        ],
      ),
    );
  }

  _deleteItem(int index) {
    LocalDatabaseHelper().removeProduct(index);
    this.refresh?.call();
  }

  _editProduct(int index, BuildContext context) async {
    int count = item.quantity;
    int daysToBorrow = item.daysToBorrow;

    var dialog = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 90),
      title: Text("Edit Cart Item"),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("choose Count:"),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (count < 7) {
                          setState(() {
                            count++;
                          });
                        }
                      }),
                  Text("$count"),
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (count > 1) {
                          setState(() {
                            count--;
                          });
                        }
                      }),
                ],
              ),
              Row(
                children: [
                  Text("Time to borrow (in days):"),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (daysToBorrow < item.product.maxBorrowDays) {
                          setState(() {
                            daysToBorrow++;
                          });
                        }
                      }),
                  Text("$daysToBorrow"),
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (daysToBorrow >= 2) {
                          setState(() {
                            daysToBorrow--;
                          });
                        }
                      }),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              Navigator.pop(context, {'count': count, 'days': daysToBorrow});
            },
            child: Text("Update")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );

    Map<String, dynamic> result = await showDialog(
        context: context, builder: (_) => dialog, useRootNavigator: false);

    LocalDatabaseHelper().updateProductDays(index, result['days']);
    LocalDatabaseHelper().updateProductQuantity(index, result['count']);
    this.refresh?.call();
  }
}
