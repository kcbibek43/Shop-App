import 'package:flutter/material.dart';
 class CartItem1{  
   final String id;
   final String title;
   final int quantity;
   final double price;

   CartItem1(
    {
      required this.id,
      required this.title,
      required this.quantity,
      required this.price }
   );
   } 
 class Cart with ChangeNotifier{
   Map<String , CartItem1> _items = {};
 Map<String,CartItem1> get items{
  return {..._items};
 }
 int get itemCount{
  return _items.length;
 }
 double get totalAmount{
  var total =0.0;
  _items.forEach((key,cartItem){
    total += cartItem.price * cartItem.quantity;
  });
  return total;
 }
 void addItem(String productId,double price,String title){
 if(_items.containsKey(productId)){
  _items.update(productId, (existingCartItem) => CartItem1(
  id: existingCartItem.id,
  title: existingCartItem.title, 
  quantity: existingCartItem.quantity + 1, 
  price:existingCartItem.price));
 }
 else{
   _items.putIfAbsent(productId,() => CartItem1(
    id: DateTime.now().toString(), 
    title: title,
    price: price,
    quantity: 1
    ));
 }
 notifyListeners();
}
void removeItem(String productId){
  _items.remove(productId);
  notifyListeners();
}
void removeSingleItem(String productId){
  if(!_items.containsKey(productId)){
    return ;
  }
if(_items[productId]!.quantity > 1){
  _items.update(productId, (exitstingCartItem) => CartItem1(id: exitstingCartItem.id, title: exitstingCartItem.title, quantity: exitstingCartItem.quantity-1, price: exitstingCartItem.price));
}
else{
  _items.remove(productId);
}
notifyListeners();
}
void clear(){
  _items = {};
  notifyListeners();
}
}