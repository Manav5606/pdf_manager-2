import 'dart:io';
import 'package:get/get.dart';
import 'package:pdf_manager/components/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteController extends GetxController implements GetxService {
  List<String> favourite = [];
  SharedPreferences? pref;

  addToFavourite(File _file) async {
    pref = await SharedPreferences.getInstance();
    favourite.add(_file.path);
    pref!.setStringList('fav', favourite);
    getSnackBar("Added to favourite");
    update();
  }

  removeFromFavourite(File _file) async {
    pref = await SharedPreferences.getInstance();
    favourite.remove(_file.path);
    pref!.setStringList('fav', favourite);
    getSnackBar("Removed from favourite");
    update();
  }

  getFavList() async {
    pref = await SharedPreferences.getInstance();
    var list = pref!.getStringList('fav');

    if (list != null) {
      favourite = list;
    }
    update();
  }
}
