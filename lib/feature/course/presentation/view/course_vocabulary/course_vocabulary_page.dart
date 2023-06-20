import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/course_vocabulary/course_vocabulary_controller.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
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
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          builder: (context) => _moreLearning(context),
                        );
                      },
                      fillColor: ColorName.primaryColor,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.circle_grid_hex_fill,
                          color: ColorName.whiteFff,
                          size: 30,
                        ),
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

  Widget _moreLearning(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorName.primaryColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 5),
            child: Text(
              'Học',
              style: AppTextStyle.w800s20(ColorName.whiteFff),
            ),
          ),
          Row(
            children: [
              learningItem(
                onPressed: () {
                  if (controller.isHasNewWord.value) {
                    Get.back();
                    controller.learnNewWord();
                  }
                },
                isDisabled: !controller.isHasNewWord.value,
                icon: CupertinoIcons.drop_fill,
                title: 'Học từ mới',
                badge: 0,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 5, left: 16),
            child: Text(
              'Ôn tập',
              style: AppTextStyle.w800s20(ColorName.whiteFff),
            ),
          ),
          Row(
            children: [
              learningItem(
                onPressed: () {
                  if (controller.difficltWords.value > 0) {
                    Get.back();
                    controller.learnDifficultWord();
                  }
                },
                icon: CupertinoIcons.bolt_fill,
                isDisabled: controller.difficltWords.value == 0,
                title: 'Từ khó',
                badge: controller.difficltWords.value,
              ),
              learningItem(
                onPressed: () {
                  Get.back();
                  controller.reviewLearnedWord();
                },
                icon: CupertinoIcons.book_solid,
                title: 'Ôn tập',
                badge: controller.reviewWords.value,
              ),
              learningItem(
                onPressed: () {
                  Get.back();
                  controller.speakLearnedWord();
                },
                icon: CupertinoIcons.volume_down,
                title: 'Luyện phát âm',
                badge: controller.reviewWords.value,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget learningItem({
    Function()? onPressed,
    bool isDisabled = false,
    required IconData icon,
    required String title,
    required int badge,
  }) {
    return SizedBox(
      width: 110,
      child: Stack(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (onPressed != null) {
                onPressed.call();
              }
            },
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: isDisabled ? ColorName.blue005.withOpacity(0.6) : ColorName.blue80b.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(70),
                      boxShadow: [
                        BoxShadow(
                          color: ColorName.blue005.withOpacity(0.5),
                          spreadRadius: 0.5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: ColorName.primaryColor,
                      size: 35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: AppTextStyle.w500s15(isDisabled ? ColorName.grayBdb : ColorName.whiteFff),
                  ),
                ],
              ),
            ),
          ),
          if (badge > 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: ColorName.primaryColor),
                  color: ColorName.whiteFff,
                ),
                child: Text(
                  '$badge',
                  style: AppTextStyle.w700s16(ColorName.primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
