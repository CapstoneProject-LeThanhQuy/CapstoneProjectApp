import 'package:easy_english/feature/game/presentation/controller/game_play/game_play_controller.dart';
import 'package:get/get.dart';

class GamePlayBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(GamePlayController(Get.find()));
  }
}
