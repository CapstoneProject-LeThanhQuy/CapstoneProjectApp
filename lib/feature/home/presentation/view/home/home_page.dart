import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/feature/home/presentation/view/home/widgets/widget.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/extension/form_builder.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends BaseWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return GestureDetector(
          onTap: () {
            controller.hideKeyboard();
            controller.isSearching.value = false;
          },
          child: Scaffold(
            appBar: BaseAppBar(
              leadingWidth: controller.isSearching.value ? 0 : 300,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.curentCourse.value.title,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.w600s17(ColorName.whiteFff),
                    ),
                  ],
                ),
              ),
              title: AnimatedSize(
                alignment: Alignment.centerLeft,
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                reverseDuration: const Duration(milliseconds: 400),
                child: controller.isSearching.value ? _searchWidget() : const SizedBox.shrink(),
              ),
              actions: [
                controller.isSearching.value
                    ? const SizedBox.shrink()
                    : CupertinoButton(
                        onPressed: () {
                          controller.isSearching.value = true;
                        },
                        child: const Icon(
                          CupertinoIcons.search,
                          color: ColorName.whiteFff,
                        ),
                      )
              ],
            ),
            backgroundColor: ColorName.grayF2f,
            body: SmartRefresher(
              scrollController: controller.scrollController,
              enablePullDown: true,
              controller: controller.refreshController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              header: const WaterDropMaterialHeader(
                backgroundColor: ColorName.primaryColor,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Việc cần làm hôm nay',
                          style: AppTextStyle.w600s17(ColorName.black000),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TargetItem(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              builder: (context) => _setTarget(context),
                            );
                          },
                          target: controller.target.value,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Từ vựng cần ôn tập',
                          style: AppTextStyle.w600s17(ColorName.black000),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            learningItem(
                              onPressed: () {
                                controller.learnDifficultWord();
                              },
                              icon: CupertinoIcons.bolt_fill,
                              title: 'Từ khó',
                              badge: controller.difficltWords.value,
                            ),
                            learningItem(
                              onPressed: () {
                                controller.reviewLearnedWord();
                              },
                              icon: CupertinoIcons.book_solid,
                              title: 'Ôn tập',
                              badge: controller.reviewWords.value,
                            ),
                            learningItem(
                              onPressed: () {
                                controller.speakLearnedWord();
                              },
                              icon: CupertinoIcons.volume_down,
                              title: 'Luyện phát âm',
                              badge: controller.reviewWords.value,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Khám phá',
                          style: AppTextStyle.w600s17(ColorName.black000),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (controller.listCourse.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.listCourse.length,
                          itemBuilder: (context, index) {
                            return homeCourseItem(
                              onPressed: () {
                                controller.toCourseDetail(index);
                              },
                              course: controller.listCourse[index],
                            );
                          },
                        ),
                      if (controller.listCourse.isEmpty && !controller.isLoading.value)
                        Column(
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Không có khóa học nào cho bạn',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.w600s15(ColorName.black000),
                                ),
                              ],
                            ),
                          ],
                        ),
                      if (controller.isLoading.value)
                        Shimmer.fromColors(
                          baseColor: ColorName.grayE0e,
                          highlightColor: ColorName.grayD2d,
                          child: Column(
                            children: [
                              homeCourseItem(
                                onPressed: () {},
                                course: CourseModel(),
                              ),
                              homeCourseItem(
                                onPressed: () {},
                                course: CourseModel(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget learningItem({
    Function()? onPressed,
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
                      color: ColorName.blue80b.withOpacity(0.9),
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
                    style: AppTextStyle.w500s16(ColorName.primaryColor),
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

  Widget homeCourseItem({required CourseModel course, Function()? onPressed}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
      color: ColorName.whiteFff,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (onPressed != null) {
            onPressed.call();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: (course.image ?? '').isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: course.image ?? '',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Center(
                        child: Assets.images.logoIcon.image(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 120,
                      width: 120,
                      child: Center(
                        child: Assets.images.logoIcon.image(
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(course.rating ?? 0).toInt()}/5',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.w500s12(ColorName.green459),
                      ),
                      const Icon(
                        Icons.star_border_purple500,
                        color: ColorName.green459,
                        size: 15,
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      course.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.w700s18(ColorName.black000),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      course.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.w500s15(ColorName.gray828),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        CupertinoIcons.person_2_alt,
                        color: ColorName.blue005,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${course.member}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.w600s17(ColorName.blue005),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        CupertinoIcons.book_solid,
                        color: ColorName.orangeDdb,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${course.totalWords}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.w600s17(ColorName.orangeDdb),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setTarget(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorName.whiteFff,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.only(top: 25, bottom: 55),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mục tiêu hằng ngày của bạn',
            style: AppTextStyle.w800s20(ColorName.primaryColor),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 10,
                onPressed: () {
                  controller.updateTarget(10);
                },
                numberTarget: 10,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 20,
                onPressed: () {
                  controller.updateTarget(20);
                },
                numberTarget: 20,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 30,
                onPressed: () {
                  controller.updateTarget(30);
                },
                numberTarget: 30,
              ),
              updateTargetItem(
                isDisabled: controller.target.value.targetWord == 50,
                onPressed: () {
                  controller.updateTarget(50);
                },
                numberTarget: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget updateTargetItem({
    Function()? onPressed,
    bool isDisabled = false,
    required int numberTarget,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (onPressed != null && !isDisabled) {
          onPressed.call();
        }
      },
      child: Container(
        height: 70,
        width: 70,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: isDisabled ? ColorName.blue005.withOpacity(0.5) : ColorName.blue80b.withOpacity(0.9),
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
              color: ColorName.blue005.withOpacity(0.5),
              spreadRadius: 0.5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            numberTarget.toString(),
            style: AppTextStyle.w800s20(ColorName.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _searchWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.infinity,
      child: CommonTextField(
        height: 50,
        textInputAction: TextInputAction.done,
        maxLength: 20,
        maxLines: 1,
        suffixIcon: const Icon(
          CupertinoIcons.search,
          color: ColorName.primaryColor,
        ),
        autofocus: true,
        type: FormFieldType.publicID,
        onSubmitted: (publicID) {
          controller.hideKeyboard();
          controller.isSearching.value = false;
          controller.onSearch(publicID ?? '');
        },
      ),
    );
  }
}
