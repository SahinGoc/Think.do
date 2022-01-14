
import 'package:bitirme_projesi/services/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Yapıldı"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
              authService.signOut(context);
            }, child: Text("Çıkış yap"))
        ),
      );
  }
}
