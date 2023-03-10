import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/product.dart';
import '../providers/products.dart';
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';
//   Future<void> _refreshProduct (BuildContext context) async{
//  await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
//   }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
      actions: [
        IconButton(
          onPressed: (){
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        }, icon: Icon(Icons.add),)
      ],
      ),
     drawer: AppDrawer(),
      body: Padding(padding: const EdgeInsets.all(8),
        child: ListView.builder(itemBuilder: ((_, i) {
         return Column(
           children: [
             UserProductItem(
              productsData.items[i].id,
              productsData.items[i].title,
              productsData.items[i].imageUrl),
             const Divider(),
           ],
         );
        }
        ),
        itemCount: productsData.items.length,
        ),
        )
    );
  }
}