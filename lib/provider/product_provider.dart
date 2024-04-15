import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/service/product_service.dart';

final cateProvider = AsyncNotifierProvider(()=>ProductProvider());
final pProvider = FutureProvider((ref) => ProductService.getProduct());

class ProductProvider extends AsyncNotifier{
  int? lastAddedProductId;

  @override
  FutureOr build() async{

  }

  Future<void> getClickedProduct(int no) async{
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ProductService.getClickedProduct(no: no));
  }

  Future<void> getAllProduct() async{

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ProductService.getProduct());
  }

  Future<void> addNewProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ProductService.addProduct(
      title: title,
      price: price,
      description: description,
      categoryId: categoryId,
      images: images,
    ));

  }
}
