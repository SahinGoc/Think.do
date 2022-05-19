import 'package:bitirme_projesi/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemeService{
  AuthService authService = AuthService();
  bool? isDark;

  void setFirstTheme() {
    isDark = false;
  }
  void setDarkTheme(bool theme){
    isDark = theme;
    print(isDark);
  }

  DocumentReference getColRef() {
    DocumentReference colRef = FirebaseFirestore.instance
        .collection('User')
        .doc(authService.getUser()!.uid);
    return colRef;
  }

/*String currentTheme = "light";

  void getCurrentTheme() {
    Future<DocumentSnapshot> user = FirebaseFirestore.instance
        .collection('User')
        .doc(authService.getUser().uid)
        .get();
    user.then((value) {
      currentTheme = value['theme'].toString();
      print(currentTheme);
    });
  }

  void setTheme(String theme) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(authService.getUser().uid)
        .update({
      'email': authService.getUser().email,
      'uid': authService.getUser().uid,
      'theme': theme
    });
  }*/
}