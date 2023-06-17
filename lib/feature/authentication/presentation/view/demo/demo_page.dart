import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/presentation/view/course/widgets/widget.dart';
import 'package:easy_english/feature/course/presentation/view/course_detail/widgets/widget.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/widgets/widget.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../base/presentation/base_app_bar.dart';
import '../../controller/demo/demo_controller.dart';

class DemoPage extends GetWidget<DemoController> {
  const DemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: BaseAppBar(
          title: const Text('Demo Page'),
          centerTitle: true,
          leading: null,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // CommonTextField(
                    //   formKey: controller.formKey,
                    //   type: FormFieldType.memo,
                    //   controller: controller.memoTextEditingController,
                    //   onTap: null,
                    //   onChanged: (_) {},
                    // ),
                    // CommonTextField(
                    //   formKey: controller.formKey,
                    //   type: FormFieldType.phone,
                    //   controller: controller.phomeTextEditingController,
                    //   onTap: null,
                    //   onChanged: (_) {},
                    // ),
                    // CommonTextField(
                    //   formKey: controller.formKey,
                    //   type: FormFieldType.password,
                    //   controller: controller.passwordTextEditingController,
                    //   textInputAction: TextInputAction.done,
                    //   obscureText: true,
                    //   onTap: null,
                    //   onChanged: (_) {},
                    //   onSubmitted: (_) {},
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.listTextEditingController.length,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                controller.title[index],
                                textAlign: TextAlign.center,
                                style: AppTextStyle.w500s15(ColorName.black222),
                              ),
                            ),
                            Expanded(
                              child: CommonTextField(
                                formKey: controller.formKey,
                                type: FormFieldType.emailOrPhone,
                                controller: controller.listTextEditingController[index],
                                onTap: null,
                                onChanged: (_) {},
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 100,
              //   width: Get.width,
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CupertinoButton(
              //         onPressed: controller.onTap,
              //         child: const Text('API'),
              //       ),
              //       Obx(() => Text(controller.textApi.value)),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 100,
              //   width: Get.width,
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CupertinoButton(
              //         onPressed: controller.onTapTextToSpeech,
              //         child: const Text('Text To Speech'),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 100,
              //   width: Get.width,
              //   child: Column(
              //     mainAxisSize: MainAxisSize.min,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CupertinoButton(
              //         onPressed: controller.onTapSpeechToText,
              //         child: const Text('Speech To Text'),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 100,
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: controller.onCreateCourse,
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: controller.onGetListCourse,
                      child: const Text('Show'),
                    ),
                  ],
                ),
              ),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.courses.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        if (controller.courses[index].id != null) {
                          controller.onGetListCourseLevel(controller.courses[index].id ?? 0);
                        }
                      },
                      onLongPress: () {
                        if (controller.courses[index].id != null) {
                          controller.onGetListVocabularyWithCourse(controller.courses[index].id ?? 0);
                        }
                      },
                      child: CourseItem(
                        course: Course(
                          controller.courses[index].id ?? 0,
                          controller.courses[index].publicId ?? 0,
                          controller.courses[index].title ?? '',
                          '',
                          controller.courses[index].image ?? '',
                          controller.courses[index].totalWords ?? 0,
                          controller.courses[index].learnedWords ?? 0,
                          controller.courses[index].member ?? 0,
                          controller.courses[index].progress ?? 0,
                          0,
                        ),
                        typeCourse: TypeCourse.downloadCourse,
                        onPressed: () {
                          if (controller.courses[index].id != null) {
                            controller.onCreateCourseLevel(controller.courses[index].id ?? 0);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.courseLevels.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        if (controller.courseLevels[index].id != null) {
                          controller.onGetListVocabularyWithLevel(controller.courseLevels[index].id ?? 0);
                        }
                      },
                      child: CourseLevelItem(
                        courseLevel: CourseLevel(
                          controller.courseLevels[index].id ?? 0,
                          controller.courseLevels[index].level ?? 0,
                          controller.courseLevels[index].title ?? '',
                          controller.courseLevels[index].courseId ?? 0,
                          controller.courseLevels[index].totalWords ?? 0,
                          controller.courseLevels[index].learnedWords ?? 0,
                        ),
                        onPressed: () {
                          if (controller.courseLevels[index].id != null) {
                            controller.onCreateVocabulary(
                                controller.currentCourseId, controller.courseLevels[index].id ?? 0);
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),

              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.vocabularies.length,
                  itemBuilder: (context, index) {
                    return CourseVocabularyItem(
                      vocabulary: Vocabulary(
                        controller.vocabularies[index].id ?? 0,
                        controller.vocabularies[index].englishText ?? '',
                        controller.vocabularies[index].vietnameseText ?? '',
                        controller.vocabularies[index].image ?? '',
                        controller.vocabularies[index].progress ?? 0,
                        0,
                        0,
                        0,
                        controller.vocabularies[index].wordType ?? 'NONE',
                        controller.vocabularies[index].lastTimeLearning ?? '0',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
