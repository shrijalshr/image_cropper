// ignore_for_file: avoid_print

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mltest/main.dart';

import 'display_cropped_image.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late CameraController controller;
  XFile? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high,
        enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraViewHeight = MediaQuery.of(context).size.height * .4;
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        final String imgpath =
                            await takePicture(context, cameraViewHeight);
                        cropImageDefault(imgpath);
                      },
                      icon: const Icon(Icons.camera_alt_outlined)),
                  IconButton(
                      onPressed: () async {
                        final String imgpath =
                            await takePicture(context, cameraViewHeight);
                        cropImageCustom(imgpath);
                      },
                      icon: const Icon(Icons.camera_sharp)),
                  IconButton(
                      onPressed: () async {
                        pickedImagePath = await pickImage();
                        if (pickedImagePath != null) {
                          cropImageDefault(pickedImagePath!);
                        }
                      },
                      icon: const Icon(Icons.image)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String? pickedImagePath;

  Future<String?>? pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (image != null) {
      return image.path;
    }
    return null;
  }

  CroppedFile? croppedFile;

  cropCustomImage(String path) async {
    final file = await ImageCropper().cropImage(
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 10),
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
      ],
      sourcePath: path,
      uiSettings: [
        androidUiSettings(),
        iosUiSettings(),
      ],
    );
    if (file != null) {
      setState(() {
        croppedFile = file;
      });
    }
  }

  IOSUiSettings iosUiSettings() => IOSUiSettings(
        aspectRatioLockEnabled: false,
      );

  AndroidUiSettings androidUiSettings() => AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      toolbarColor: Colors.red,
      toolbarWidgetColor: Colors.white,
      lockAspectRatio: false,
      backgroundColor: Colors.white);

  Future<String> takePicture(
      BuildContext context, double cameraViewHeight) async {
    final image = await controller.takePicture();

    final String imagepath = image.path;

    return imagepath;
  }

  cropImageDefault(String imagepath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(imagepath);

    // // copyCrop(src, x, y, w, h)
    print("Image height: ${properties.height!}");
    print("Image width: ${properties.width!}");
    print("Image Orientation: ${properties.orientation}");

    File croppedImage = await FlutterNativeImage.cropImage(
        imagepath, 0, 0, properties.width!, (properties.height! * .3).toInt());
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayCroppedImage(
          // Pass the automatically generated path to
          // the DisplayPictureScreen widget.
          imagePath: croppedImage.path,
        ),
      ),
    );
  }

  cropImageCustom(String imagepath) async {
    cropCustomImage(imagepath);
    if (croppedFile != null) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayCroppedImage(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: croppedFile!.path,
          ),
        ),
      );
    }
  }
}
