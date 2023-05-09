import 'package:easy_english/feature/authentication/presentation/controller/register/register_controller.dart';
import 'package:get/get.dart';

class RegisterBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(RegisterController());
    }
}