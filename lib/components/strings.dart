import 'package:flutter/material.dart';

// ads
const bool showAds = false;
// Replace your facebook ads id here
String interstitialId = 'IMG_16_9_APP_INSTALL#466316102076288_466324115408820';
String bannerId = 'IMG_16_9_APP_INSTALL#466316102076288_466323942075504';
String rewardAdId = 'IMG_16_9_APP_INSTALL#466316102076288_466324218742143';

class AppString {
  // change your appname here
  static const String appName = "PDF Converter";

  // one signal app id for notifications
  static const String oneSignalAppId =
      '162f8fca-d845-4e74-a6fe-c2f643da1b9b'; // replace with your app id
  // your convert api secret
  static final convertAPIsecret = 'Secret=2QdXrcv67YJplkDG';

  // Do not changes below strings

  static final base = 'https://v2.convertapi.com/convert';

  static String docToPdf = "$base/docx/to/pdf?$convertAPIsecret";

  static String docxToPdf = "$base/docx/to/pdf?$convertAPIsecret";

  static String xlsToPdf = "$base/xls/to/pdf?$convertAPIsecret";

  static String xlsxToPdf = "$base/xlsx/to/pdf?$convertAPIsecret";

  static String extractImages = "$base/pdf/to/extract-images?$convertAPIsecret";

  static String splitPdf = "$base/pdf/to/split?$convertAPIsecret";

  static String tiff2png = "$base/tiff/to/png?$convertAPIsecret";
}

// paths - Donot change these
class PathString {
  static String pdfManageer = '/storage/emulated/0/${AppString.appName}';

  static String extractImages = '$pdfManageer/Extract Images';

  static String splitPdf = '$pdfManageer/Split Pdf';

  static String img2pdf = '$pdfManageer/Image to Pdf';

  static String compressPdf = '$pdfManageer/Compress Pdf';

  static String doc2Pdf = '$pdfManageer/Doc to Pdf';

  static String excel2Pdf = '$pdfManageer/Excel to Pdf';

  static String textExtraction = '$pdfManageer/Text Extraction';
}

BoxDecoration decoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.grey[100],
    border: Border.all(width: 0.4, color: Colors.grey));
