import 'package:get/get.dart';
import 'package:medical_app/services/auth_services.dart';

class Global {
  static Future<void> init() async {
    Get.lazyPut(() => AuthServices());
  }
}