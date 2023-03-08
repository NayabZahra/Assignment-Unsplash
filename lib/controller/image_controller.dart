import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  var selectedCategory = 0.obs;
  List photos = [];
  List data = [].obs;

  Future<String> getData(searchString) async {
    try {
      String endpoint =
          'https://api.unsplash.com/search/photos?client_id=iPtzAihpS2iCZxxAzr-Muy3Bv0tUrlcXcZ837NVz24I&query=${searchString}';

      Uri uri = Uri.parse(endpoint);
      var response = await http.get(uri);
      final Map<String, dynamic> converted = json.decode(response.body);
      photos = converted["results"];
      data.clear();
      for (int i = 0; i < photos.length; i++) {
        data.add(photos[i]);
      }
    } catch (e) {}
    return 'success';
  }
}
