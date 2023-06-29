import 'dart:math' as math;
import 'dart:math';

import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/game/presentation/controller/game_play/game_play_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:get/get.dart';

class GamePlayPage extends BaseWidget<GamePlayController> {
  const GamePlayPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BaseAppBar(
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Điểm: 120',
                style: AppTextStyle.w600s14(ColorName.whiteFaf),
              ),
            ),
          )
      ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: LinearProgressIndicator(
            minHeight: 6,
            backgroundColor: ColorName.redEb5.withOpacity(0.4),
            valueColor: const AlwaysStoppedAnimation<Color>(ColorName.redEb5),
            value: 0.8,
          ),
        ),
      ),
      body: GameWidget(
        game: MyGame(
          height: height,
          width: width,
        ),
      ),
    );
  }
}

class MyGame extends FlameGame with TapCallbacks {
  List<String> test = ['MERCHANDISE'];

  @override
  Color backgroundColor() => ColorName.primaryColor;
  late Sprite player;
  double width;
  double height;

  MyGame({
    required this.height,
    required this.width,
  });

  @override
  void update(double dt) {
    super.update(dt);
  }

  int index = 1;
  void gamePlay() async {
    index = 1;
    text = test[Random().nextInt(test.length)];
    await Future.delayed(const Duration(seconds: 1));
    AppConfig.currentCharacter.value = text.substring(index - 1, index);
    List<String> test1 = text.split('');
    test1.shuffle();
    for (var char in test1) {
      await Future.delayed(const Duration(milliseconds: 300));
      Vector2 vector2 = Random().nextDouble() > 0.5
          ? Vector2(Random().nextDouble() > 0.5 ? width + 50 : 0 - 50, Random().nextDouble() * height)
          : Vector2(Random().nextDouble() * width, Random().nextDouble() > 0.5 ? height + 50 : 0 - 50);
      add(Square(
        vector2,
        height: height / 2.5 + 25,
        width: width / 2.2 + 25,
        callback: (result) {
          index += 1;
          if (index > text.length) {
            gamePlay();
          } else {
            AppConfig.currentCharacter.value = text.substring(index - 1, index);
          }
        },
        text: char,
      ));
    }
  }

  TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 25.0,
      fontFamily: 'Awesome Font',
    ),
  );

  String text = '';

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(canvas, 'Hàng hóa', Vector2(160, 50));
  }

  @override
  Future<void> onLoad() async {
    AppConfig.currentCharacter.value = 'A';
    final playerImage = await images.load('logo_icon.png');
    player = Sprite(playerImage);
    SpriteComponent(sprite: player);
    gamePlay();
    add(
      SpriteComponent(
        sprite: player,
        position: Vector2(width / 2.2, height / 2.5),
        size: Vector2(50, 50),
      ),
    );
  }

  // @override
  // void onTapDown(TapDownEvent event) {
  //   super.onTapDown(event);
  //   if (!event.handled) {
  //     final touchPoint = event.canvasPosition;
  //     add(Square(
  //       touchPoint,
  //       height: height / 2.5 + 25,
  //       width: width / 2.2 + 25,
  //       callback: (text) {
  //         AppConfig.currentCharacter.value = test[Random().nextInt(test.length)];
  //         AppConfig.currentCharacter.refresh();
  //         print("===============================");
  //         print(AppConfig.currentCharacter.value);
  //         print("===============================");
  //       },
  //       text: test[Random().nextInt(test.length)],
  //     ));
  //   }
  // }
}

class Square extends TextComponent with TapCallbacks {
  Function(String) callback;
  String text;
  double width;
  double height;

  static const speed = 2;
  static const squareSize = 250.0;
  static const indicatorSize = 6.0;

  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Square(
    Vector2 position, {
    required this.callback,
    required this.text,
    required this.height,
    required this.width,
  }) : super(
          text: text,
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
          textRenderer: TextPaint(style: AppTextStyle.w800s33(ColorName.whiteFff)),
        );

  double xPosition = 0;
  double yPosition = 0;

  @override
  void update(double dt) {
    super.update(dt);
    xPosition = (width == position.x + 25 || width == position.x - 25)
        ? position.x
        : width > position.x
            ? position.x + 0.5
            : position.x - 0.5;

    yPosition = (height == position.y + 100 || height == position.y - 100)
        ? position.y
        : height > position.y
            ? position.y + 0.5
            : position.y - 0.5;

    position = Vector2(xPosition, yPosition);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  void onTapDown(TapDownEvent event) {
    print(text);
    print(AppConfig.currentCharacter.value);
    if (AppConfig.currentCharacter.value == text) {
      removeFromParent();
      event.handled = true;
      callback(text);
    }
  }
}
