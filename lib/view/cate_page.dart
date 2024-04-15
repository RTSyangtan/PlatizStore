import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:platiz_store/provider/category_provider.dart';
import 'package:platiz_store/provider/product_provider.dart';
import 'package:platiz_store/view/cate_product_page.dart';
import 'package:platiz_store/view/home_page.dart';
import 'package:platiz_store/view/widgets/app_bar.dart';
import 'package:platiz_store/view/widgets/botton_nav_bar.dart';
import 'package:platiz_store/view/widgets/drawer.dart';

import '../provider/button_nav_provider.dart';

class CatePage extends ConsumerWidget {
  const CatePage({Key? key});

  @override
  Widget build(BuildContext context,ref) {
    final state = ref.watch(categoriesProvider);
    return Scaffold(
      backgroundColor: Color(0xffDDE1E4),
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Container(
                color: Colors.white,
                height: 320,
                child: Image.asset('assets/images/offer.jpg'),
              ),
            ),
            Text('CATEGORY',style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold
            ),),
            Container(
              height: 250,
              width: double.infinity,
              child: state.when(
                  data: (data) {
                    return ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final cate = data[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        height: 220,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: InkWell(
                                                onTap: (){
                                                  Get.to(()=>CateProductPage());
                                                  ref.read(cateProvider.notifier).getClickedProduct(int.parse(cate.id));
                                                },
                                                child: Image.network(cate.image)))),
                                    Positioned(
                                        left: 60,
                                        top:180,
                                        child: Container(
                                            width:110,
                                            height:30,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white
                                            ),
                                            child: Center(child: Text(cate.name,style: TextStyle(
                                                fontSize: 18
                                            ),)))),
                                  ],
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                          );
                        });
                  },
                  error: (err, st) {
                    return Text('$err');
                  },
                  loading: () => CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
