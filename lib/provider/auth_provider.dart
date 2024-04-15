import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platiz_store/service/auth_service.dart';

final signUpProvider = AsyncNotifierProvider(() => SignUpProvider());

class SignUpProvider extends AsyncNotifier{

  @override
  FutureOr build() {

  }

  Future signUp({required Map<String, dynamic> json})async{
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final email = json['email'];
      final password = json['password'];
      return AuthService.signUp(email: email, password: password);
    });
  }

  Future signIn({required Map<String, dynamic> json})async{
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final email = json['email'];
      final password = json['password'];
      return AuthService.signIn(email: email, password: password);
    });
  }

  Future logOut() async{
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService.logout());
  }


}