import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:demo_assignment/controller/image_controller.dart';
import 'package:demo_assignment/screens/images_screen.dart';
import 'package:demo_assignment/services/save_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchImage extends StatefulWidget {
  const SearchImage({super.key});

  @override
  State<SearchImage> createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  var searchString = TextEditingController();
  List<String> imageList = []; //TO SEND LIST INTO SHARED PREFERENCES
  var btnText = 'Save';

  @override
  Widget build(BuildContext context) {
    var imgController = Get.put(ImageController()); //GETX CONTROLLER
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              setState(() {
                searchString.text = value;
              });
            },
            onFieldSubmitted: (value) async {
              await imgController.getData(searchString.text);
            },
            decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey[500])),
          ),
        ),
      ),
      body: Obx(
        //OBX TO LISTEN TO CHANGES IN SEARCH QUERY
        () => ListView.builder(
          itemCount: imgController.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        //READ IMAGES FROM UNSPLASH API
                        imgController.data[index]["urls"]["regular"],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  imageList.add(imgController.data[index]
                                      ["urls"]["regular"]);
                                });
                                //SAVE DATA INTO SHARED PREFERENCES
                                Utility.saveImage(
                                  imageList,
                                );

                                CherryToast.success(
                                        title: const Text(
                                          'Saved Successfully',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        displayTitle: false,
                                        description: Text(
                                          'Saved Successfully',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        animationType: AnimationType.fromTop,
                                        animationDuration:
                                            const Duration(milliseconds: 1000),
                                        autoDismiss: true)
                                    .show(context);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.save_alt_rounded,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    btnText,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.to(const ImagesScreen());
          },
          elevation: 5,
          backgroundColor: Colors.blueGrey,
          label: Row(
            children: const [
              Text(
                'Gallery',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 6,
              ),
              Icon(
                Icons.arrow_forward,
                size: 18,
              )
            ],
          )),
    );
  }
}
