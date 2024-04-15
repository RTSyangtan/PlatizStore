import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:platiz_store/provider/product_provider.dart';
import 'package:platiz_store/view/add_product_page.dart';
import 'package:platiz_store/view/widgets/app_bar.dart';
import 'package:platiz_store/view/widgets/drawer.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context,ref) {

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
         Container(

         ),
          IconButton(onPressed: (){
            Get.to(()=>AddProductPage());
          }, icon: Icon(Icons.add))
        ],
      )
    );
  }
}
