import 'dart:async';

import 'package:bitirme_projesi/models/userData.dart';
import 'package:bitirme_projesi/screens/verify_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm> {
  final auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  late UserData userData = UserData.withOutInfo();

  late User? user;

  final _formKey = GlobalKey<FormState>();

  static const maxSecond = 5;
  int seconds = maxSecond;
  Timer? timer;

  var text;

  var textEmail = TextEditingController();
  var textPassword = TextEditingController();
  var textRePassword = TextEditingController();

  late bool click;

  @override
  void initState() {
    click = false;
    text = "Doğrula";

    user = auth.currentUser;
    super.initState();
  }

  void dispose() {
    textEmail.dispose();
    textPassword.dispose();
    textRePassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF212730),
                Color(0xFF29313D),
                Color(0xFF323B49),
              ],
              stops: [0.4, 0.8, 0.9],
            )),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hesap Oluştur",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  EmailTextFeild(context),
                  SizedBox(
                    height: 30.0,
                  ),
                  PasswordTextFeild(context),
                  SizedBox(
                    height: 30.0,
                  ),
                  RePasswordTextFeild(),
                  SignUpBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  EmailTextFeild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "E-posta",
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
            color: Color(0xFFEEEEEE),
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF393E46),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 50.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: textEmail,
            onSaved: (value) {
              userData.email = value!;
            },
            style: TextStyle(
              color: Color(0xFFEEEEEE),
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 5.0, left: 10.0),
                hintText: "e-posta adresi giriniz",
                hintStyle: TextStyle(color: Colors.white)
            ),
          ),
        ),
      ],
    );
  }

  PasswordTextFeild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Şifre",
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
            color: Color(0xFFEEEEEE),
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF393E46),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 50.0,
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: validation,
              onSaved: (value) {
                userData.password = value!;
              },
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: textPassword,
              style: TextStyle(
                color: Color(0xFFEEEEEE),
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 1.0, left: 10.0),
                  hintText: "Şifre giriniz",
                  hintStyle: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ),
      ],
    );
  }

  RePasswordTextFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Şifre Doğrulama",
          style: GoogleFonts.openSans(
              textStyle: TextStyle(
            color: Color(0xFFEEEEEE),
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Color(0xFF393E46),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          height: 50.0,
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            controller: textRePassword,
            style: TextStyle(
              color: Color(0xFFEEEEEE),
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 1.0, left: 10.0),
                hintText: "Tekrar giriniz",
                hintStyle: TextStyle(color: Colors.white)
            ),
          ),
        ),
      ],
    );
  }

  SignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: ElevatedButton(
        onPressed: () {
          if (click == false) {
            if (_formKey.currentState!.validate()) {
              if (textPassword.text == textRePassword.text) {
                _formKey.currentState!.save();
                authService
                    .signUp(
                        email: textEmail.text,
                        password: userData.password.trim())
                    .then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      "Kayıt başarısız",
                      style: TextStyle(fontSize: 16),
                    )));
                  } else {
                    verify();
                    userData.uid = value.uid;
                    userData.email = value.email;
                    authService.newUserCol(userData);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => VerifyPage()));
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "Girilen şifreler eşleşmiyor",
                  style: TextStyle(fontSize: 16),
                )));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Şifre uygun değil.')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              "aaaa",
              style: TextStyle(fontSize: 16),
            )));
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          primary: Color(0xFFEEEEEE),
        ),
        child: Text("OLUŞTUR",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Color(0xFF212730),
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  void verify() {
    user = auth.currentUser!;
    user!.sendEmailVerification();
    checkMailVerified();
  }

  Future checkMailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      print("Doğrulandı");
    } else {
      print("doğrulanmadı");
    }
  }

  // şifre kontrolü
  String? validation(String? value) {
    print("validate");
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,}$');
    if (value!.isEmpty) {
      return 'Lütfen şifre girin';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Hatalı şifre';
      } else {
        return null;
      }
    }
  }
}
