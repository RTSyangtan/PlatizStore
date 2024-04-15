import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/provider/button_nav_provider.dart';
import 'package:platiz_store/view/cate_page.dart';
import 'package:platiz_store/view/fav_page.dart';
import 'package:platiz_store/view/home_page.dart';
import 'package:platiz_store/view/my_page.dart';


class ButtonNavBar extends ConsumerWidget{

  @override
  Widget build(BuildContext context,ref) {

    final state =  ref.watch(contentProvider);
    Widget _buildIcon(IconData icon,index){
      return IconButton(
          onPressed: () {
              ref.read(contentProvider.notifier).state=index;
          },
          icon: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  color: state == index ? Colors.black: Colors.white,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(icon, size: 30,color: state == index ? Colors.white: Colors.black,)));
    }
    Widget _loadPage(int _selectedPage){
       if(_selectedPage == 0){
        return HomePage();
      }else if (_selectedPage == 1){
         return CatePage();
       }else if (_selectedPage == 2){
         return FavouritePage();
       }else{
         return MyPage();
       }
    }
    // body: _loadPage(state),
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: _loadPage(state),
          ),
          Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIcon(Icons.home, 0),
                _buildIcon(CupertinoIcons.cube_box, 1),
                _buildIcon(Icons.favorite_border, 2),
                _buildIcon(Icons.person, 3),
              ],
            ),
          ),
        ),
      ]
      ),
    );
  }


}

