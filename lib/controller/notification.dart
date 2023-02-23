import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pdf_manager/components/strings.dart';

class OneSignalService {
  init() {
    OneSignal.shared.setAppId(AppString.oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  static OneSignalService i = OneSignalService();
}
