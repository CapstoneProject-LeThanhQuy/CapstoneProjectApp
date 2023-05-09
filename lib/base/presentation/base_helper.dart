import 'package:flutter/material.dart';
export 'package:flutter/material.dart';
export 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class BaseHelper {
  void showCustomDialog(Widget child) {
    showGeneralDialog(
      context: Get.context!,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return child;
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }
}
