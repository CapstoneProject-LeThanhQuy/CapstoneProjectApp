import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePlayController extends BaseController {
  late SharedPreferences storage;

  @override
  void onInit() async {
    storage = await SharedPreferences.getInstance();
    super.onInit();
  }
}
