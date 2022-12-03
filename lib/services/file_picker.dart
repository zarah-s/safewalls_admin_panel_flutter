import 'package:file_picker/file_picker.dart';

class CustomFilePicker {
  static Future<FilePickerResult?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      allowCompression: true,
      withReadStream: false,
    );

    if (result != null) {
      return result;
    } else {
      return null;
    }
  }
}
