import 'package:flutter_demo/features/auth/login.dart';
import 'package:flutter_demo/models/data_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Provider extends GetxController {
  final asyncStore = GetStorage();
  DataModel _apiData = DataModel.fromJson({
    'posts': [],
    'walls': [],
    'pros': [],
    'users': [],
    'banned': [],
    'promotes': [],
    'avatars': [],
    'reports': [],
    'terms': '',
    'testimonies': [],
    'ratings': [],
    'allActiveUsers': [],
    'verificationRequest': []
  });

  DataModel get apiData => _apiData;

  saveApiData(DataModel data) {
    _apiData = data;
    update();
  }

  void logout() {
    asyncStore.remove('loggedIn');
    Get.offAll(() => const Login());
  }

  saveId(bool state) {
    asyncStore.write("loggedIn", state);
    update();
  }
}
