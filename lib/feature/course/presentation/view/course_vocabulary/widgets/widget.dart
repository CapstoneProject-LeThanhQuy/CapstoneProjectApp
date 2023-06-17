import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';

part 'widget.g.dart';

@swidget
Widget courseVocabularyItem({void Function()? onPressed, required Vocabulary vocabulary}) {
  return Container(
    color: ColorName.whiteFff,
    height: 80,
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
    margin: const EdgeInsets.symmetric(vertical: 3),
    child: CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onPressed != null) {
          onPressed.call();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vocabulary.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: vocabulary.image,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Assets.images.logoIcon.image(width: 80, height: 80, fit: BoxFit.cover),
                )
              : Assets.images.logoIcon.image(width: 80, height: 80, fit: BoxFit.cover),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vocabulary.englishText,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.w700s18(ColorName.primaryColor),
                  ),
                  Text(
                    vocabulary.vietnameseText,
                    textAlign: TextAlign.left,
                    style: AppTextStyle.w700s18(ColorName.gray838),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    minHeight: 8,
                    value: AppConfig.currentCourse.progress == 0
                        ? 0
                        : vocabulary.progress / AppConfig.currentCourse.progress,
                    color: ColorName.primaryColor,
                    backgroundColor: ColorName.green459.withOpacity(0.2),
                    semanticsLabel: 'Linear progress indicator',
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
