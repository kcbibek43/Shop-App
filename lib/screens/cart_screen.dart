import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as en;
import '../providers/cart.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
           Text('Total', style: TextStyle(
            fontSize: 20,
           ),),
           
           Chip(
            label: Text(cart.totalAmount.toStringAsFixed(2),
           style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6!.color,),),
           backgroundColor: Theme.of(context).primaryColor,
           ),
        OrderButton(cart: cart)
          ]),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx,i) => en.CartItem(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity, 
              price: cart.items.values.toList()[i].price,
              ),
            itemCount: cart.items.length,))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: (widget.cart.totalAmount<=0 ) ? null : (){
       Provider.of<Orders>(context,listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount);
    widget.cart.clear();
    },
      // ignore: sort_child_properties_last
      child: const Text('Order Now',
      style: TextStyle(
    fontSize: 20,
      ),
      ),
 style: ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
    final Color color = states.contains(MaterialState.pressed)
      ? Colors.blue
      : Colors.red;
    return BorderSide(color: color, width: 2);
      }
    ),
  ),
       );
  }
}