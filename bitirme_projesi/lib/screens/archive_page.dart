import 'package:bitirme_projesi/services/auth.dart';
import 'package:bitirme_projesi/widgets/add_sheet_widget.dart';
import 'package:bitirme_projesi/widgets/archive_widget.dart';
import 'package:bitirme_projesi/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Arşiv")),
      drawer: DrawerWidget(),
      body: ArchiveWidget(),
    );
  }
}
