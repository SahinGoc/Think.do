import 'package:bitirme_projesi/screens/home_page.dart';
import 'package:bitirme_projesi/screens/login_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:bitirme_projesi/services/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final AuthService authService = AuthService();
  final ThemeService themeService = ThemeService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          Locale('tr', ''),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Think.do',
        themeMode: ThemeMode.system,
        theme: isTheme(false),
        darkTheme: isTheme(true),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("This is error: ${snapshot.error.toString()}");
              return Text("Bazı sıkıntılar oluştu!");
            } else if (snapshot.hasData) {
              if (authService.getUser() == null) {
                return LoginPage();
              } else {
                return HomePage('Anasayfa');
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  ThemeData isTheme(bool theme) {
    if (theme == false) {
      return ThemeData(
        bottomAppBarColor: Colors.cyanAccent,
        primaryColor: Colors.lightGreen,
        appBarTheme: AppBarTheme(color: Colors.red),
        drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
        iconTheme: IconThemeData(color: Colors.red),
        dividerTheme: DividerThemeData(color: Colors.red),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            modalBackgroundColor: Colors.white),
        hintColor: Colors.lightGreen,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.lightGreen),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.cyanAccent),
      );
    } else {
      return ThemeData(
        bottomAppBarColor: Colors.yellowAccent,
        brightness: Brightness.dark,
        primaryColor: Colors.yellowAccent,
        appBarTheme: AppBarTheme(color: Color.fromRGBO(35, 35, 35, 1.0)),
        drawerTheme:
            DrawerThemeData(backgroundColor: Color.fromRGBO(50, 50, 50, 1.0)),
        iconTheme: IconThemeData(color: Colors.yellowAccent),
        dividerTheme: DividerThemeData(color: Colors.yellowAccent),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            modalBackgroundColor: Color.fromRGBO(50, 50, 50, 1.0)),
        hintColor: Colors.yellowAccent,
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.redAccent),
      );
    }
  }
}
