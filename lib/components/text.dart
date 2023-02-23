import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isAppBar;
  final Color color;
  final FontWeight? fontWeight;
  const CustomText(
      {required this.text,
      this.fontSize = 14,
      this.isAppBar = false,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
          color: color, //customize color here
          fontSize: fontSize,
          fontWeight: isAppBar ? FontWeight.bold : fontWeight),
    );
  }
}
