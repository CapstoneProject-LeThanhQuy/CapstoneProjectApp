import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:get/get.dart';

class GameBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(GameController());
  }
}
