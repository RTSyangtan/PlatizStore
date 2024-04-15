import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final contentProvider = StateProvider((ref) => 0);
final aProvider = StateProvider((ref) => 0);
final imageProvider = StateProvider((ref) => 0);
final quantityProvider = StateProvider((ref) => 1);
final favoriteProductsProvider = StreamProvider<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('favorites').snapshots();
});

final productImageProvider = NotifierProvider(()=>ImageProvider());
final imageStatusProvider = NotifierProvider(()=>StatusProvider());

class StatusProvider extends Notifier{
  @override
  build() {
    return true;
  }

  void change(){
    state = !state;
  }

}

class ImageProvider extends Notifier{
  @override
  build() {
    return null;
  }

  void pickImage() async{
    ImagePicker _picker = ImagePicker();
    state = await _picker.pickImage(source: ImageSource.gallery);
  }

}