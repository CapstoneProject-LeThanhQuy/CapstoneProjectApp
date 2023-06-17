import 'package:easy_english/feature/authentication/domain/usecases/get_account_info.dart';
import 'package:get/get.dart';
import '../../controller/root/root_controller.dart';

class RootBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAccountInfoUsecase(Get.find()));
    Get.put(RootController(
      Get.find(),
      Get.find(),
    ));
  }
}
