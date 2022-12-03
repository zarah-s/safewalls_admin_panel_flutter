import 'package:dio/dio.dart';
import 'package:flutter_demo/services/api.dart';

class FileUpload {
  final String route;
  final Map data;
  final String file;
  final Function(int) progressCallback;
  FileUpload({
    required this.data,
    required this.route,
    required this.file,
    required this.progressCallback,
  });
  Dio dio = Dio();
  Future<Map<String, dynamic>> uploadFile() async {
    var ext = file.toString().split(".");
    var formData = FormData.fromMap({
      ...data,
      'file': MultipartFile.fromFile(
        file,
        filename:
            "file_${DateTime.now().millisecondsSinceEpoch}.${ext[ext.length - 1]}",
      ),
    });
    try {
      var res = await dio.post(
        '$api/$route',
        data: formData,
        onSendProgress: (int sent, int total) {
          int progress = ((sent * 100) / total).floor();
          progressCallback(progress);
        },
      );
      return res.data;
    } catch (e) {
      // print("----------------------------------------");
      return {'success': false, 'msg': 'Network failed'};
    }
  }
}
