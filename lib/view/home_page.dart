import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:platiz_store/constant/icons_list.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';
import 'package:platiz_store/view/detail_page.dart';
import 'package:platiz_store/view/widgets/app_bar.dart';
import 'package:platiz_store/view/widgets/drawer.dart';
import '../provider/product_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  final int stat = 0;

  @override
  Widget build(BuildContext context, ref) {

    final temp = ref.watch(aProvider);
    final state = stat ==temp? ref.watch(pProvider) : ref.watch(cateProvider);
    return Scaffold(
      backgroundColor: Color(0xffDDE1E4),
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 15),
            height: 70,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(width: 15);
              },
              scrollDirection: Axis.horizontal,
              itemCount: homeIconsList.length,
              itemBuilder: (context, index) {
                final ic = homeIconsList[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      height: 50,
                      width: 50,
                      child: InkWell(
                        child: ClipRRect(
                            child: ic['image'],
                            borderRadius: BorderRadius.circular(30)),
                        onTap: (){
                          ref.watch(cateProvider.notifier).getClickedProduct(ic['id']);
                          ref.watch(aProvider.notifier).state=1;
                      },),
                    ),
                    Text(ic['category']),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 10),
          state.when(
              data: (data) {
                return Container(
                  height: 700,
                  child: GridView.builder(
                    itemCount: data?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 250,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2),
                      itemBuilder: (context,index){
                        final product = data[index];
                        return Card(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                               Container(
                                  height:150,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                          onTap: (){
                                            Get.to(()=>DetailPage(product: product));
                                            ref.read(imageProvider.notifier).state=0;
                                          },
                                          child: Image.network(product.images[0]),
                                      ))),
                               SizedBox(
                                 height: 20,
                                 child: ListTile(
                                   title: Text(product.title,style: TextStyle(fontSize: 15),),
                                   subtitle:  Text('\$ '+product.price.toString()),
                                 ),
                               )
                            ],
                          ),
                        );
                      }
                  ),
                );
              },
              error: (err, st) {
                return Text('$err');
              },
              loading: () => CircularProgressIndicator())
        ],
      ),
    );
  }
}
