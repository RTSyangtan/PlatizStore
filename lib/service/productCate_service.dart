import 'package:dio/dio.dart';

import '../constant/api.dart';
import '../model/category_model.dart';

class ProductService{

  static final dio = Dio();

  static Future<List<Categories>> getAllCate() async {
    try{
        final response = await dio.get(Api.allCategory);
        return (response.data as List).map((e) => Categories.fromJson(e)).toList();
    } on DioException catch(err){
      throw '$err';
    }
  }
}