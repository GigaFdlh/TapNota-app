import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<String?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    return pickedFile?.path;
  }

  static Future<String? > pickFromCamera() async {
    return await pickImage(ImageSource.camera);
  }

  static Future<String?> pickFromGallery() async {
    return await pickImage(ImageSource.gallery);
  }
}