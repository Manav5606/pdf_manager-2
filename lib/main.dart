import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pdf_manager/Controller/Tools.dart';
import 'package:pdf_manager/Controller/notification.dart';
import 'package:pdf_manager/Screens/splash.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/subscriptions/subscriptions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignalService.i.init();
  // crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  runApp(MyApp());
  initAppsFlyerSdk();
  // runApp(DevicePreview(
  //   enabled: !kReleaseMode,
  //   builder: (context) => MyApp(), // Wrap your app
  // ),);
}

void initAppsFlyerSdk() {
  final config = {
    'afDevKey': 'AYC9HftQteWuZdXMxmhADL',
    'afAppId': 'com.pdf.editor.convertor.app',
    'isDebug': true,
    'shouldLog': true,
  };
  final appsFlyerSdk = AppsflyerSdk(config);
  appsFlyerSdk.initSdk();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getPermission();
    super.initState();
  }

  getPermission() async {
    await getStoragePermission();
    await getExternalStoragePermission();
    PDFTools.manageDirectories();
  }

  Future<void> getStoragePermission() async {
    if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      getStoragePermission();
    } else {
      await Permission.storage.request();
    }
  }

  getExternalStoragePermission() async {
    if (await Permission.manageExternalStorage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.manageExternalStorage.request().isDenied) {
      getStoragePermission();
    } else {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      navigatorObservers: [FlutterSmartDialog.observer],  
      builder: FlutterSmartDialog.init(loadingBuilder: (string, color) {
        return InkWell(
          onTap: () {
            SmartDialog.dismiss();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: SizedBox(
                  width: 150,
                  height: 100,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        const CircularProgressIndicator.adaptive(),
                        const SizedBox(height: 15),
                        Center(
                            child: Text(string,
                                style: TextStyle(color: Colors.black54))),
                        const SizedBox(height: 15),
                      ]),
                ),
              )
            ],
          ),
        );
      }),
      theme: ThemeData(primarySwatch: Colors.red),
      // home: SplashScreen(),
      home: SubScriptions(),
    );
  }
}
