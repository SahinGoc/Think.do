import 'package:bitirme_projesi/models/userData.dart';
import 'package:bitirme_projesi/screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? getUser() {
    User? user = auth.currentUser;
    return user;
  }

  Future login(String email, String password) async {
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      return user;
    } catch (e) {
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
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  void newUserCol(UserData userData) {
    CollectionReference colRef = FirebaseFirestore.instance.collection('User');

    colRef.doc(userData.uid).set(userData.toMap());
    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Hoşgeldin')
        .set({'categoryName': 'Hoşgeldin'});

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Hoşgeldin')
        .collection('Todo')
        .doc(DateTime.now().toString())
        .set({
      "title": 'Hoşgeldin',
      "description": '',
      'category': 'Hoşgeldin',
      "date": '',
      "time": '',
      "rememberTime": '',
      "createTime": DateTime.now().toString(),
      "complete": '',
      "archive": ''
    });

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Anasayfa')
        .set({'categoryName': 'Anasayfa'});

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Anasayfa')
        .collection('Todo')
        .doc(DateTime.now().toString())
        .set({
      "title": 'Yeni görev ekle',
      "description": '',
      'category': 'Anasayfa',
      "date": '',
      "time": '',
      "rememberTime": '',
      "createTime": DateTime.now().toString(),
      "complete": '',
      "archive": ''
    });

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Arşiv')
        .set({'categoryName': 'Arşiv'});

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Arşiv')
        .collection('Todo')
        .doc(DateTime.now().toString())
        .set({
      "title": 'Arşivlenenler',
      "description": '',
      'category': 'Arşiv',
      "date": '',
      "time": '',
      "rememberTime": '',
      "createTime": DateTime.now().toString(),
      "complete": '',
      "archive": ''
    });

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Tamamlananlar')
        .set({'categoryName': 'Tamamlananlar'});

    colRef
        .doc(userData.uid)
        .collection('category')
        .doc('Tamamlananlar')
        .collection('Todo')
        .doc(DateTime.now().toString())
        .set({
      "title": 'Tamamlananlar',
      "description": '',
      'category': 'Tamamlananlar',
      "date": '',
      "time": '',
      "rememberTime": '',
      "createTime": DateTime.now().toString(),
      "complete": '',
      "archive": ''
    });
  }
}
