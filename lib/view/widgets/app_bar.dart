import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
          onTap: (){Scaffold.of(context).openDrawer();},
          child: Icon(Icons.person)),
      title: Text('Store App'),
      actions: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: Icon(Icons.shopping_cart),
            ),
            Positioned(
              right: 16,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.yellow,
                ),
                child: Text('3'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
