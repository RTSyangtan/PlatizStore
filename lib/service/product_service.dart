import 'package:dio/dio.dart';
import 'package:platiz_store/model/product.dart';

import '../constant/api.dart';

class ProductService{

  static final dio = Dio();

  static Future<List<Product>> getProduct() async {
    try{
      final response = await dio.get(Api.allProducts);
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch(err){
      throw '$err';
    }
  }

  static Future<List<Product>> getClickedProduct({required int no}) async {
    try{
      final response = await dio.get('${Api.cateProducts}$no');
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } on DioException catch(err){
      throw '$err';
    }
  }

  static Future<Product> addProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,

  }) async {
    try {
      final response = await dio.post(
        Api.addProduct,
        options: Options(
          headers: {
            'Server': 'Cowboy',
            'Content-Type': 'application/json; charset=utf-8',
          },
          validateStatus: (status) {
            return status! < 500; // Validate status codes less than 500
          },
        ),
        data: {
          "title": title,
          "price": price,
          "description": description,
          "categoryId": categoryId,
          "images": images,
        },
      );

      if (response.statusCode == 201) {
        return Product.fromJson(response.data);
      } else {
        throw 'Failed to add product: ${response.statusCode}';
      }
    } catch (error) {
      if (error is DioError) {
        print('DioError Details:');
        print('Status: ${error.response?.statusCode}');
        print('Data: ${error.response?.data}');
      }
      print(error);
      throw 'Failed to add product: $error';
    }

  }
}