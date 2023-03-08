import 'package:demo_assignment/controller/image_controller.dart';
import 'package:demo_assignment/screens/search_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  List savedData = [];
  List update = [];
  int length = 0;

  //GET FROM SHARED PREFERENCES
  void loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.reload();
    savedData = pref.getStringList("images") ?? [];

    //UPDATE GRIDVIEW PARAMETERS
    setState(() {
      length = savedData.length;
      update = savedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var imageController = Get.put(ImageController());
    loadData();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        title: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.to(const SearchImage()),
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 40),
              child: const Text(
                'Pictures',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            flex: 13,
            //DISPLAY DATA IN GRIDVIEW
            child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(SelectedImage(selectedImg: update[index]));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.network(
                        update[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
}

class SelectedImage extends StatelessWidget {
  const SelectedImage({super.key, required this.selectedImg});
  final dynamic selectedImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: Card(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                //READ IMAGES FROM UNSPLASH API
                selectedImg,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
