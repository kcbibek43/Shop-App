import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
 class Products with ChangeNotifier {  
      List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
        isFavroite: false
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
     isFavroite: false
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      isFavroite: false
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      isFavroite: false
    ),
  ];
      
      // var _showFavoriteOnly = false;
      List<Product> get items{
        // if(_showFavoriteOnly) {
        //   return _items.where((prod) => prod.isFavroite).toList();
        // }
        return [..._items];
      }
      // void showFavoriteOnly(){
      //   _showFavoriteOnly = true;
      //   notifyListeners();
      // }
      // void showAll(){
      //   _showFavoriteOnly = false;
      //   notifyListeners();
      // }
      List<Product> get favroiteItem{
        return _items.where((prod) => prod.isFavroite).toList();
      }
  Future<void> updateProduct(String id,Product newProduct)async {
  final prodIndex = _items.indexWhere((prod) =>prod.id == id);
    if(prodIndex >= 0){
   final Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/products/$id.json');
  await http.patch(url,
   body: json.encode({
      'title': newProduct.title,
    'description': newProduct.description,
    'imageUrl': newProduct.imageUrl,
    'price': newProduct.price,
    'isFavroite': newProduct.isFavroite,
   }),
    );
      _items[prodIndex] = newProduct;
         notifyListeners();
  }
}
Future<void> deleteProduct(String id) async{
  final Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/products/$id.json');
  final existingProductIndex = _items.indexWhere((prod) => prod.id==id);
  Product? existingProduct = _items[existingProductIndex];
     _items.removeAt(existingProductIndex);
     notifyListeners();
     final response = await http.delete(url);
     if(response.statusCode>=400){
       _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
     }
    existingProduct = null;
}
     Product findById(String id){
      return _items.firstWhere((prod) => prod.id == id);
 }
 Future<void> fetchAndSetProducts() async{
     Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/products.json');
  try {
       final response = await http.get(url);
      Map<String, dynamic> userData = jsonDecode(response.body);
//      print(response.body);
      if (userData == null){
        return;
      }
      final List<Product> loadedProducts = [];
      userData.forEach((prodId, prodData) {
      Map<String, dynamic> userInfo = jsonDecode(prodData);
        loadedProducts.add(Product(
          id: prodId,
          title: userInfo['title'],
          description: userInfo['description'],
          price: userInfo['price'],
          isFavroite: userInfo['isFavorite'],
          imageUrl: userInfo['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
            rethrow;
      }
  }
Future<void> addProduct(Product product)async {
   
   final Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/products.json');
   try {
     final response = await http.post(url,
   body: json.encode({
    'title': product.title,
    'description': product.description,
    'imageUrl': product.imageUrl,
    'price': product.price,
    'isFavorite': product.isFavroite,
   })
   );
 final newProduct = Product(
      title: product.title,
      id: json.decode(response.body)['name'],
      description:  product.description,
      price: product.price,
      isFavroite: product.isFavroite,
      imageUrl: product.imageUrl
      );
      _items.add(newProduct);
        notifyListeners(); 
   }  catch(error){
     rethrow;
   }
      }
   } 