import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData? icon;
  final double border;
  final double fontSize;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  const CustomTextField(
      {required this.controller,
      required this.text,
      required this.validator,
      this.border = 10,
      this.fontSize = 12,
      this.onFieldSubmitted,
      this.onChanged,
      this.onTap,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextFormField(
        onTap: onTap,
        textInputAction: TextInputAction.done,
        minLines: 1,
        maxLines: 1,
        style: TextStyle(color: Colors.black45, fontSize: fontSize),
        controller: controller,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: icon == null
              ? null
              : Icon(
                  icon,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          hintText: text,
          hintStyle: TextStyle(color: Colors.black45, fontSize: fontSize),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(border)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(border)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(border)),
          ),
        ),
      ),
    );
  }
}
