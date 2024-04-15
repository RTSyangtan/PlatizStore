import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  static final _auth = FirebaseAuth.instance;

  static Future signUp({required String email,required String password})async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(err){
      throw '$err';
    }
  }

  static Future signIn ({required String email,required String password})async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (err) {
      throw '$err';
    }
  }

  static Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (err) {
      throw '$err';
    }
  }
}