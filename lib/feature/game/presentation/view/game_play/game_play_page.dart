import 'dart:math' as math;
import 'dart:math';

import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/text_to_speech.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
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
              child: Obx(
                () => Text(
                  'Điểm: ${controller.point.value}',
                  style: AppTextStyle.w600s14(ColorName.whiteFaf),
                ),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Obx(
            () => LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: ColorName.redEb5.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation<Color>(ColorName.redEb5),
              value: controller.heald.value / 10,
            ),
          ),
        ),
      ),
      body: GameWidget(
        game: MyGame(
          height: height,
          width: width,
          listWord: controller.input,
          callback: (point, heald) {
            controller.point.value = point;
            controller.heald.value = heald;

            if (heald == 0) {
              controller.gameOver();
            }
          },
        ),
      ),
    );
  }
}

class GameDispalyEnglish {
  String text;
  Color color;

  GameDispalyEnglish(this.text, this.color);
}

class MyGame extends FlameGame with TapCallbacks {
  List<Vocabulary> listWord = [];

  CommonTextToSpeech commonTextToSpeech = CommonTextToSpeech();

  @override
  Color backgroundColor() => ColorName.primaryColor;
  late Sprite player;
  double width;
  double height;
  Function(int, int) callback;
  int heald = 10;
  int point = 0;

  MyGame({
    required this.height,
    required this.width,
    required this.listWord,
    required this.callback,
  });

  void gamePlay() async {
    Vocabulary vocabulary = listWord[Random().nextInt(listWord.length)];
    text = vocabulary.englishText;
    resultGame = [
      for (var i = 0; i < vocabulary.englishText.length; i += 1) GameDispalyEnglish('', ColorName.primaryColor)
    ];
    vietnameseText = vocabulary.vietnameseText;
    await Future.delayed(const Duration(milliseconds: 500));
    AppConfig.currentCharacter.value = text.substring(0, 1);
    List<String> englishTextArray = text.split('');
    englishTextArray.reverse();
    for (var char in englishTextArray) {
      await Future.delayed(const Duration(milliseconds: 300));
      Vector2 vector2 = Random().nextDouble() > 0.5
          ? Vector2(Random().nextDouble() > 0.5 ? Random().nextDouble() * width + 50 : 0 - 50, height)
          : Vector2(Random().nextDouble() * width, Random().nextDouble() > 0.5 ? height + 50 : 0 - 50);
      var isDouble = Random().nextDouble() < 0.05;
      add(Square(
        isDouble: isDouble,
        objectPosition: vector2,
        height: height / 2.5 + 25,
        width: width / 2.2 + 25,
        callbackComplete: (result) {
          point = point + (isDouble ? 5 : 1);
          callback(point, heald);
          var findIndex = 0;
          for (var i = 0; i < text.length; i++) {
            // ignore: unrelated_type_equality_checks
            if (text.substring(i, i + 1) == result && resultGame[i].text == '') {
              findIndex = i;
              break;
            }
          }
          resultGame[findIndex] = GameDispalyEnglish(result, isDouble ? ColorName.yellowFff : ColorName.whiteFff);

          var findIndexCurrentText = -1;

          for (var i = 0; i < resultGame.length; i++) {
            if (resultGame[i].text == '') {
              findIndexCurrentText = i;
              break;
            }
          }

          if (findIndexCurrentText == -1) {
            commonTextToSpeech.speech(
              text,
              completed: () {
                if (heald > 0) {
                  gamePlay();
                }
              },
            );
          } else {
            AppConfig.currentCharacter.value = text.substring(findIndexCurrentText, findIndexCurrentText + 1);
          }
        },
        callbackError: (result) {
          heald = heald - 1;
          callback(point, heald);
          var findIndex = 0;
          for (var i = 0; i < text.length; i++) {
            // ignore: unrelated_type_equality_checks
            if (text.substring(i, i + 1) == result && resultGame[i].text == '') {
              findIndex = i;
              break;
            }
          }
          resultGame[findIndex] = GameDispalyEnglish(result, ColorName.redEb5);

          var findIndexCurrentText = -1;

          for (var i = 0; i < resultGame.length; i++) {
            if (resultGame[i].text == '') {
              findIndexCurrentText = i;
              break;
            }
          }

          if (findIndexCurrentText == -1) {
            commonTextToSpeech.speech(
              text,
              completed: () {
                if (heald > 0) {
                  gamePlay();
                }
              },
            );
          } else {
            AppConfig.currentCharacter.value = text.substring(findIndexCurrentText, findIndexCurrentText + 1);
          }
        },
        text: char,
      ));
    }
  }

  TextPaint textPaint = TextPaint(
    style: const TextStyle(
      fontSize: 25.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'Awesome Font',
    ),
  );

  String text = '';
  String vietnameseText = '';
  List<GameDispalyEnglish> resultGame = [];

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(canvas, vietnameseText, Vector2(10, 10));
    for (var i = 0; i < resultGame.length; i++) {
      TextPaint(
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w900,
          fontFamily: 'Awesome Font',
          color: resultGame[i].color,
        ),
      ).render(canvas, resultGame[i].text, Vector2(10 + i * 25, 50));
    }
  }

  @override
  Future<void> onLoad() async {
    AppConfig.currentCharacter.value = '';
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
}

class Square extends TextComponent with TapCallbacks {
  Function(String) callbackComplete;
  Function(String) callbackError;
  String text;
  double width;
  double height;
  Vector2 objectPosition;
  double scaleSpeed = 1;
  int index = 0;

  static const speed = 2;
  double moveSpped = 1.6;
  static const squareSize = 300.0;

  bool isDouble;

  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  Square({
    required this.objectPosition,
    required this.callbackComplete,
    required this.isDouble,
    required this.callbackError,
    required this.text,
    required this.height,
    required this.width,
  }) : super(
          text: text,
          position: objectPosition,
          size: Vector2.all(squareSize),
          anchor: Anchor.center,
          textRenderer: TextPaint(style: AppTextStyle.w800s35(isDouble ? ColorName.yellowFff : ColorName.whiteFff)),
        );

  double xPosition = 0;
  double yPosition = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (isDouble) {
      moveSpped = 1;
    }
    var maxX = (objectPosition.x - width).abs();
    var maxY = (objectPosition.y - height).abs();

    xPosition = width > position.x
        ? position.x + calculateX(maxX, maxY, moveSpped)
        : position.x - calculateX(maxX, maxY, moveSpped);
    yPosition = height > position.y
        ? position.y + calculateY(maxX, maxY, moveSpped)
        : position.y - calculateY(maxX, maxY, moveSpped);

    position = Vector2(xPosition, yPosition);
    angle += speed * dt;
    angle %= 2 * math.pi;

    if (width >= position.x - 25 &&
        width <= position.x + 25 &&
        height >= position.y - 25 &&
        height <= position.y + 25) {
      removeFromParent();
      callbackError(text);
    }
  }

  double calculateX(double maxX, double maxY, double speed) {
    if (maxX > maxY) {
      return 1 / speed;
    }
    return (1 * maxX / (maxY / 1)) / speed;
  }

  double calculateY(double maxX, double maxY, double speed) {
    if (maxY > maxX) {
      return 1 / speed;
    }
    return (1 * maxY / (maxX / 1)) / speed;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (AppConfig.currentCharacter.value == text) {
      removeFromParent();
      event.handled = true;
      callbackComplete(text);
    }
  }
}
