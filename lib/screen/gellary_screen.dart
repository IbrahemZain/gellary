import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gellary/controller/get_controller.dart';
import 'package:gellary/screen/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class GellaryScreen extends StatefulWidget {
  const GellaryScreen({Key? key}) : super(key: key);

  @override
  State<GellaryScreen> createState() => _GellaryScreenState();
}

class _GellaryScreenState extends State<GellaryScreen> {
  final controller = Get.put(GetController());
  late File file;
  bool _isLoading = false;
  List<dynamic> images = [''];

  @override
  void initState() {
    getImagesFromServer();
    super.initState();
  }

  getImagesFromServer() async {
    setState(() {
      _isLoading = true;
    });
    await controller.getImages();
    images = controller.Images;
    setState(() {
      _isLoading = false;
    });
  }

  handleTakePhoto() async {
    Get.back();
    PickedFile? file = (await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    ));
    setState(() {
      this.file = File(file!.path);
    });
    uploadImageToServer();
  }

  handleChooseFromGallery() async {
    Get.back();
    PickedFile? file =
        (await ImagePicker.platform.pickImage(source: ImageSource.gallery));
    setState(() {
      this.file = File(file!.path);
    });
    uploadImageToServer();
  }

  uploadImageToServer() async {
    String result = await controller.uploadImage(file);
    if (result == "success") {
      Get.snackbar("Upload Image", "Success",
          snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.blue);
    } else if (result.toString() == "something went wrong") {
      Get.defaultDialog(
          title: "Something went wrong ",
          content: const Text('Try again'),
          confirm: TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Ok")),
          onConfirm: () {
            Get.back();
          });
    }
  }

  selectImage(parentContext) {
    return Get.defaultDialog(
      radius: 20,
      backgroundColor: Colors.white54,
      actions: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              color: Color(0xFFEFD8F9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/gallery.png'),
                  width: 30,
                  height: 30,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
                TextButton(
                  onPressed: handleChooseFromGallery,
                  child: const Text(
                    "Gallery",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              color: Color(0xFFEBF6FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/camera.png'),
                  width: 40,
                  height: 40,
                  color: null,
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
                TextButton(
                  onPressed: handleTakePhoto,
                  child: const Text(
                    "Camera",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      title: "",
      cancel: const Text(""),
      confirm: const Text(""),
      content: const Text(""),
    );
  }

  buildTitleOfPage(){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .2,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height * .2,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.grey.shade400,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome\n${controller.userName}",
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ),
              )),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/4/49/A_black_image.jpg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildListOfImage(){
    return Container(
      height: MediaQuery.of(context).size.height >= 600
          ? MediaQuery.of(context).size.height * .7
          : MediaQuery.of(context).size.height * .55,
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .05,
        ),
        itemCount: controller.Images.length,
        itemBuilder: (ctx, i) {
          return InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                controller.Images[i],
                fit: BoxFit.fill,
              ),
            ),
          );
        },
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio:
          MediaQuery.of(context).size.height >= 600
              ? 3 / 3
              : 4.5 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
  buildUploadLogoutButton(){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // button for log out
          Container(
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: () {
                Get.offAll(() => const LoginScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.pink,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => LoginScreen());
                    },
                    child: const Text(
                      "log out",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // button for upload
          Container(
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: () {
                selectImage(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber,
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      selectImage(context);
                    },
                    child: const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, //Colors.grey.shade400,
      body: ListView(
        children: [
          // the title of the page
          buildTitleOfPage(),
          //buttons to upload and logout
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .8,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                // buttons to upload and logout
                buildUploadLogoutButton(),
                // list of images
                _isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : buildListOfImage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
