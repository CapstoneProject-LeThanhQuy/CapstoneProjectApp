import 'dart:ui';

import 'package:easy_english/feature/game/presentation/view/game_play/widget/game_controller.dart';

class Player {
  final GameController gameController;
  late int maxHealth;
  late int currentHealth;
  late Rect playerRect;
  bool isDead = false;

  Player(this.gameController) {
    maxHealth = currentHealth = 300;
    final size = gameController.tileSize! * 1.5;
    playerRect = Rect.fromLTWH(
      gameController.screenSize!.width / 2 - size / 2,
      gameController.screenSize!.height / 2 - size / 2,
      size,
      size,
    );
  }

  void render(Canvas c) {
    Paint color = Paint()..color = Color(0xFF0000FF);
    c.drawRect(playerRect, color);
  }

  void update(double t) {
    if (!isDead && currentHealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }

}
