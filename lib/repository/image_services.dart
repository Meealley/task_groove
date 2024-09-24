import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:task_groove/services/toast_service.dart';
import 'package:task_groove/utils/toast_message_services.dart'; // Example of ToastService import

class ImagePickerService {
  static final ImagePicker picker = ImagePicker();

  static Future<File?> pickSingleImage({required BuildContext context}) async {
    File? selectedImage;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    XFile? filePick = pickedFile;
    if (filePick != null) {
      selectedImage = File(filePick.path);
      return selectedImage;
    } else {
      // Show toast Error message
      ToastService.sendScaffoldAlert(
        msg: "No Images Selected",
        toastStatus: 'WARNING',
        context: context,
      );
      return null;
    }
  }
}
