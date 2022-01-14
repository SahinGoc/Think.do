

import 'package:bitirme_projesi/screens/login_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todolist',
        theme: ThemeData.dark(),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot){
            if(snapshot.hasError){
              print("This is error: ${snapshot.error.toString()}");
              return Text("Bazı sıkıntılar oluştu!");
            }
            else if(snapshot.hasData){
              return LoginPage();
            }
            else{
              return Center(
                child: CircularProgressIndicator(),);
            }
          },)
      );
  }
}
