import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/feature/setting/presentation/controller/setting/setting_controller.dart';
import 'package:get/get.dart';
import './tab_bar_controller.dart';

class TabBarBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => CourseController());
    Get.lazyPut(() => GameController());
    Get.lazyPut(() => SettingController());
    Get.put(TabBarController());
  }
}
