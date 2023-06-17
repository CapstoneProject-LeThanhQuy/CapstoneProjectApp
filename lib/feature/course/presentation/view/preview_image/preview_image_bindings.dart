import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';
import 'package:get/get.dart';

class PreviewImageBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(PreviewImageController());
  }
}
