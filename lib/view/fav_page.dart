import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:platiz_store/model/category_model.dart';
import 'package:platiz_store/model/product.dart';
import 'package:platiz_store/view/detail_page.dart';
import 'package:platiz_store/view/widgets/app_bar.dart';
import 'package:platiz_store/view/widgets/drawer.dart';

import '../provider/button_nav_provider.dart';

class FavouritePage extends ConsumerWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final AsyncValue<QuerySnapshot> favoritesAsyncValue = ref.watch(favoriteProductsProvider);
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: favoritesAsyncValue.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (QuerySnapshot snapshot) {
          if (snapshot.docs.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          }
          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot favorite = snapshot.docs[index];
              return InkWell(
                onTap: () {
                  // Navigate to DetailPage with the corresponding product
                  Get.to(() => DetailPage(product: Product(
                    id: favorite['id'],
                    title: favorite['title'],
                    price: favorite['price'],
                    description: favorite['description'],
                    category: Categories(
                      id: favorite['category']['id'],
                      name: favorite['category']['name'],
                      image: favorite['category']['image'],
                    ),
                    images: List<String>.from(favorite['images']),
                  )));
                },
                child: ListTile(
                  title: Text(favorite['title']),
                  subtitle: Text(favorite['description']),
                 leading: Container(
                     height: 100,
                     width: 100,
                     child: Image.network(favorite['images'][0])),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
