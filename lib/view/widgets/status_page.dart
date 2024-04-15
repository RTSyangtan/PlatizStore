import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platiz_store/view/home_page.dart';
import 'package:platiz_store/view/login_page.dart';
import 'package:platiz_store/view/widgets/botton_nav_bar.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if(snapshot.hasData){
              return ButtonNavBar();
            }else{
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
