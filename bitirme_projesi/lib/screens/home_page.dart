import 'package:bitirme_projesi/main.dart';
import 'package:bitirme_projesi/services/theme.dart';
import 'package:bitirme_projesi/services/todo.dart';
import 'package:bitirme_projesi/widgets/add_sheet_widget.dart';
import 'package:bitirme_projesi/widgets/drawer_widget.dart';
import 'package:bitirme_projesi/widgets/home_page_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  late String category;

  HomePage(this.category);
  @override
  _HomePageState createState() => _HomePageState(category);
}

class _HomePageState extends State<HomePage> {
  late String category;

  _HomePageState(this.category);

  GlobalKey _key = GlobalKey<ScaffoldState>();

  ThemeService service = ThemeService();

  //late bool isThemeDark;
  @override
  void initState() {
    //isThemeDark = service.isDark!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(category),
        //actions: [themeButton()],
      ),
      drawer: DrawerWidget(),
      body: HomePageWidget(category),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor:
                  Theme.of(context).bottomSheetTheme.backgroundColor,
              context: context,
              builder: (context) => SheetWidget());
        },
      ),
    );
  }

  /*Widget themeButton() {
    return Row(
      children: [
        GestureDetector(
          child: isThemeDark ? Icon(Icons.nightlight_outlined) : Icon(Icons.wb_sunny_outlined),
          onTap: () {
            setState(() {
              isThemeDark = !isThemeDark;
              service.setDarkTheme(isThemeDark);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
            });
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }*/
}
