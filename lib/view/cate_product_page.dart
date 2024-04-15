import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:platiz_store/provider/product_provider.dart';
import 'package:platiz_store/view/detail_page.dart';
import 'package:platiz_store/view/widgets/app_bar.dart';

class CateProductPage extends ConsumerWidget {
  const CateProductPage({super.key});

  @override
  Widget build(BuildContext context,ref) {
    final state = ref.watch(cateProvider);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            state.when(
                data: (data) {
                  return Container(
                    height: 800,
                    child: GridView.builder(
                        itemCount: data?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 270,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2),
                        itemBuilder: (context,index){
                          final product = data[index];
                          return Card(
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Container(
                                    height:200,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                            onTap: (){
                                              Get.to(()=>DetailPage(product: product));
                                            },
                                            child: Image.network(product.images[0])))),
                                SizedBox(
                                  height: 20,
                                  child: ListTile(
                                    title: Text(product.title,style: TextStyle(fontSize: 15),),
                                    subtitle:  Text(product.price.toString()),
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
        ]),
      ),
    );
  }
}
