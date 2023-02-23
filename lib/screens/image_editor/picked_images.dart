// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/Controller/Tools.dart';
import 'package:pdf_manager/components/custom_dialog.dart';
import 'package:pdf_manager/components/GridView/devdrag.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/text.dart';
import 'package:pdf_manager/components/style.dart';
import 'package:pdf_manager/controller/image_controller.dart';
import 'image_editor.dart';
import 'dart:typed_data';
class PickedImagesScreen extends StatefulWidget {
  final List<PlatformFile>? list;
  const PickedImagesScreen({required this.list});

  @override
  State<PickedImagesScreen> createState() => _PickedImagesScreenState();
}

class _PickedImagesScreenState extends State<PickedImagesScreen> {
  List<File> data = [];
  ImageController controller = Get.put(ImageController());
  TextEditingController fileName = TextEditingController();

  @override
  void initState() {
    initializeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageController>(
        init: ImageController(),
        builder: (imageController) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                actions: [
                  addMore(),
                  SizedBox(width: 10),
                  exportButton(),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: DragAndDropGridView(
                  itemCount: imageController.list!.length,
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      final element = imageController.list!.removeAt(oldIndex);
                      imageController.list!.insert(newIndex, element);
                    });
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (imageController.list!.length == 0)
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );

                    var file = data.elementAt(index);
                    return imageWidget(file, index);
                  },
                  onWillAccept: (int oldIndex, int newIndex) {
                    if (imageController.list!.length == 0) return false;
                    return true;
                  },
                ),
              ));
        });
  }

  exportButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 0),
      onPressed: () async {
        fileName.clear();
        showDialog(
            context: context,
            builder: (context) {
              return DialogFb1(
                controller: fileName,
                submit: () async {
                  await pop();
                  compute(
                      PDFTools.convertImageToPDF(
                          list: controller.list!, fileName: fileName.text),
                      [data, fileName.text]);
                  ;
                },
              );
            });
      },
      child: CustomText(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        text: 'EXPORT',
        fontSize: 12,
      ),
    );
  }

  addMore() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(elevation: 0),
      onPressed: () async {
        await FilePicker.platform
            .pickFiles(
          allowMultiple: true,
          type: FileType.image,
        )
            .then((value) {
          if (value != null) {
            setState(() {
              for (var file in value.files) {
                data.add(File(file.path!));
              }
            });
          }
        });
      },
      child: CustomText(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        text: 'ADD MORE',
        fontSize: 12,
      ),
    );
  }

  imageWidget(File file, int index) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<ImageController>(
          init: ImageController(),
          builder: (imageController) {
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Image.file(
                            file,
                            width: 120,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                          InkWell(
                            onTap: () {
                              controller.setIndex(index);
                              var provider = ExtendedFileImageProvider(
                                  File(file.path),
                                  cacheRawData: true,
                                  scale: 1);
                              push(ImageEditorScreen(provider: provider));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(Icons.edit),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                constraints:
                                    BoxConstraints(minHeight: 20, minWidth: 20),
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text("${index + 1}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ),
                              )),
                        ],
                      )),
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: InkWell(
                    child: Container(
                      width: 16,
                      height: 16,
                      child: Icon(
                        Icons.close,
                        color: buttonColor,
                        size: 14,
                      ),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 1),
                            blurRadius: 2),
                      ], shape: BoxShape.circle, color: Colors.white),
                    ),
                    onTap: () {
                      imageController.removeImageFromList(index);
                    },
                  ),
                )
              ],
            );
          }),
    );
  }

  void initializeList() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      for (var file in widget.list!) {
        data.add(File(file.path!));
        controller.updateImagesList(data);
      }
    });
  }
}
