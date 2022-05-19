import 'package:bitirme_projesi/widgets/verify_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyPage extends StatelessWidget {
  GlobalKey _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    key: _key,
    body: AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: VerifyForm()),
    );
  }
}
