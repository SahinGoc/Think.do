import 'package:bitirme_projesi/widgets/complete_widget.dart';
import 'package:bitirme_projesi/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatefulWidget {

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tamamlananlar")),
      drawer: DrawerWidget(),
      body: CompleteWidget(),
    );
  }
}
