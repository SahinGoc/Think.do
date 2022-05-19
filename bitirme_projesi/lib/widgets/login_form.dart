import 'package:bitirme_projesi/screens/home_page.dart';
import 'package:bitirme_projesi/screens/sign_up_page.dart';
import 'package:bitirme_projesi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _key = GlobalKey<FormState>();

  late User user;

  var textEmail = TextEditingController();
  var textPassword = TextEditingController();

  bool rememberMe = false;
  
  final AuthService authService = AuthService();

  void dispose(){
    textEmail.dispose();
    textPassword.dispose();

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
                    "Giriş Yap",
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
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        EmailTextFeild(context),
                        SizedBox(
                          height: 30.0,
                        ),
                        PasswordTextFeild(context),
                      ],
                    ),
                  ),
                  ForgotPasswordBtn(),
                  RememberMeCheckbox(),
                  LoginBtn(),
                  SignInWithText(),
                  SizedBox(
                    height: 20.0,
                  ),
                  SocialBtn(),
                  SizedBox(
                    height: 30.0,
                  ),
                  SignupBtn(),
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
          "Email",
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
            style: TextStyle(
              color: Color(0xFFEEEEEE),
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(Icons.email, color: Color(0xFFEEEEEE)),
                hintText: "Email adresiniz",
            hintStyle: TextStyle(color: Color(0xFFEEEEEE))),
          ),
        ),
      ],
    );
  }

  PasswordTextFeild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Şifre",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            )),
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
            controller: textPassword,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
              color: Color(0xFFEEEEEE),
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(Icons.lock, color: Color(0xFFEEEEEE)),
                hintText: "Şifre",
            hintStyle: TextStyle(color: Color(0xFFEEEEEE))),
          ),
        ),
      ],
    );
  }

  ForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: Text("Şifremi unuttum!",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(fontSize: 10.0, color: Color(0xFFEEEEEE)),
            )),
      ),
    );
  }

  RememberMeCheckbox() {
    return Container(
      height: 20.0,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Color(0xFFEEEEEE)),
            child: Checkbox(
              value: rememberMe,
              activeColor: Color(0xFFEEEEEE),
              checkColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
            ),
          ),
          Text("Beni Hatırla",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(color: Color(0xFFEEEEEE)),
              )),
        ],
      ),
    );
  }

  LoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          authService.login(textEmail.text, textPassword.text).then((value) {
            var isMailVerified = authService.auth.currentUser!.emailVerified;
            if(value == null || isMailVerified == false){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
              Text("Giriş yapılamadı", style: TextStyle(fontSize: 16)),
              ));
            }else{
              user = value;
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => HomePage("Anasayfa"))
              );
            }
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          primary: Color(0xFFEEEEEE),
        ),
        child: Text("GİRİŞ YAP",
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

  SignInWithText() {
    return Text("-YA DA-",
        style: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Color(0xFFEEEEEE),
            fontWeight: FontWeight.w400,
          ),
        ));
  }

  SocialBtn() {
    return InkWell(
      onTap: () {
        GoogleSignIn signInUser = GoogleSignIn();
        //signInUser.signOut();
        authService.signInWithGoogle().then((value) {
          if(value.user == null){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
            Text("giriş yapılamadı", style: TextStyle(fontSize: 16)),
            ));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => HomePage("Anasayfa"))
            );
          }
        });
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEEEEEE),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            image: DecorationImage(
                image: AssetImage('assets/image/google-icon.png'))),
      ),
    );
  }

  SignupBtn() {
    return InkWell(
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Hala hesabın yok mu? ",
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 10.0,
                fontWeight: FontWeight.w400,
              ))),
          TextSpan(
              text: "Oluştur!",
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                color: Color(0xFFEEEEEE),
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ))),
        ]),
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
    );
  }
}
