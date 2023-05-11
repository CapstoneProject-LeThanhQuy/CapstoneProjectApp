import 'package:easy_english/base/data/local/local_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../../../../utils/config/app_navigation.dart';

class RootController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    LocalStorage();
    Future.delayed(const Duration(seconds: 1)).whenComplete(() async {
      FlutterNativeSplash.remove();
      N.toLandingPage();
    });
  }
}
