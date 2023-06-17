import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/controller/learning/learning_controller.dart';
import 'package:easy_english/feature/course/presentation/controller/learning_difficult/learning_difficult_controller.dart';
import 'package:easy_english/feature/course/presentation/view/learning/widgets/widget.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class LearningDifficultPage extends BaseWidget<LearningDifficultController> {
  const LearningDifficultPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return IgnorePointer(
          ignoring: controller.isCompleted.value,
          child: Scaffold(
            appBar: BaseAppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  backgroundColor: ColorName.orangeF29.withOpacity(0.4),
                  valueColor: const AlwaysStoppedAnimation<Color>(ColorName.orangeF29),
                  value: (controller.currentIndex.value) / 6,
                ),
              ),
            ),
            body: controller.allVocabularies.isNotEmpty && !controller.isCompleted.value
                ? controller.isReview.value
                    ? ReviewWordItem(
                        onComplete: () {
                          controller.speechText(
                            completed: () {
                              controller.learnWord();
                            },
                          );
                        },
                        vocabulary: controller.vocabulary!,
                        listKeyReview: controller.listKeyReview,
                      )
                    : controller.currentType.value == TypeLearning.learningWord
                        ? LearningWordItem(
                            onPressedAnswer: (isConrrect) {
                              controller.speechText(
                                completed: () {
                                  if (isConrrect) {
                                    controller.learnWord();
                                  } else {
                                    controller.refreshWord();
                                  }
                                },
                              );
                            },
                            vocabulary: controller.vocabulary!,
                            anotherAnswers: controller.anotherAnswers,
                            chooseVietnamese: controller.chooseVietnamese,
                          )
                        : NewWordItem(
                            onPressedNext: () {
                              controller.learnWord();
                            },
                            onPressedPlaySound: () {
                              controller.speechText();
                            },
                            vocabulary: controller.vocabulary!,
                          )
                : Container(
                    color: ColorName.whiteFff,
                    child: const LoadingWidget(
                      color: ColorName.primaryColor,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
