import 'package:get/get.dart';
import 'package:flutter/material.dart';

getSnackBar(String message, {bool isGreen = true}) {
  return Get.showSnackbar(GetSnackBar(
    backgroundColor: isGreen ? Colors.green : Colors.red,
    message: message,
    duration: Duration(seconds: 3),
  ));
}
