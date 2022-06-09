// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class CropScreen extends StatefulWidget {
//   const CropScreen({Key? key}) : super(key: key);

//   @override
//   State<CropScreen> createState() => _CropScreenState();
// }

// class _CropScreenState extends State<CropScreen> {
//   XFile? pickedFile;
//   CroppedFile? croppedFile;

//   Future<void> _uploadImage() async {
//     final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (file != null) {
//       setState(() {
//         pickedFile = file;
//       });
//       cropCustomImage(file.path);
//     }
//   }

//   cropCustomImage(String path) async {
//     final file = await ImageCropper().cropImage(
//       aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
//       cropStyle: CropStyle.rectangle,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.ratio16x9,
//       ],
//       sourcePath: path,
//       uiSettings: [
//         androidUiSettings(),
//         iosUiSettings(),
//       ],
//     );
//     if (file != null) {
//       setState(() {
//         croppedFile = file;
//       });
//     }
//   }

//   IOSUiSettings iosUiSettings() => IOSUiSettings(
//         aspectRatioLockEnabled: false,
//       );

//   AndroidUiSettings androidUiSettings() => AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         toolbarColor: Colors.red,
//         toolbarWidgetColor: Colors.white,
//         lockAspectRatio: false,
//       );
//   List<File> imageFiles = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Crop Screenp"),
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           children: [
//             const Text("Picked Image"),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: pickedFile == null
//                   ? const SizedBox(
//                       child: Text("NUll"),
//                     )
//                   : Image.file(File(pickedFile!.path)),
//             ),
//             const Text("Cropped Image"),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: croppedFile == null
//                   ? const SizedBox(
//                       child: Text("NUll"),
//                     )
//                   : Image.file(File(croppedFile!.path)),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Theme.of(context).primaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         onPressed: () {
//           _uploadImage();
//         },
//         child: const Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
