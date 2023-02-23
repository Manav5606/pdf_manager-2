// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:pdf_manager/model/extract_images.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/snackbar.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/screens/image_editor/success_screen.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class PDFTools {
  static convertImageToPDF(
      {required List<File> list, required String fileName}) async {
    SmartDialog.showLoading(msg: "Converting...");
    //Create the PDF document
    final pdf = pw.Document();

    List<pw.MemoryImage> imageList = [];

    //Add the page
    for (var file in list) {
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 60, percentage: 60);
      final image = pw.MemoryImage(
        compressedFile.readAsBytesSync(),
      );
      imageList.add(image);
    }

    for (var image in imageList) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ));
    }

    // pdf.addPage(pw.MultiPage(build: (pw.Context context) {
    //   return [
    //     for (var item in imageList)
    //       pw.Padding(
    //           padding: pw.EdgeInsets.only(bottom: 20),
    //           child: pw.Center(child: pw.Image(item))),
    //   ];
    // }));

    //Save the docuemnt
    final file = File("${PathString.img2pdf}/${fileName}.pdf");
    await file.writeAsBytes(await pdf.save());
    SmartDialog.dismiss();
    push(SuccessScreen(path: "${PathString.img2pdf}/${fileName}.pdf"));
  }

  static Future<String> compressor(
      {required CompressQuality quality, required File file}) async {
    SmartDialog.showLoading(msg: "Compressing...");
    try {
      final memoryFile = File(file.path);
      final pdf = PdfDocument(inputBytes: memoryFile.readAsBytesSync());
    } catch (e) {
      return 'this file is protected';
    }
    final inputFilePath = file.path;
    final outputFilePath =
        '${PathString.compressPdf}/${file.path.split('/').last.split('.').first + " - Compressed.pdf"}';
    print(outputFilePath);
    await PdfCompressor.compressPdfFile(inputFilePath, outputFilePath, quality);

    SmartDialog.dismiss();

    return outputFilePath;
  }

  static Future<File> docToPdf(File file, String type) async {
    SmartDialog.showLoading(msg: "Converting");
    //
    String fileName = file.path.split('/').last;
    Uint8List? fileInByte = await file.readAsBytesSync();
    String docFiledata = await base64Encode(fileInByte);
    return http
        .post(
      Uri.parse(getUrl(file)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Parameters": [
          {
            "Name": "File",
            "FileValue": {"Name": fileName, "Data": docFiledata}
          },
        ]
      }),
    )
        .then((response) async {
      print(response.body);
      var json = jsonDecode(response.body);
      //
      var outputFileName = json['Files'][0]['FileName'];
      var outputFileData = json['Files'][0]['FileData'];
      //
      Base64Decoder decoder = Base64Decoder();
      var data = await decoder.convert(outputFileData);
      //
      File file = type == 'doc'
          ? File("${PathString.doc2Pdf}/$outputFileName")
          : File("${PathString.excel2Pdf}/$outputFileName");
      file.createSync(recursive: true); // create new file
      await file.writeAsBytes(data); // write data to file
      //
      SmartDialog.dismiss();
      return file;
    });
  }

  static pdfTool(File file, {bool isSplit = false}) async {
    SmartDialog.showLoading(msg: "Loading...");
    //
    String fileName = file.path.split('/').last;
    Uint8List? fileInByte = await file.readAsBytesSync();
    String docFiledata = await base64Encode(fileInByte);
    return http
        .post(
      Uri.parse(isSplit ? AppString.splitPdf : AppString.extractImages),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Parameters": [
          {
            "Name": "File",
            "FileValue": {"Name": fileName, "Data": docFiledata}
          },
        ]
      }),
    )
        .then((response) async {
      pdfToImages(response.body, isSplit: isSplit);
    });
  }

  static pdfToImages(String response, {bool isSplit = false}) async {
    String path =
        isSplit == true ? PathString.splitPdf : PathString.extractImages;

    // convert json to model
    ExtractImages data = ExtractImages.fromJson(jsonDecode(response));

    // create directory
    var dir =
        await Directory('$path/${data.files!.first.fileName!.split('.').first}')
            .create();

    // write data
    for (var item in data.files!) {
      var outputFileName = item.fileName;
      var outputFileData = item.fileData;

      //
      Base64Decoder decoder = Base64Decoder();
      var data = await decoder.convert(outputFileData!);
      //

      // if file is not tiff
      if (!outputFileName!.endsWith('.tiff')) {
        File file = File("${dir.path}/$outputFileName");
        file.createSync(recursive: true); // create new file
        await file.writeAsBytes(data); // write data to file
      }
      // if file is .tiff
      else {
        if (isSplit == false) {
          ExtractImages pngData = await tiff2png(data, outputFileName);

          var outputFileName1 = pngData.files!.first.fileName;
          var outputFileData1 = pngData.files!.first.fileData;

          // convert data
          Base64Decoder decoder = Base64Decoder();
          var data1 = await decoder.convert(outputFileData1!);

          // create file and write data
          File file = File("${dir.path}/$outputFileName1");
          file.createSync(recursive: true); // create new file
          await file.writeAsBytes(data1); // write data to file
        }
      }
    }

    //
    SmartDialog.dismiss();
    getSnackBar(
        isSplit ? 'Split successfully' : 'Images extracted successfully');
  }

  static Future<ExtractImages> tiff2png(Uint8List data, String fileName) async {
    String docFiledata = await base64Encode(data);
    return http
        .post(
          Uri.parse(AppString.tiff2png),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "Parameters": [
              {
                "Name": "File",
                "FileValue": {"Name": fileName, "Data": docFiledata}
              },
            ]
          }),
        )
        .then((response) => ExtractImages.fromJson(jsonDecode(response.body)));
  }

  textExtraction(File file) async {
    SmartDialog.showLoading(msg: 'Extracting text...');
    PDFDoc? _pdfDoc = await PDFDoc.fromFile(file);
    String text = await _pdfDoc.text;
    createFile(text, file.path.split('/').last.split('.').first);
  }

  createFile(String text, String filename) async {
    // create directory
    String? directory;

    directory = PathString.textExtraction;

    // create image file
    File file = await File('$directory/$filename.pdf').create();

    final pdf = pw.Document();
    log(text);
    // create pdf
    pdf.addPage(pw.MultiPage(
        maxPages: 1000,
        build: (pw.Context context) {
          return [
            pw.Wrap(
              children: [
                for (var item in text.split('\n'))
                  pw.Wrap(
                      direction: pw.Axis.horizontal, children: [pw.Text(item)])
              ],
            )
          ];
        }));
    //
    var data = await pdf.save();
    file = await File('$directory/$filename.pdf');
    await file.writeAsBytes(data);
    SmartDialog.dismiss();
    getSnackBar('Success');
  }

  static String getUrl(File file) {
    if (file.path.endsWith('.doc')) {
      return AppString.docToPdf;
    } else if (file.path.endsWith('.docx')) {
      return AppString.docxToPdf;
    } else if (file.path.endsWith('.xls')) {
      return AppString.xlsToPdf;
    } else if (file.path.endsWith('.xlsx')) {
      return AppString.xlsxToPdf;
    }
    return AppString.docToPdf;
  }

  //////////////////// MANAGE DIRECTORIES ///////////////////

  static manageDirectories() async {
    await Directory(PathString.pdfManageer).create();
    await Directory(PathString.img2pdf).create();
    await Directory(PathString.compressPdf).create();
    await Directory(PathString.doc2Pdf).create();
    await Directory(PathString.excel2Pdf).create();
    await Directory(PathString.textExtraction).create();
    await Directory(PathString.extractImages).create();
    await Directory(PathString.splitPdf).create();
    deleteCache();
  }

  static deleteCache() async {
    //
    Directory cacheDir = await Directory(
        '/data/user/0/com.pdf.editor.convertor.app/cache/');
    Directory filePickerDir = await Directory(
        '/data/user/0/com.pdf.editor.convertor.app/cache/file_picker/');
    if (cacheDir.existsSync()) {
      var list = cacheDir.listSync();

      for (var item in list) {
        item.deleteSync(recursive: true);
      }
    }
    if (filePickerDir.existsSync()) {
      filePickerDir.deleteSync(recursive: true);
    }
  }
}
