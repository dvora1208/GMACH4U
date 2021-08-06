import 'package:flutter/material.dart';
import 'package:gmach1/database.dart';
import 'package:gmach1/model/product_model.dart';
import 'package:gmach1/screens/gmach%20screen/product_screen.dart';

import '../../product_item_details_screen.dart';

class SearchProductsTab extends StatefulWidget{
  @override
  _SearchProductsTabState createState() => _SearchProductsTabState();
}

class _SearchProductsTabState extends State<SearchProductsTab> {
  String _query = "";
  var _queryTextController = TextEditingController();
  List<MapEntry<String,ProductModel>> _products;
  List<MapEntry<String,ProductModel>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();

    _queryTextController.addListener(() {
      _query = _queryTextController.text;
      _updateList(_query);

    });
  }

  @override
  void dispose() {
    _queryTextController.dispose();
    super.dispose();
  }

  void _updateList(String query){
    _filteredProducts.clear();
    _filteredProducts.addAll(_products);
    _filteredProducts.retainWhere((element) => element.value.name.contains(query));



    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 300, child: TextField(
          controller: _queryTextController,
          decoration: InputDecoration(
            hintText: "I'm Looking for...",
          ),
        )),
        Expanded(child: _productsList()),
      ],
    );
  }

  Widget _productListResult(List<MapEntry<String,ProductModel>> products){
    if(_query.isEmpty){
      return Center(child: Container(child: Text("Please Type to search..."),));
    }
    if (products.isEmpty) {
      return Center(
          child: Text(
            // 'There are no products in your plant\n click the + button to add products.1',
            'The search does not match any existing product.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.green[900]),
          ));
      // Text('no products yet..click to add one');
    }

    // return the list widget
    return ListView.builder(
      itemBuilder: (context, index) {
        return ProductItem(
          product: products[index].value,
          productId: products[index].key,
          onPress: (){

            var product = products[index].value;
            var productId =  products[index].key;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductItemDetailsScreen(
                  selectedProduct: product,
                  productId: productId,
                ),
              ),
            );
          },
        );
      },
      itemCount: products.length,
    );
  }

  Widget _productsList(){
    if(_products != null){
      return _productListResult(_filteredProducts);
    }

    return FutureBuilder<List<MapEntry<String, ProductModel>>>(
        future: DatabaseService.getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<MapEntry<String, ProductModel>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                    child: Text(
                      'There are no products in your plant\n click the + button to add products.2',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.green[900]),
                    )),
              );
              //add condition for no products.
            }
//j
            _products = snapshot.data;
            return Center(child: Container(child: Text("Please Type to search..."),)); //_productListResult(_products);
          }
          // waiting for completion
          return Center(child: CircularProgressIndicator());
        });
  }

}