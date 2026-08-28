import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  static Future<List<File>> pickImages(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isEmpty) {
        return <File>[];
      }
      return pickedFiles.map((file) => File(file.path)).toList();
    }

    final singleFile = await pickImage(source);
    if (singleFile == null) {
      return <File>[];
    }

    return <File>[singleFile];
  }
}
