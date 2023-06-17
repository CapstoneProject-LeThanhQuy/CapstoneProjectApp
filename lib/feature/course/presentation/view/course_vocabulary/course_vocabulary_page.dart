import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/course_vocabulary/course_vocabulary_controller.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class CourseVocabularyPage extends BaseWidget<CourseVocabularyController> {
  CourseVocabularyPage({Key? key}) : super(key: key);
  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorName.grayEce,
          appBar: BaseAppBar(),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        color: ColorName.green459.withOpacity(0.2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 25),
                            Center(
                              child: Text(
                                '${controller.courseLevel?.level}',
                                style: AppTextStyle.w700s20(ColorName.black000),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: 70,
                                color: ColorName.whiteFaf,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.courseLevel?.title ?? '',
                                      style: AppTextStyle.w700s17(ColorName.primaryColor),
                                    ),
                                    Text(
                                      '${controller.courseLevel?.learnedWords}/${controller.courseLevel?.totalWords} từ',
                                      style: AppTextStyle.w500s15(ColorName.black4d4),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: controller.vocabularies.length,
                          itemBuilder: (context, index) {
                            return CourseVocabularyItem(
                              vocabulary: controller.vocabularies[index],
                              onPressed: () {
                                N.toVocabularyDetail(vocabulary: controller.vocabularies[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      color: Colors.transparent,
                      child: CommonButton(
                        height: 50,
                        onPressed: controller.learnNewWord,
                        fillColor: controller.vocabularies.isEmpty ? ColorName.gray828 : ColorName.primaryColor,
                        child: Text(
                          controller.isHasNewWord.value ? 'Học từ mới' : 'Ôn tập',
                          style: AppTextStyle.w700s18(ColorName.whiteFff),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    color: Colors.transparent,
                    child: CommonButton(
                      height: 50,
                      width: 50,
                      onPressed: () {},
                      fillColor: ColorName.primaryColor,
                      child: Center(
                        child: Assets.images.menuIcon.image(height: 16, width: 16, color: ColorName.whiteFff),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
