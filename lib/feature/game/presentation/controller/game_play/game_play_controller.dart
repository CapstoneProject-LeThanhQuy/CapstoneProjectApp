import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:get/get.dart';

class GamePlayController extends BaseController<List<Vocabulary>> {
  List<Vocabulary> vocabularies = [];

  StorageService _storageService;

  GamePlayController(this._storageService);

  RxInt point = 0.obs;
  RxInt heald = 10.obs;

  @override
  void onInit() async {
    super.onInit();
    vocabularies = input;
  }

  void gameOver() async {
    int bestScore = await _storageService.getMyBestScore();
    bestScore = bestScore > point.value ? bestScore : point.value;
    AppConfig.currenPoint.value = point.value;
    AppConfig.bestScore.value = bestScore;
    _storageService.setMyBestScore(bestScore);
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.infoReverse,
      title: 'GAME OVER',
      desc: 'Điểm của bạn: ${point.value}\n Điểm cao: $bestScore',
      descTextStyle: AppTextStyle.w600s17(ColorName.black000),
      btnOkText: 'OK',
      btnOkOnPress: () {},
      onDismissCallback: (_) {
        Get.back();
      },
    ).show();
  }
}
