import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static void saveImage(value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    print('Image saved ${value}');
    preferences.setStringList(
      "images",
      value,
    );
  }
}
