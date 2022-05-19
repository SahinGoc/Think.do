import 'package:bitirme_projesi/services/stream.dart';
import 'package:flutter/material.dart';

class ArchiveWidget extends StatefulWidget {

  @override
  State<ArchiveWidget> createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  StreamService streamService = StreamService();

  @override
  Widget build(BuildContext context) {
    return streamService.getArchiveStream();
  }

}
