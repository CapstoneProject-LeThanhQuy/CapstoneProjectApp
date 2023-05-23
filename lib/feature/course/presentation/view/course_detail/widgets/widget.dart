import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'widget.g.dart';

@swidget
Widget courseLevelItem({void Function()? onPressed, required CourseLevel courseLevel, bool isShowDots = true}) {
  double height = 80;
  double width = 80;
  return Column(
    children: [
      const SizedBox(height: 25),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: ColorName.grayC7c,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SizedBox(
                height: height,
                width: width,
                child: Center(
                  child: Text(
                    '${courseLevel.learnedWords}/${courseLevel.totalWords}',
                    style: AppTextStyle.w700s11(ColorName.primaryColor),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (onPressed != null) {
                    onPressed.call();
                  }
                },
                child: SizedBox(
                  height: height,
                  width: width,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: courseLevel.learnedWords == 0 ? 0 : courseLevel.learnedWords / courseLevel.totalWords,
                    color: ColorName.primaryColor,
                    backgroundColor: ColorName.greenD5e,
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(
        courseLevel.title,
        style: AppTextStyle.w700s22(ColorName.black222),
      ),
      const SizedBox(height: 35),
      if (isShowDots) Assets.images.dotsVerticalIcon.image(height: 20),
      const SizedBox(height: 10),
    ],
  );
}
