import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/controller/learning/learning_controller.dart';
import 'package:easy_english/feature/course/presentation/view/learning/widgets/widget.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class LearningPage extends BaseWidget<LearningController> {
  const LearningPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: BaseAppBar(
            actions: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Điểm tích lũy: ${controller.point.value}',
                    style: AppTextStyle.w600s13(ColorName.whiteFaf),
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: ColorName.orangeF29.withOpacity(0.4),
                valueColor: const AlwaysStoppedAnimation<Color>(ColorName.orangeF29),
                value: (controller.currentIndex.value + 1) / (controller.maxIndex + 1),
              ),
            ),
          ),
          body: controller.vocabularies.isNotEmpty
              ? controller.currentType.value == TypeLearning.newWord
                  ? NewWordItem(
                      onPressedNext: () {
                        controller.nextWord();
                      },
                      onPressedPlaySound: () {
                        controller.speechText();
                      },
                      vocabulary: controller.vocabularies[controller.listIndexRandom[controller.currentIndex.value]],
                    )
                  : controller.currentType.value == TypeLearning.learningWord
                      ? LearningWordItem(
                          onPressedAnswer: (isConrrect) {
                            controller.speechText(
                              completed: () {
                                if (isConrrect) {
                                  controller.nextWord();
                                } else {
                                  controller.learningWord(isDifficultWord: true);
                                }
                              },
                            );
                          },
                          vocabulary:
                              controller.vocabularies[controller.listIndexRandom[controller.currentIndex.value]],
                          anotherAnswers: controller.anotherAnswers,
                          chooseVietnamese: controller.chooseVietnamese,
                        )
                      : DifficultWordItem(
                          onPressedNext: () {
                            controller.nextWord();
                          },
                          onPressedPlaySound: () {
                            controller.speechText();
                          },
                          vocabulary:
                              controller.vocabularies[controller.listIndexRandom[controller.currentIndex.value]],
                        )
              : Container(
                  color: ColorName.black000.withOpacity(0.6),
                  child: const LoadingWidget(
                    color: ColorName.whiteFff,
                  ),
                ),
        );
      },
    );
  }
}
