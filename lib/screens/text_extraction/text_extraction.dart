import 'package:flutter/material.dart';
import 'dart:typed_data';
class TextExtractionPage extends StatefulWidget {
  final String text;
  const TextExtractionPage({required this.text});

  @override
  State<TextExtractionPage> createState() => _TextExtractionPageState();
}

class _TextExtractionPageState extends State<TextExtractionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Success',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [Text(widget.text)],
      ),
    );
  }
}
