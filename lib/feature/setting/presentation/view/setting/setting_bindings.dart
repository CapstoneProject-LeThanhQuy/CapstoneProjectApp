import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:get/get.dart';

class SettingBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
  }
}
