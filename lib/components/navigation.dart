import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

pushAndRemoveUntil(Widget page) {
  return Navigator.of(Get.context!, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => page), (route) => false);
}

push(Widget page) {
  return Navigator.push(Get.context!, CupertinoPageRoute(builder: (_) => page));
}

rootPush(Widget page) {
  return Navigator.of(Get.context!, rootNavigator: true)
      .push(CupertinoPageRoute(builder: (_) => page));
}

pushReplacement(Widget page) {
  return Navigator.pushReplacement(
      Get.context!, CupertinoPageRoute(builder: (_) => page));
}

pop() {
  return Navigator.pop(Get.context!);
}
