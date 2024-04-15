import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';

import '../../model/product.dart';

class BuyPage extends ConsumerWidget implements PreferredSizeWidget {
  final Product product;
  const BuyPage({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context,ref) {
    final quantity = ref.watch(quantityProvider);
    return SizedBox(
      width: double.infinity,
      height: 350, // Set desired height here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Quantity',style: TextStyle(fontSize: 20),),
          Row(children: [
            IconButton(onPressed: (){
              if(quantity>1){
              ref.read(quantityProvider.notifier).state--;
              }
              else{
                ref.read(quantityProvider.notifier).state;
              }
            }, icon: Icon(Icons.minimize),),
            Container(
                color: Colors.white,
                height: 60,
                width: 210,
                child: Center(child: Text(quantity.toString(),style: TextStyle(fontSize: 20)))),
            IconButton(onPressed: (){
              ref.read(quantityProvider.notifier).state++;
            }, icon:(Icon(Icons.add)))
          ],),
          SizedBox(height: 20),
          Text('Total Price:${quantity*product.price}',style: TextStyle(fontSize: 20)),
          SizedBox(height: 20), // Space between text and icon
          TextButton(onPressed: (){

          },
            child: Text('Buy'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),),), // Set desired icon size here
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
