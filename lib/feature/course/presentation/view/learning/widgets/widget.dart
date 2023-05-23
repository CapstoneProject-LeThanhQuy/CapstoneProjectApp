import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:get/get.dart';

part 'widget.g.dart';

@swidget
Widget newWordItem({
  void Function()? onPressedNext,
  void Function()? onPressedPlaySound,
  required Vocabulary vocabulary,
}) {
  return Container(
    color: ColorName.whiteFff,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (onPressedPlaySound != null) {
                            onPressedPlaySound.call();
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.speaker_3_fill,
                          color: ColorName.primaryColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  vocabulary.englishText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w600s30(ColorName.primaryColor),
                ),
                const SizedBox(height: 25),
                vocabulary.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: vocabulary.image,
                        fit: BoxFit.cover,
                        maxHeightDiskCache: 300,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                      )
                    : Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                const SizedBox(height: 55),
                const Divider(
                  height: 1,
                  color: ColorName.primaryColor,
                  thickness: 1,
                ),
                const SizedBox(height: 25),
                Text(
                  'NGHĨA',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w500s12(ColorName.gray838),
                ),
                const SizedBox(height: 5),
                Text(
                  vocabulary.vietnameseText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w700s20(ColorName.gray4f4),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorName.whiteFff,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          value: vocabulary.progress / AppConfig.currentCourse.progress,
                          color: ColorName.primaryColor.withOpacity(0.8),
                          backgroundColor: ColorName.primaryColor.withOpacity(0.2),
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.book_solid,
                            color: ColorName.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(left: 8, right: 8),
          color: Colors.transparent,
          child: CommonButton(
            height: 50,
            onPressed: () {
              if (onPressedNext != null) {
                onPressedNext.call();
              }
            },
            fillColor: ColorName.primaryColor,
            child: Text(
              'Đã nhớ',
              style: AppTextStyle.w700s18(ColorName.whiteFff),
            ),
          ),
        ),
      ],
    ),
  );
}

@swidget
Widget learningWordItem({
  required Function(bool) onPressedAnswer,
  required Vocabulary vocabulary,
  required List<Vocabulary> anotherAnswers,
  required bool chooseVietnamese,
}) {
  RxInt chooseIndex = 100.obs;
  double widthScreen = MediaQuery.of(Get.context!).size.width;
  int randomIndex = Random().nextInt(3);
  anotherAnswers.insert(randomIndex, vocabulary);
  return Container(
    color: ColorName.whiteFff,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: SingleChildScrollView(
      child: Column(
        children: [
          vocabulary.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: vocabulary.image,
                  fit: BoxFit.cover,
                  maxHeightDiskCache: 200,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                )
              : Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
          const SizedBox(height: 15),
          const Divider(
            height: 1,
            color: ColorName.primaryColor,
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Text(
            chooseVietnamese ? vocabulary.englishText : vocabulary.vietnameseText,
            textAlign: TextAlign.center,
            style: AppTextStyle.w700s20(ColorName.gray4f4),
          ),
          const SizedBox(height: 20),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ColorName.whiteFff,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    value: vocabulary.progress / AppConfig.currentCourse.progress,
                    color: ColorName.primaryColor.withOpacity(0.8),
                    backgroundColor: ColorName.primaryColor.withOpacity(0.2),
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.book_solid,
                      color: ColorName.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),
          Obx(
            () => GridView.count(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(
                4,
                (index) {
                  return Center(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: chooseIndex.value == 100
                          ? () {
                              if (index == randomIndex) {
                                onPressedAnswer(true);
                                chooseIndex.value = index;
                              } else {
                                onPressedAnswer(false);
                                chooseIndex.value = index;
                              }
                            }
                          : null,
                      child: Container(
                        height: widthScreen / 2 - 30,
                        width: widthScreen / 2 - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: chooseIndex.value != index
                              ? ColorName.whiteFff
                              : chooseIndex.value == randomIndex
                                  ? ColorName.green5fc
                                  : ColorName.redE58,
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.black333.withOpacity(0.5),
                              blurRadius: 15.0,
                              offset: const Offset(3, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            chooseVietnamese ? anotherAnswers[index].vietnameseText : anotherAnswers[index].englishText,
                            style: chooseIndex.value != 100 && chooseIndex.value == index
                                ? AppTextStyle.w700s16(ColorName.whiteFaf)
                                : AppTextStyle.w600s15(ColorName.black000),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

@swidget
Widget difficultWordItem({
  void Function()? onPressedNext,
  void Function()? onPressedPlaySound,
  required Vocabulary vocabulary,
}) {
  return Container(
    color: ColorName.whiteFff,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (onPressedPlaySound != null) {
                            onPressedPlaySound.call();
                          }
                        },
                        child: const Icon(
                          CupertinoIcons.speaker_3_fill,
                          color: ColorName.primaryColor,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  vocabulary.englishText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w600s30(ColorName.primaryColor),
                ),
                const SizedBox(height: 25),
                vocabulary.image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: vocabulary.image,
                        fit: BoxFit.cover,
                        maxHeightDiskCache: 300,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                      )
                    : Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorName.blue007.withOpacity(0.5),
                  ),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (onPressedPlaySound != null) {
                        onPressedPlaySound.call();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.bookmark_fill,
                          color: ColorName.black000,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Đã thêm vào phần từ khó',
                          style: AppTextStyle.w600s13(ColorName.black000),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(
                  height: 1,
                  color: ColorName.primaryColor,
                  thickness: 1,
                ),
                const SizedBox(height: 25),
                Text(
                  'NGHĨA',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w500s12(ColorName.gray838),
                ),
                const SizedBox(height: 5),
                Text(
                  vocabulary.vietnameseText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w700s20(ColorName.gray4f4),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorName.whiteFff,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          value: vocabulary.progress / AppConfig.currentCourse.progress,
                          color: ColorName.primaryColor.withOpacity(0.8),
                          backgroundColor: ColorName.primaryColor.withOpacity(0.2),
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.book_solid,
                            color: ColorName.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.only(left: 8, right: 8),
          color: Colors.transparent,
          child: CommonButton(
            height: 50,
            onPressed: () {
              if (onPressedNext != null) {
                onPressedNext.call();
              }
            },
            fillColor: ColorName.primaryColor,
            child: Text(
              'Đã nhớ',
              style: AppTextStyle.w700s18(ColorName.whiteFff),
            ),
          ),
        ),
      ],
    ),
  );
}
