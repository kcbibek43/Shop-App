import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
 class OrderItems {  
 final String id;
 final double amount;
 final List<CartItem1> products;
 final DateTime dateTime;
  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
} 

class Orders with ChangeNotifier{  
 List<OrderItems> _orders = [];
 List<OrderItems> get orders {
  return [..._orders];
 }
//  Future<void> fetchAndSetOrders() async{
//   final Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/orders.json');
//   final respose = await http.get(url);
//   final List<OrderItems> loadedOrders = [];
//   final extractedData = json.decode(respose.body) as Map<String , dynamic>;
//   if(extractedData == null){
//     return ;
//   }
//   extractedData.forEach((orderId,orderData){
//   loadedOrders.add(OrderItems(id: orderId, amount: orderData['amount'],
//    products: (orderData['product'] as List<dynamic>).map((item)=>
//    CartItem1(
//     id: item['id'], 
//     title: item['title'],
//    quantity: item['quantity'],
//    price: item['price'],)
//    ).toList(), 
//    dateTime: DateTime.parse(orderData['dateTime'])));
//   });
//   _orders = loadedOrders.reversed.toList();
//   notifyListeners();
//  }
 void addOrder(List<CartItem1> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
} 