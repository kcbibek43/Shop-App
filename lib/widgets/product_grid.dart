import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
class ProductsGrid extends StatelessWidget {
 late  final bool showFabs ;
  ProductsGrid(this.showFabs);
  @override
  Widget build(BuildContext context) {
   final productData = Provider.of<Products>(context);
   final products = showFabs ? productData.favroiteItem : productData.items;
    return GridView.builder(itemBuilder:(ctx,i) => ChangeNotifierProvider.value(
      value: products[i],
      child: ProductItem(
          // products[i].id,
          // products[i].imageUrl,
          // products[i].title
          ),
    ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
      childAspectRatio: 3/2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      ),
    );
  }
}