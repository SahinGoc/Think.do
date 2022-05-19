import 'package:bitirme_projesi/services/stream.dart';
import 'package:flutter/material.dart';

class CompleteWidget extends StatefulWidget {

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget> {
  StreamService streamService = StreamService();

  @override
  Widget build(BuildContext context) {
    return streamService.getCompleteStream();
  }
}
