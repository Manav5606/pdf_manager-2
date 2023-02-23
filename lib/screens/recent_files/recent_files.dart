import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/Screens/Home/Home.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/components/style.dart';
import 'package:pdf_manager/controller/favourite_controller.dart';
import 'package:pdf_manager/screens/compress%20pdf/compress_pdf.dart';
import 'package:pdf_manager/screens/pdf_viewer/pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';

class FilesScreen extends StatefulWidget {
  final String text;
  const FilesScreen({required this.text});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  List<File>? _files;

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.text,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: GetBuilder<FavouriteController>(
            init: FavouriteController(),
            builder: (controller) {
              return _files == null
                  ? Container()
                  : RefreshIndicator(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _files!.length,
                          itemBuilder: (context, index) {
                            File file = _files!.elementAt(index);
                            return listItem(file, controller);
                          }),
                      onRefresh: () {
                        return getFiles();
                      });
            }),
      ),
    );
  }

  getFiles() async {
    await Permission.manageExternalStorage.request();
    Directory? extDir = await Directory(PathString.pdfManageer);
    var list = extDir.listSync(recursive: true);
    _files = [];
    setState(() {
      for (var a in list)
        if (a.path.endsWith(".pdf")) {
          if (a.path.contains('${widget.text}')) {
            _files!.add(File(a.path));
            print(a.path);
          }
        } else {}
    });
  }

  listItem(File file, FavouriteController controller) {
    return Container(
      decoration: decoration,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(),
        dense: true,
        onTap: () {
          push(CustomPDFViewer(file: file));
        },
        leading: Image.asset(
          'assets/pdf.png',
          width: 30,
          height: 30,
        ),
        title: Text(
          file.path.split('/').last,
          style: TextStyle(color: textColor),
        ),
        subtitle: FutureBuilder(
          future: file.stat(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) return Container();
            FileStat details = snapshot.data;
            return Text(
              getFileSize(file).toString() +
                  " " +
                  "MB" +
                  "  •  " +
                  details.modified.toIso8601String().split('T').first,
              style: TextStyle(fontSize: 12),
            );
          },
        ),
        trailing: options(file, controller),
      ),
    );
  }

  options(File file, FavouriteController controller) {
    return PopupMenuButton(onSelected: ((value) {
      if (value.toString() == 'Compress') {
        push(CompressPDF(file: file));
      }
    }), itemBuilder: ((context) {
      return [
        PopupMenuItem(
            onTap: () {
              Share.shareFiles(['${file.path}'],
                  text: file.path.split('Documents/').last);
            },
            child: Wrap(
              children: [
                Icon(
                  Icons.share_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Share'),
              ],
            )),
        PopupMenuItem(
            onTap: () {
              if (controller.favourite.contains(file.path)) {
                controller.removeFromFavourite(file);
              } else {
                controller.addToFavourite(file);
              }
            },
            child: Wrap(
              children: [
                Icon(
                  controller.favourite.contains(file.path)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: controller.favourite.contains(file.path)
                      ? Colors.red
                      : Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Favourite'),
              ],
            )),
        PopupMenuItem(
            value: 'Compress',
            child: Wrap(
              children: [
                Icon(
                  Icons.compress_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Compress'),
              ],
            )),
        PopupMenuItem(
            onTap: () {
              file.delete().then((value) => getFiles());
            },
            child: Wrap(
              children: [
                Icon(
                  Icons.delete_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Delete'),
              ],
            )),
      ];
    }));
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }
}
