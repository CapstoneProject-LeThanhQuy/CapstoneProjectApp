import 'dart:math';
import 'dart:ui';

import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/enemy.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/health_bar.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/highscore_text.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/player.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/score_text.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/components/start_text.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/enemy_spawner.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/widget/state.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';

class GameController extends Game {
  Random? rand;
  Size? screenSize;
  double? tileSize;
  Player? player;
  EnemySpawner? enemySpawner;
  List<Enemy>? enemies;
  HealthBar? healthBar;
  int? score;
  ScoreText? scoreText;
  State? state;
  HighscoreText? highscoreText;
  StartText? startText;

  GameController();

  void initialize() async {
    // resize(await Flame.util.initialDimensions());
    state = State.menu;
    rand = Random();
    player = Player(this);
    enemies = [];
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize!.width, screenSize!.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player!.render(c);

    if (state == State.menu) {
      startText!.render(c);
      highscoreText!.render(c);
    } else if (state == State.playing) {
      enemies!.forEach((Enemy enemy) => enemy.render(c));
      scoreText!.render(c);
      healthBar!.render(c);
    }
  }

  void update(double t) {
    if (state == State.menu) {
      startText!.update(t);
      highscoreText!.update(t);
    } else if (state == State.playing) {
      enemySpawner!.update(t);
      enemies!.forEach((Enemy enemy) => enemy.update(t));
      enemies!.removeWhere((Enemy enemy) => enemy.isDead);
      player!.update(t);
      scoreText!.update(t);
      healthBar!.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize!.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == State.menu) {
      state = State.playing;
    } else if (state == State.playing) {
      enemies!.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x = 0, y = 0;
    switch (rand!.nextInt(4)) {
      case 0:
        // Top
        x = rand!.nextDouble() * screenSize!.width;
        y = -(tileSize! * 2.5);
        break;
      case 1:
        // Right
        x = screenSize!.width + tileSize! * 2.5;
        y = rand!.nextDouble() * screenSize!.height;
        break;
      case 2:
        // Bottom
        x = rand!.nextDouble() * screenSize!.width;
        y = screenSize!.height + tileSize! * 2.5;
        break;
      case 3:
        // Left
        x = -tileSize! * 2.5;
        y = rand!.nextDouble() * screenSize!.height;
        break;
    }
    enemies!.add(Enemy(this, x, y));
  }
}
