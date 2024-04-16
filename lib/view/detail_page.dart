import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';
import '../model/product.dart';

class DetailPage extends ConsumerStatefulWidget {
  final Product product;

  DetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final imgNo = ref.watch(imageProvider);
    final quantity = ref.watch(quantityProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _toggleFavorite(widget.product, ref, context);
            },
            icon: ref.watch(favoriteProductsProvider).when(
              data: (QuerySnapshot<Object?>? snapshot) {
                final isFavorite =
                    snapshot?.docs.any((doc) => doc['id'] == widget.product.id) ??
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
                Image.network(widget.product.images[imgNo]),
                Positioned(
                  top: 150,
                  left: 110,
                  right: 0,
                  height: 380,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.images.length,
                    itemBuilder: (context, index) {
                      return IconButton(
                        onPressed: () {
                          ref.read(imageProvider.notifier).state = index;
                        },
                        icon: Icon(
                          imgNo == index
                              ? Icons.circle
                              : Icons.circle_outlined,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                widget.product.title,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(widget.product.description),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffDDE1E4),
                  borderRadius: BorderRadius.circular(40),
                ),
                height: 180,
                child: Column(
                  children: [
                  SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 155),
                        child: Text(
                          'Quantity',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if(quantity>1){
                                ref.read(quantityProvider.notifier).state--;
                              }
                              else{
                                ref.read(quantityProvider.notifier).state;
                              }
                            },
                            icon: Icon(Icons.minimize),
                          ),
                          Container(
                            color: Colors.white,
                            height: 40,
                            width: 120,
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ref.read(quantityProvider.notifier).state++;
                            },
                            icon: Icon(Icons.add),
                          ),
                          Center(
                            child: Text(
                              '\$ ${widget.product.price*quantity}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Buy',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(
      Product product, WidgetRef ref, BuildContext context) {
    final isFavorite = ref.watch(favoriteProductsProvider).maybeWhen(
      data: (snapshot) {
        return snapshot?.docs.any((doc) => doc['id'] == product.id) ??
            false;
      },
      orElse: () => false,
    );

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
