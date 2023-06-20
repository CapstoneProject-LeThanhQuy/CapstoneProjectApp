import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: vocabulary.image,
                          fit: BoxFit.fitHeight,
                          maxHeightDiskCache: 300,
                          placeholder: (context, url) => const SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                        ),
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
                Text(
                  '[${vocabulary.wordType}]',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w700s20(ColorName.green27b),
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
              ? Container(
                  constraints: const BoxConstraints(maxHeight: 350),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: vocabulary.image,
                    fit: BoxFit.fitHeight,
                    maxHeightDiskCache: 200,
                    placeholder: (context, url) => const SizedBox(
                      height: 120,
                      width: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                  ),
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
          Text(
            '[${vocabulary.wordType}]',
            textAlign: TextAlign.center,
            style: AppTextStyle.w700s20(ColorName.green27b),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              if (vocabulary.difficult > 0) const SizedBox(width: 25),
              if (vocabulary.difficult > 0)
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
                          value: (5 - vocabulary.difficult) / 5,
                          color: ColorName.purpleDf8.withOpacity(0.8),
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
                            CupertinoIcons.bolt_circle_fill,
                            color: ColorName.purpleDf8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: vocabulary.image,
                          fit: BoxFit.fitHeight,
                          maxHeightDiskCache: 300,
                          placeholder: (context, url) => const SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                        ),
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
                Text(
                  '[${vocabulary.wordType}]',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w700s20(ColorName.green27b),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    const SizedBox(width: 25),
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
                              value: (5 - vocabulary.difficult) / 5,
                              color: ColorName.purpleDf8.withOpacity(0.8),
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
                                CupertinoIcons.bolt_circle_fill,
                                color: ColorName.purpleDf8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
Widget reviewWordItem({
  required Function() onComplete,
  required Vocabulary vocabulary,
  required List<String> listKeyReview,
}) {
  RxBool isComplete = false.obs;
  TextEditingController textEditingController = TextEditingController();
  while (true) {
    if (listKeyReview.length >= 14) {
      break;
    }
    listKeyReview.add('');
  }
  listKeyReview.shuffle();

  return Container(
    color: ColorName.whiteFff,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: SingleChildScrollView(
      child: Column(
        children: [
          vocabulary.image.isNotEmpty
              ? Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: vocabulary.image,
                    fit: BoxFit.fitHeight,
                    maxHeightDiskCache: 200,
                    placeholder: (context, url) => const SizedBox(
                      height: 120,
                      width: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                  ),
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
            vocabulary.vietnameseText,
            textAlign: TextAlign.center,
            style: AppTextStyle.w700s20(ColorName.gray4f4),
          ),
          Text(
            '[${vocabulary.wordType}]',
            textAlign: TextAlign.center,
            style: AppTextStyle.w700s20(ColorName.green27b),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              if (vocabulary.difficult > 0) const SizedBox(width: 25),
              if (vocabulary.difficult > 0)
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
                          value: (5 - vocabulary.difficult) / 5,
                          color: ColorName.purpleDf8.withOpacity(0.8),
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
                            CupertinoIcons.bolt_circle_fill,
                            color: ColorName.purpleDf8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 35),
          Obx(
            () => CommonTextField(
              height: 55,
              isEnable: false,
              controller: textEditingController,
              type: FormFieldType.reviewWord,
              fillColor: isComplete.value ? ColorName.green27b.withOpacity(0.6) : ColorName.gray828.withOpacity(0.3),
              textStyle: AppTextStyle.w600s16(ColorName.black000),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (!isComplete.value) {
                    String text = textEditingController.text;
                    if (text.isEmpty) {
                      textEditingController.text = vocabulary.englishText.split('').first;
                    } else {
                      List<String> words = text.split('');
                      words.add('#');
                      List<String> englishText = vocabulary.englishText.split('');
                      String result = '';
                      for (var i = 0; i < words.length; i++) {
                        result += englishText[i];
                        if (words[i] != englishText[i]) {
                          break;
                        }
                      }
                      textEditingController.text = result;
                    }
                    if (textEditingController.text == vocabulary.englishText) {
                      onComplete();
                      isComplete.value = true;
                    }
                  }
                },
                child: const Icon(
                  CupertinoIcons.pencil_ellipsis_rectangle,
                  color: ColorName.primaryColor,
                  size: 30,
                ),
              ),
              const Spacer(),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (!isComplete.value) {
                    String text = textEditingController.text;
                    if (text.isNotEmpty) {
                      textEditingController.text = text.substring(0, text.length - 1);
                    }
                  }
                },
                child: const Icon(
                  CupertinoIcons.delete_left,
                  color: ColorName.primaryColor,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
          GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: (listKeyReview.length + 1) ~/ 2,
            children: listKeyReview.map(
              (String value) {
                return value.isEmpty
                    ? const SizedBox.shrink()
                    : Container(
                        decoration: BoxDecoration(
                          color: ColorName.whiteFaf,
                          border: Border.all(width: 2, color: ColorName.primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (!isComplete.value) {
                              textEditingController.text = textEditingController.text + value;
                              if (textEditingController.text == vocabulary.englishText) {
                                onComplete();
                                isComplete.value = true;
                              }
                            }
                          },
                          child: Text(
                            value == ' ' ? '_' : value,
                            style: AppTextStyle.w800s20(ColorName.black000),
                          ),
                        ),
                      );
              },
            ).toList(),
          ),
        ],
      ),
    ),
  );
}

@swidget
Widget speakingWordItem({
  void Function()? onPressedListening,
  void Function()? onPressedPlaySound,
  required Vocabulary vocabulary,
  required bool isSpeaking,
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
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          imageUrl: vocabulary.image,
                          fit: BoxFit.fitHeight,
                          maxHeightDiskCache: 300,
                          placeholder: (context, url) => const SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Assets.images.logoIcon.image(width: 120, height: 120, fit: BoxFit.cover),
                        ),
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
                Text(
                  '[${vocabulary.wordType}]',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.w700s20(ColorName.green27b),
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
                      if (vocabulary.difficult > 0) const SizedBox(width: 25),
                      if (vocabulary.difficult > 0)
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
                                  value: (5 - vocabulary.difficult) / 5,
                                  color: ColorName.purpleDf8.withOpacity(0.8),
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
                                    CupertinoIcons.bolt_circle_fill,
                                    color: ColorName.purpleDf8,
                                  ),
                                ),
                              ),
                            ],
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
          child: AvatarGlow(
            animate: isSpeaking,
            endRadius: 60,
            glowColor: ColorName.primaryColor,
            child: CupertinoButton(
              onPressed: () {
                if (!isSpeaking) {
                  if (onPressedListening != null) {
                    onPressedListening.call();
                  }
                }
              },
              child: const Icon(
                CupertinoIcons.mic_solid,
                color: ColorName.primaryColor,
                size: 50,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
