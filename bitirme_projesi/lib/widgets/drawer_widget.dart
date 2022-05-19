import 'package:bitirme_projesi/screens/archive_page.dart';
import 'package:bitirme_projesi/screens/complete_page.dart';
import 'package:bitirme_projesi/screens/home_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:bitirme_projesi/services/notifications.dart';
import 'package:bitirme_projesi/services/stream.dart';
import 'package:bitirme_projesi/services/todo.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  TodoService todoService = TodoService();
  StreamService streamService = StreamService();
  AuthService authService = AuthService();

  late bool isClick, isVisible, isThemeClick;

  @override
  void initState() {
    isClick = false;
    isVisible = false;
    //isTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildDrawer();
  }

  buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/image/ic_launcher.png'),
                  Text('Think.do', style: TextStyle(color: Colors.white, fontSize: 16),),
                ],
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).iconTheme.color)),
          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).iconTheme.color),
            title: Text("Anasayfa"),
            onTap: () {
              setState(() {
                streamService.setCurrentCategory("Anasayfa");
                Navigator.pushReplacement(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => HomePage("Anasayfa")));
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Theme.of(context).iconTheme.color),
            title: Text("Kategoriler"),
            trailing: isClick
                ? Icon(Icons.keyboard_arrow_down)
                : Icon(Icons.keyboard_arrow_left),
            onTap: () {
              setState(() {
                isClick = !isClick;
                isVisible = !isVisible;
              });
            },
          ),
          builtDrawerCategory(),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.archive,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Arşiv"),
            onTap: () {
              Navigator.push((context),
                  MaterialPageRoute(builder: (context) => ArchivePage()));
            },
          ),
          ListTile(
            leading:
                Icon(Icons.check, color: Theme.of(context).iconTheme.color),
            title: Text("Tamamlananlar"),
            onTap: () {
              Navigator.push((context),
                  MaterialPageRoute(builder: (context) => CompletePage()));
            },
          ),
          Divider(),
         /*ListTile(
            leading: Icon(Icons.wb_sunny_outlined,
                color: Theme.of(context).iconTheme.color),
            title: Text("Tema"),
            onTap: () {
              isThemeClick = !isThemeClick;
              if(isThemeClick){
                setState(() {
                  streamService.setTheme('dark');
                  print(streamService.currentTheme);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage("Anasayfa")));
                });
              }else{
                setState(() {
                  streamService.setTheme('light');
                  print(streamService.currentTheme);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage("Anasayfa")));
                });

              }
            },
          ),*/
          ListTile(
            leading: Icon(Icons.power_settings_new,
                color: Theme.of(context).iconTheme.color),
            title: Text("Çıkış Yap"),
            onTap: () {
              authService.signOut(context);
            },
          )
        ],
      ),
    );
  }

  builtDrawerCategory() {
    return Visibility(
      visible: isVisible,
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: streamService.getDrawerStream(),
      ),
    );
  }
  /*void isTheme(){
    if(streamService.currentTheme == 'dark'){
      isThemeClick = true;
    }else{
      isThemeClick = false;
    }
  }*/
}
