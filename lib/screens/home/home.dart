import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/components/images.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/components/text.dart';
import 'package:pdf_manager/components/tools_card.dart';
import 'package:pdf_manager/controller/ad_controller.dart';
import 'package:pdf_manager/controller/image_controller.dart';
import 'package:pdf_manager/controller/tools.dart';
import 'package:pdf_manager/screens/compress%20pdf/compress_pdf.dart';
import 'package:pdf_manager/screens/favourite/favourite.dart';
import 'package:pdf_manager/screens/image_editor/picked_images.dart';
import 'package:pdf_manager/screens/image_editor/success_screen.dart';
import 'package:pdf_manager/screens/recent_files/recent_files.dart';

import 'dart:typed_data';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AdsProvider.adWidget(),
        appBar: AppBar(
          elevation: 0,
          title: Text(AppString.appName, style: TextStyle(fontSize: 16)),
          actions: [
            IconButton(
                onPressed: () {
                  push(FavourtieScreen());
                },
                icon: Icon(Icons.favorite_border_rounded))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                CustomText(text: "Tools", fontSize: 20, isAppBar: true),
                SizedBox(height: 10),
                tools(),
                SizedBox(height: 20),
                CustomText(
                  text: "Recent Files",
                  fontSize: 20,
                  isAppBar: true,
                ),
                recentFiles()
              ],
            ),
          ),
        ));
  }

  // Future fetchOffers() async {
  //   final offerings = await PurchaseApi.fetchOffers();
  //   if (offerings.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('No Plans Found'),
  //     )); // SnackBar I
  //   } else {
  //     final offer = offerings.first;
  //     print('Offer: $offer');
  //   }
  // }

  tools() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: [
        ToolsCard(
            text: 'Image to Pdf',
            image: Images.img2pdf,
            color: Colors.green.shade900,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              ImageController.instance.updateImagesList([]);
              pickImage();
            }),
        ToolsCard(
            color: Colors.lightBlueAccent,
            text: 'Doc to Pdf',
            image: Images.doc2pdf,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickDoc('doc');
            }),
        ToolsCard(
            text: 'Split Pdf',
            image: Images.splitPdf,
            color: Colors.red,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickPdf(splitPdf: true);
            }),
        ToolsCard(
            color: Colors.green,
            text: 'Excel to Pdf',
            image: Images.excel2Pdf,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickDoc('excel');
            }),
        ToolsCard(
            color: Colors.purple,
            text: 'Text Extraction',
            image: Images.textextraction,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickPdf(isTextExtraction: true);
            }),
        ToolsCard(
            text: 'Compress Pdf',
            image: Images.compressPdf,
            color: Colors.green,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickPdf();
            }),
        ToolsCard(
            text: 'Extract Images',
            image: Images.extractImage,
            color: Colors.green.shade900,
            onPressed: () {
              AdsProvider.instance.showInterstitialAd();
              pickPdf(extractImages: true);
            }),
      ],
    );
  }

  void displayError(BuildContext context, PlatformException error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.message!)));
  }

  recentFiles() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      childAspectRatio: 1,
      children: [
        FolderCard(
          image: Images.folder,
          text: 'Image to Pdf',
          onPressed: () {
            push(FilesScreen(text: 'Image to Pdf'));
          },
        ),
        FolderCard(
          image: Images.folder,
          text: 'Doc to Pdf',
          onPressed: () {
            push(FilesScreen(text: 'Doc to Pdf'));
          },
        ),
        FolderCard(
          image: Images.folder,
          text: 'Excel to Pdf',
          onPressed: () {
            push(FilesScreen(text: 'Excel to Pdf'));
          },
        ),
        FolderCard(
          image: Images.folder,
          text: 'Text Extraction',
          onPressed: () {
            push(FilesScreen(text: 'Text Extraction'));
          },
        ),
        FolderCard(
          image: Images.folder,
          text: 'Split Pdf',
          onPressed: () {
            push(FilesScreen(text: 'Split Pdf'));
          },
        ),
      ],
    );
  }

  pickImage() async {
    var images = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: true,
      type: FileType.image,
    );

    if (images != null) {
      push(PickedImagesScreen(list: images.files));
    }
  }

  pickPdf(
      {bool isTextExtraction = false,
      bool extractImages = false,
      bool mergePdf = false,
      bool splitPdf = false}) async {
    var result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        allowMultiple: mergePdf,
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    if (result != null) {
      if (isTextExtraction) {
        PDFTools().textExtraction(File(result.files.first.path!));
      } else if (extractImages) {
        PDFTools.pdfTool(File(result.files.first.path!));
      } else if (splitPdf) {
        PDFTools.pdfTool(File(result.files.first.path!), isSplit: true);
      } else {
        push(CompressPDF(file: File(result.files[0].path!)));
      }
    }
  }

  pickDoc(String type) async {
    var result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: type == 'doc' ? ['doc', 'docx'] : ['xls', 'xlsx']);

    if (result != null) {
      PDFTools.docToPdf(File(result.files[0].path!), type).then((file) {
        push(SuccessScreen(path: file.path));
      });
    }
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }
}
