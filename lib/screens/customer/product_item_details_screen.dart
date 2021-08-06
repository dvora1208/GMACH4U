import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gmach1/database.dart';
import 'package:gmach1/local_database/local_database.dart';
import 'package:gmach1/model/cart_product_model.dart';
import 'package:gmach1/model/product_model.dart';
import 'package:gmach1/screens/customer/purchase_product_screen.dart';

class ProductItemDetailsScreen extends StatelessWidget {
  final ProductModel selectedProduct;
  final String productId;

  const ProductItemDetailsScreen(
      {Key key, @required this.selectedProduct, @required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(selectedProduct.name ?? "Product")),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _image(),
            const SizedBox(height: 14),
            Text(
              "Some description:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(selectedProduct.description),
            _askButton(context),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Center(
      child: CachedNetworkImage(
        width: 200,
        height: 200,
        imageUrl: selectedProduct.image,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/not_found.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _askButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _openAskDialog(context),
        child: Text("Ask to save product"),
      ),
    );
  }

  void _openAskDialog(BuildContext context) {
    int count = 1;//selectedProduct.count;
    int daysToBorrow = 1;
    int maxDays = selectedProduct.maxBorrowDays;

    var dialog = AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 90),
      title: Text("Ask a product"),
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
                        if (daysToBorrow < maxDays) {
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
              print("count=$count");
              Navigator.pop(context);

              //add to 'cart'
              LocalDatabaseHelper().addProduct(CartProductModel(
                  productId: productId,
                  product: selectedProduct,
                  daysToBorrow: daysToBorrow,
                  quantity: count,
              ));
            },
            child: Text("Add To Cartt")),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );

    showDialog(
        context: context, builder: (_) => dialog, useRootNavigator: false);
  }
}
