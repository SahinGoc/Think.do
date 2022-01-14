
import 'package:bitirme_projesi/models/user.dart';
import 'package:bitirme_projesi/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService{

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login(String email, String password) async{
    try{
      UserCredential authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = authResult.user;
      return user;
    }catch(e){
      return null;
    }
  }
  Future signUp({required String email, required String password}) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signOut(BuildContext context) async {
    await auth.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context) => LoginPage())
    );
  }
}