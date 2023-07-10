import 'package:easy_english/feature/authentication/domain/usecases/get_account_info.dart';
import 'package:easy_english/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:easy_english/feature/authentication/presentation/controller/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginUsecase(Get.find()));
    Get.lazyPut(() => GetAccountInfoUsecase(Get.find()));
    Get.put(LoginController(
      Get.find(),
      Get.find(),
      Get.find(),
    ));
  }
}
