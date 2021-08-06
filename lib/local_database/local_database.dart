import 'package:gmach1/model/cart_product_model.dart';
import 'package:gmach1/model/product_model.dart';

List<CartProductModel> _cart = [
  // CartProductModel(product: ProductModel(name: 'p1'), daysToBorrow: 6, quantity: 8),
  // CartProductModel(product: ProductModel(name: 'p2'), daysToBorrow: 8, quantity: 2),
  // CartProductModel(product: ProductModel(name: 'p3'), daysToBorrow: 3, quantity: 12),
];

class LocalDatabaseHelper{

  List<CartProductModel> get cart => _cart;

  LocalDatabaseHelper._();

  static get instance => LocalDatabaseHelper._();

  factory LocalDatabaseHelper() => instance;

  void addProduct(CartProductModel newProduct){
    _cart.add(newProduct);
  }

  void removeProduct(int index){
    _cart.removeAt(index);
  }

  void updateProductDays(int index, int newDays){
    _cart[index].daysToBorrow = newDays;
  }

  void updateProductQuantity(int index, int newQuantity){
    _cart[index].quantity = newQuantity;
  }

  void clear() {
    _cart.clear();
  }

}