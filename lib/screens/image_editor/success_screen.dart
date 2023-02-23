import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/Screens/Home/Home.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/components/text.dart';
import 'package:pdf_manager/components/style.dart';
import 'package:pdf_manager/controller/favourite_controller.dart';
import 'package:pdf_manager/screens/pdf_viewer/pdf_viewer.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class SuccessScreen extends StatefulWidget {
  final String path;
  const SuccessScreen({required this.path});
  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    cleanCache();
    super.initState();
  }

  cleanCache() async {
    // clear cache
    Directory filePickerDir = await Directory(
        '/data/user/0/com.pdf.editor.convertor.app/cache/file_picker/');
    filePickerDir.deleteSync(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        pushAndRemoveUntil(Home());
        return true;
      }),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Convert Success',
              style: TextStyle(fontSize: 16),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                fileWidget(),
                //
                SizedBox(height: 30),

                //
                optionTitle(),

                //
                SizedBox(height: 20),

                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [shareButton(), openButton(context)],
                )
              ],
            ),
          )),
    );
  }

  Container fileWidget() {
    return Container(
      decoration: decoration,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Image.asset(
            'assets/pdf.png',
            width: 25,
            height: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.path.split('/').last,
                  style: TextStyle(color: textColor),
                ),
                SizedBox(
                  height: 3,
                ),
                FutureBuilder(
                  future: File(widget.path).stat(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) return Container();
                    FileStat details = snapshot.data;
                    return Text(
                      getFileSize(File(widget.path)).toString() +
                          " " +
                          "MB" +
                          "  •  " +
                          details.modified.toIso8601String().split('T').first,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    );
                  },
                )
              ],
            ),
          ),
          GetBuilder<FavouriteController>(
              init: FavouriteController(),
              builder: (controller) {
                return IconButton(
                    onPressed: () {
                      if (controller.favourite.contains(widget.path)) {
                        controller.removeFromFavourite(File(widget.path));
                      } else {
                        controller.addToFavourite(File(widget.path));
                      }
                    },
                    icon: Icon(
                      controller.favourite.contains(widget.path)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: controller.favourite.contains(widget.path)
                          ? Colors.red
                          : Colors.grey,
                    ));
              })
        ],
      ),
    );
  }

  Row optionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: '---------------------------'),
        CustomText(
          text: 'OPTIONS',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        CustomText(text: '---------------------------'),
      ],
    );
  }

  SizedBox openButton(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 0),
        onPressed: () {
          push(CustomPDFViewer(file: File(widget.path)));
        },
        child: Center(
          child: CustomText(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            text: 'OPEN',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  SizedBox shareButton() {
    return SizedBox(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 0),
        onPressed: () {
          Share.shareFiles(['${widget.path}'],
              text: widget.path.split('/').last);
        },
        child: Center(
          child: CustomText(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            text: 'SHARE',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }
}
