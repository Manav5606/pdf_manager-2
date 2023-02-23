import 'package:flutter/material.dart';

class ToolsCard extends StatelessWidget {
  final Function()? onPressed;
  final String image;
  final String text;
  final Color color;
  const ToolsCard(
      {required this.text,
      required this.image,
      required this.onPressed,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          side: BorderSide(width: 0.1, color: Colors.grey),
          backgroundColor: Colors.grey[100]),
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
              child: Image.asset(image, width: 25, height: 25),
            ),
          ),
          SizedBox(height: 10),
          FittedBox(
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class FolderCard extends StatelessWidget {
  final Function()? onPressed;
  final String image;
  final String text;
  const FolderCard({
    required this.text,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: Center(
              child: Image.asset(image),
            ),
          ),
          SizedBox(height: 10),
          FittedBox(
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
