import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/game/presentation/controller/game/game_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class GamePage extends BaseWidget<GameController> {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
          'GamePage',
          style: AppTextStyle.w800s33(ColorName.primaryColor),
        )),
      ),
    );
  }
}
