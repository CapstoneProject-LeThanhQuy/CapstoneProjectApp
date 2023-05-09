import 'package:easy_english/feature/authentication/presentation/controller/landing/landing_controller.dart';
import 'package:get/get.dart';

class LandingBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(LandingController());
    }
}