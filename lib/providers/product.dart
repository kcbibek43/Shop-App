import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier {
   final String id;
   final String title;
   final String description;
   final double price;
   final String imageUrl;
  late bool isFavroite;  
  Product({
  required this.id,
  required this.title,
  required this.description,
  required this.imageUrl,
  required this.price,
  required this.isFavroite,
  });
  void _setFuvValue(bool newValue){
     isFavroite = newValue;
       notifyListeners();
  }
  Future<void> toggleFavoriteStatus() async{
    final oldStatus = isFavroite;
    isFavroite = !isFavroite;
    notifyListeners();
      final Uri url = Uri.parse('https://shop-appu-default-rtdb.firebaseio.com/products/$id.json');
      try{
    final response =  await http.patch(url,
      body: json.encode({
        'isFavorite': isFavroite,
      })
      );
      if (response.statusCode>=400){
      _setFuvValue(oldStatus);
      }
      }catch(error){
       _setFuvValue(oldStatus);
      }
  }
   } 