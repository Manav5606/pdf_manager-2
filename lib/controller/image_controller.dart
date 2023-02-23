import 'dart:io';
import 'package:get/get.dart';

class ImageController extends GetxController implements GetxService {
  List<File>? list = [];
  int? selectedFile;

  updateImagesList(List<File> _list) {
    list = _list;
    update();
  }

  removeImageFromList(int index) {
    list!.removeAt(index);
    update();
  }

  setIndex(int index) {
    selectedFile = index;
    update();
  }

  updateSelectedFile(File file) {
    list!.removeAt(selectedFile!);
    list!.insert(selectedFile!, file);
    update();
  }

  static ImageController get instance => Get.put(ImageController());
}
