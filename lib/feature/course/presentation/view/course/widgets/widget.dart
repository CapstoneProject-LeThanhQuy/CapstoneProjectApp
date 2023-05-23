import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:cached_network_image/cached_network_image.dart';

part 'widget.g.dart';

enum TypeCourse {
  myCourse,
  downloadCourse,
  followCourse,
}

@swidget
Widget courseItem({void Function()? onPressed, required Course course, required TypeCourse typeCourse}) {
  return Container(
    color: ColorName.whiteFff,
    height: 80,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
    margin: const EdgeInsets.symmetric(vertical: 2),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: course.image.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: course.image,
                    height: 75,
                    width: 75,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Center(
                      child: Assets.images.logoIcon.image(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Center(
                    child: Assets.images.logoIcon.image(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.w500s15(ColorName.primaryColor),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {},
                      child: Assets.images.menuDotsIcon.image(width: 20),
                    ),
                    const SizedBox(width: 2),
                  ],
                ),
                const SizedBox(height: 5),
                if (typeCourse == TypeCourse.myCourse)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        CupertinoIcons.person_3_fill,
                        color: ColorName.green4c8,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${course.member}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.w500s14(ColorName.green4c8),
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                if (typeCourse == TypeCourse.downloadCourse)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        CupertinoIcons.book_solid,
                        color: ColorName.green4c8,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${course.learnedWords}/${course.totalWords}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.w500s14(ColorName.green4c8),
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                if (typeCourse == TypeCourse.followCourse)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        CupertinoIcons.book_solid,
                        color: ColorName.green4c8,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${course.totalWords}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.w500s14(ColorName.green4c8),
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 2),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: course.learnedWords == 0 ? 0 : course.learnedWords / course.totalWords,
                    color: ColorName.primaryColor,
                    backgroundColor: ColorName.green459.withOpacity(0.2),
                    semanticsLabel: 'Linear progress indicator',
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
