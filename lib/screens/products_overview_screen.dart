import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_item.dart';
import '../widgets/badge.dart';
enum  FilterOptions {
 Favorites,
 All,
}
class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteOnly = false;
   var _isInit = true;
  var _isLoading = false;
 @override
  void didChangeDependencies() {
   if(_isInit){
    setState(() {
          _isLoading = true;
    });
    Provider.of<Products>(context).fetchAndSetProducts().then((_){
    setState(() {
          _isLoading = false;
    });
   }
   );
}
   _isInit = false;

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(context,listen: false);
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My Shoppe',),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
              if(selectedValue == FilterOptions.Favorites){
              _showFavoriteOnly = true;
              }
              else{
              _showFavoriteOnly = false;
              }
              },
              );
            },
            itemBuilder: (_) => [
            PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites,),
            PopupMenuItem(child: Text('Show All'),value: FilterOptions.All,)
          ],
          icon: Icon(Icons.more_vert,),
          ),
         Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch as Widget,
            value: cart.itemCount.toString(), color: Theme.of(context).accentColor,
          ),
        child: IconButton(
              icon: Icon(
              Icons.shopping_cart,
            ), onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },)
          ),
        ],
      ),
      drawer: 
      AppDrawer(),
      body: 
      _isLoading ? const Center(
        child: CircularProgressIndicator(
        ),
      ) : ProductsGrid(_showFavoriteOnly),
    );
    return scaffold;
  }
}
