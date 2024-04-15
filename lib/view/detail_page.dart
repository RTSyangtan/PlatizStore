import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';
import 'package:platiz_store/view/widgets/buy_page.dart';
import '../model/product.dart';

class DetailPage extends ConsumerWidget {
  final Product product;
  const DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final imgNo = ref.watch(imageProvider);
    final quantity = ref.watch(quantityProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _toggleFavorite(product, ref, context);
            },
            icon: ref.watch(favoriteProductsProvider).when(
                  data: (QuerySnapshot<Object?>? snapshot) {
                    final isFavorite =
                        snapshot?.docs.any((doc) => doc['id'] == product.id) ??
                            false;
                    return Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    );
                  },
                  loading: () => Icon(Icons.favorite_border_outlined),
                  error: (_, __) => Icon(Icons.favorite_border_outlined),
                ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Stack(
              children: [
                Image.network(product.images[imgNo]),
                Positioned(
                  top: 150,
                  left: 110,
                  right: 0,
                  height: 380,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.images.length,
                      itemBuilder: (context,index){
                        return IconButton(
                                  onPressed: () {
                                    ref.read(imageProvider.notifier).state = index;
                                  },
                                  icon: Icon(
                                    imgNo == index ? Icons.circle : Icons.circle_outlined,
                                    color: Colors.white,
                                  ),
                                );
                      }
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(product.title, style: TextStyle(fontSize: 20)),
              subtitle: Text(product.description),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xffDDE1E4),
                      borderRadius: BorderRadius.circular(40)),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 70,
                          width: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext){
                                          return BuyPage(product: product,);
                                        }
                                    );
                                  },
                                  child: Text('\$ ${product.price}',
                                      style: TextStyle(fontSize: 25))))),
                      Container(
                          height: 70,
                          width: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: TextButton(
                                  onPressed: () {

                                  },
                                  child: Text('Add to Cart',
                                      style: TextStyle(fontSize: 25))))),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(Product product, WidgetRef ref, BuildContext context) {
    final isFavorite = ref.watch(favoriteProductsProvider).maybeWhen(
        data: (snapshot) {
          return snapshot?.docs.any((doc) => doc['id'] == product.id) ?? false;
        },
        orElse: () => false);

    if (isFavorite) {
      _removeProductFromFavorites(product, ref, context);
    } else {
      _addProductToFavorites(product, ref, context);
    }
  }

  void _addProductToFavorites(
      Product product, WidgetRef ref, BuildContext context) {
    FirebaseFirestore.instance.collection('favorites').add({
      'id': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': {
        'id': product.category.id,
        'name': product.category.name,
        'image': product.category.image
      },
      'images': product.images,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product Added To Favorites'),
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      print('Error adding product to favorites: $error');
    });
  }

  void _removeProductFromFavorites(
      Product product, WidgetRef ref, BuildContext context) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: product.id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.first.reference.delete().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product Removed from Favorites'),
          duration: Duration(seconds: 1),
        ));
      }).catchError((error) {
        print('Error removing product from favorites: $error');
      });
    }
  }
}
