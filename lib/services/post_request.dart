import 'package:dio/dio.dart';
import 'package:flutter_demo/services/api.dart';

class ApiRequest {
  final String route;
  final Map data;

  ApiRequest({required this.data, required this.route});
  Dio dio = Dio();
  Future<Map<String, dynamic>> postRequest() async {
    try {
      var res = await dio.post('$api/$route', data: data);
      return res.data;
    } catch (e) {
      return {'success': false, 'msg': 'Network failed'};
    }
  }
}
