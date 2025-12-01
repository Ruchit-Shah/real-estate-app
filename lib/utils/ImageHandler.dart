import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:developer';

class ImageHandler {
  final ImagePicker picker = ImagePicker();
  final Function(File) onImageSelected;
  final BuildContext context;

  ImageHandler({required this.context, required this.onImageSelected});

  Future<void> showImageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 90,
          child: Column(
            children: <Widget>[
              const Text(
                "Choose Photo",
                style: TextStyle(fontSize: 15.0),
              ),
              Divider(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () => getCameraImage(),
                    icon: const Icon(Icons.camera, color: Colors.black54, size: 15),
                    label: const Text("Camera", style: TextStyle(color: Colors.black54, fontSize: 15)),
                  ),
                  TextButton.icon(
                    onPressed: () => getGalleryImage(),
                    icon: const Icon(Icons.image, color: Colors.black54, size: 15),
                    label: const Text("Gallery", style: TextStyle(color: Colors.black54, fontSize: 15)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getCameraImage() async {
    try {
      Navigator.of(context).pop(false);
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        cropImage(File(pickedFile.path));
      }
    } catch (e) {
      log("$e");
    }
  }

  Future<void> getGalleryImage() async {
    Navigator.of(context).pop(false);
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      cropImage(File(pickedFile.path));
    }
  }

  Future<void> cropImage(File image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );
    if (croppedFile != null) {
      onImageSelected(File(croppedFile.path));
    }
  }
}
