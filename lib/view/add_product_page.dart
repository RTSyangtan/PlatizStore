import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:platiz_store/constant/categories_list.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';
import 'package:platiz_store/provider/product_provider.dart';
import 'package:http/http.dart' as http;

class AddProductPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  AddProductPage({super.key});


  Future<bool> isImageUrlValid(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        return contentType?.startsWith('image') ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context,ref) {
    final imageStatus = ref.watch(imageStatusProvider);
    final image = ref.watch(productImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'title',
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(height: 10,),
                FormBuilderTextField(
                  name: 'price',
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(height: 10),
                FormBuilderDropdown(
                  name: 'categoryId',
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: listOfCategories
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'imageUrl',
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.url(),
                  ]),
                ),
                //  InkWell(
                //   onTap: (){
                //     ref.read(productImageProvider.notifier).pickImage();
                //   },
                //   child: Container(
                //     child: image == null ? Center(child:Text('Pick an image'))
                //         :Image.file(File(image.path)),
                //     height: 140,
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.lightBlueAccent),
                //     ),
                //   ),
                // ),
                ElevatedButton(onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState?.saveAndValidate() ?? true) {
                    final map = _formKey.currentState?.value!;

                    if (await isImageUrlValid(map!['imageUrl'])) {
                      try {
                        ref.read(cateProvider.notifier).addNewProduct(
                          title: map!['title'],
                          price: double.parse(map['price']),
                          description: map['description'],
                          categoryId: listOfCategories.indexOf(map['categoryId'])+1,
                          images: [map['imageUrl']],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Product added successfully')),
                        );
                        Get.back();
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add product: $error')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid image URL')),
                      );
                    }
                  }
                }, child: Text('Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
