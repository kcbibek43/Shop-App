import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
class CartItem extends StatelessWidget {
final String id;
final double price;
final String productId;
final int quantity;
final String title;
 CartItem({
  required this.id,
  required this.price,
  required this.productId,
  required this.quantity,
  required this.title,
 });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        // ignore: sort_child_properties_last
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin:  const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        )
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: ((direction){
       return showDialog(context: context, builder: (ctx) {
       return  AlertDialog(
          title: const Text('Are you sure ?'),
          content: const Text('Do you want to remove the itwms from the cart ?'),
          actions: [
        TextButton(onPressed: ()=>
        Navigator.of(ctx).pop(false)
        , child: const Text('No'),),
        TextButton(onPressed: ()=> Navigator.of(ctx).pop(true)
      , child: const Text('Yes'),)
          ], 
        );
        }
        );
      }
      ),
      onDismissed: (direction){
        Provider.of<Cart> (context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(child: Text('\$$price'))),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price*quantity)}'),
          trailing: Text('$quantity x'),
        ),
        ),
      ),
    );
  }
}