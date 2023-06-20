import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/game/presentation/controller/game_play/game_play_controller.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

class GamePlayPage extends BaseWidget<GamePlayController> {
  const GamePlayPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    
    return Scaffold(
      appBar: BaseAppBar(),
      body: Container(
        child: GameWidget(
          game: MyGame(),
        ),
      ),
    );
  }
}

class MyGame extends FlameGame with TapCallbacks {
  @override
  Future<void> onLoad() async {
    add(Square(size / 2));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      add(Square(touchPoint));
    }
  }
}

class Square extends TextComponent with TapCallbacks {
  static const speed = 3;
  static const squareSize = 128.0;
  static const indicatorSize = 6.0;

  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      RectangleComponent(
        size: Vector2.all(indicatorSize),
        paint: blue,
      ),
    );
    add(
      RectangleComponent(
        position: size / 2,
        size: Vector2.all(indicatorSize),
        anchor: Anchor.center,
        paint: red,
      ),
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    event.handled = true;
  }
}
