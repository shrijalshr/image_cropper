// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class DisplayCroppedImage extends StatefulWidget {
  const DisplayCroppedImage({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  State<DisplayCroppedImage> createState() => _DisplayCroppedImageState();
}

class _DisplayCroppedImageState extends State<DisplayCroppedImage> {
  @override
  void initState() {
    super.initState();
  }

  // cropImage() {
  //   final imageFile = File(widget.imagePath);
  //   final image = Image.file(imageFile);
  //   final imag = image.image;
  //   final croppedImage = img.copyCrop(imag, 0, 0, 500, 200);
  // }

  getImgProp(imgpath) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(imgpath);
    print("Width : ${properties.width}");
    print("height : ${properties.height}");
    print("Image Orientation: ${properties.orientation}");
  }

  @override
  Widget build(BuildContext context) {
    getImgProp(widget.imagePath);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cropped Image"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.imagePath == null
                  ? const SizedBox(
                      child: Text("NUll"),
                    )
                  : Image.file(File(widget.imagePath)),
            ),
          ],
        ),
      ),
    );
  }
}
