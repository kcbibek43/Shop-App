import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(
        create:(contex)=> Auth(),),
     ChangeNotifierProvider(
      create:(ctx)=> Products(),
     ),
    ChangeNotifierProvider(
      create: (ctx) => Cart(),
     ),
   ChangeNotifierProvider.value(
      value: Orders(),
      )
      ],
      child:Consumer<Auth>(builder: (ctx,auth,_) => 
      MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.orange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth ? ProductOverviewScreen() : const AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) =>ProductDetailScreen(),
                    CartScreen.routeName: (ctx) => CartScreen(),
                    OrdersScreen.routeName: (ctx) => OrdersScreen(),
                    UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                    EditProductScreen.routeName: (ctx)=> EditProductScreen(),

        },
      ),
       ) 
    );
  }
}