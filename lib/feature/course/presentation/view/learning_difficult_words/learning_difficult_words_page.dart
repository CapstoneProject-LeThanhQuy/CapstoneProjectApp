import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/learning_difficult_words/learning_difficult_words_controller.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';

class LearningDifficultWordsPage extends BaseWidget<LearningDifficultWordsController> {
  const LearningDifficultWordsPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorName.grayEce,
          appBar: BaseAppBar(
            title: Text('Từ khó [${controller.vocabularies.length}]'),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemCount: controller.vocabularies.length,
            itemBuilder: (context, index) {
              return CourseVocabularyItem(
                vocabulary: controller.vocabularies[index],
                onPressed: () {
                  controller.toLearnWord(index);
                },
              );
            },
          ),
        );
      },
    );
  }
}
