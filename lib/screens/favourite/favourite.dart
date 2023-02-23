import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/components/style.dart';
import 'package:pdf_manager/controller/favourite_controller.dart';
import 'package:pdf_manager/screens/compress%20pdf/compress_pdf.dart';
import 'package:pdf_manager/screens/pdf_viewer/pdf_viewer.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
class FavourtieScreen extends StatefulWidget {
  const FavourtieScreen({Key? key}) : super(key: key);

  @override
  State<FavourtieScreen> createState() => _FavourtieScreenState();
}

class _FavourtieScreenState extends State<FavourtieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'FAVOURITE',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: GetBuilder<FavouriteController>(
            init: FavouriteController(),
            builder: (controller) {
              return controller.favourite.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 200,
                          ),
                          Text(
                            'No favorites yet',
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return Container(height: 0.3, color: Colors.grey);
                      },
                      itemCount: controller.favourite.length,
                      itemBuilder: (context, index) {
                        var file = File(controller.favourite.elementAt(index));
                        return listItem(file, controller);
                      });
            }),
      ),
    );
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
          push(CustomPDFViewer(file: File(file.path)));
        },
        leading: Image.asset(
          'assets/pdf.png',
          width: 30,
          height: 30,
        ),
        title: Text(
          file.path.split('/').last,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
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

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }

  options(File file, FavouriteController controller) {
    return PopupMenuButton(itemBuilder: ((context) {
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
            onTap: () {
              push(CompressPDF(file: file));
            },
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
      ];
    }));
  }
}
