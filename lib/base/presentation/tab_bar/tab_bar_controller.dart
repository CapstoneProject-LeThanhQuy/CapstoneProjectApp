import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:get/get.dart';

class TabBarController extends BaseController {
  TabBarController();

  final currentIndex = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void onTabSelected(int index) {
    currentIndex.value = index;
  }
}
