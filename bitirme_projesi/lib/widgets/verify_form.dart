import 'dart:async';

import 'package:bitirme_projesi/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({Key? key}) : super(key: key);

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {

  static const maxSecond = 5;
  int seconds = maxSecond;
  Timer? timer;
  var text = maxSecond.toString();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  () => FocusScope.of(context).unfocus(),
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
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Doğrulama Gönderildi",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  buildTimer(),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      "Hesabınızı doğrulayıp giriş yapabilirsiniz.",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildTimer() {
    return SizedBox(
      height: 180.0,
      width: 180.0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: seconds/maxSecond,
            valueColor: AlwaysStoppedAnimation(Color(0xFFEEEEEE)),
            backgroundColor: Colors.grey,
            strokeWidth: 8.0,
          ),
          Center(child: Text(text,
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Color(0xFFEEEEEE),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              )),
          )
        ],
      ),
    );
  }

  startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if(seconds > 0){
          seconds--;
          text = seconds.toString();
          print(seconds);
        }else{
          stopTimer();
          timer.cancel();
        }
      });
    });
  }

  stopTimer() {
    timer?.cancel();
    setState(() {
      text = "Yönlendiriliyor";
    });
    dispose();
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }
}
