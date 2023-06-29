import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/common_search.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/home/presentation/controller/home_course_detail/home_course_detail_controller.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:easy_english/utils/simpletreeview/lib/flutter_simple_treeview.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeCourseDetailPage extends BaseWidget<HomeCourseDetailController> {
  const HomeCourseDetailPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.hideKeyboard();
        controller.isSearching.value = false;
      },
      child: Obx(
        () {
          return Stack(
            children: [
              Positioned.fill(
                child: Scaffold(
                  appBar: BaseAppBar(),
                  body: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Column(
                            children: [
                              Container(
                                color: ColorName.primaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(height: 15),
                                          Text(
                                            controller.course.value.title ?? '',
                                            style: AppTextStyle.w700s18(ColorName.whiteFff),
                                            textAlign: TextAlign.right,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            controller.course.value.description ?? '',
                                            style: AppTextStyle.w400s15(ColorName.whiteFff),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        color: ColorName.whiteFaf,
                                        child: (controller.course.value.image ?? '').isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: controller.course.value.image ?? '',
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
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Assets.images.manProfileIcon.image(
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Create by',
                                          style: AppTextStyle.w400s15(ColorName.primaryColor.withOpacity(0.8)),
                                          textAlign: TextAlign.right,
                                        ),
                                        Text(
                                          'Lê Thanh Quý',
                                          style: AppTextStyle.w600s15(ColorName.primaryColor),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    CupertinoButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      color: ColorName.primaryColor,
                                      onPressed: () {
                                        if (!controller.isFollow.value) {
                                          controller.joinCourse();
                                        } else {
                                          controller.downloadCourse();
                                        }
                                      },
                                      child: Text(
                                        controller.isFollow.value ? 'Tải xuống khóa học' : 'Tham gia ngay',
                                        style: AppTextStyle.w600s16(ColorName.whiteFaf),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Khóa học: ',
                                          style: AppTextStyle.w600s20(ColorName.black000),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${controller.course.value.publicId ?? 0}',
                                          style: AppTextStyle.w600s17(ColorName.primaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          'Thành viên: ',
                                          style: AppTextStyle.w600s20(ColorName.black000),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${controller.course.value.member ?? 0}',
                                          style: AppTextStyle.w600s17(ColorName.primaryColor),
                                        ),
                                        const SizedBox(width: 3),
                                        const Icon(
                                          Icons.people_alt,
                                          size: 18,
                                          color: ColorName.primaryColor,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          'Số lượng từ vựng: ',
                                          style: AppTextStyle.w600s20(ColorName.black000),
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          '${controller.course.value.totalWords ?? 0}',
                                          style: AppTextStyle.w600s17(ColorName.primaryColor),
                                        ),
                                        const SizedBox(width: 3),
                                        const Icon(
                                          Icons.menu_book,
                                          size: 18,
                                          color: ColorName.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'Bảng xếp hạng',
                                style: AppTextStyle.w600s22(ColorName.black000),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                child: ListView.builder(
                                  itemCount: 5,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Assets.images.manProfileIcon.image(
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${index + 1}.',
                                            style: AppTextStyle.w600s20(ColorName.black000),
                                          ),
                                          const SizedBox(width: 20),
                                          Container(
                                            constraints: const BoxConstraints(maxWidth: 150),
                                            child: Text(
                                              'Lê Thanh Quý',
                                              style: AppTextStyle.w600s20(ColorName.black000),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '262,775',
                                            style: AppTextStyle.w600s15(ColorName.primaryColor),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {},
                                child: const Text(
                                  'Xem thêm',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                  color: ColorName.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Đánh giá và nhận xét (0)',
                                      style: AppTextStyle.w600s17(ColorName.black000),
                                    ),
                                    const Spacer(),
                                    CupertinoButton(
                                      alignment: Alignment.bottomRight,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          Text(
                                            'Xem tất cả',
                                            style: AppTextStyle.w400s15(ColorName.gray828),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 15,
                                            color: ColorName.gray828,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    '${controller.course.value.rating}/5',
                                    style: AppTextStyle.w600s17(ColorName.black000),
                                  ),
                                  const SizedBox(width: 1),
                                  const Icon(
                                    Icons.star,
                                    size: 17,
                                    color: ColorName.orangeDdb,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Text(
                                  'Chưa có nhận xét',
                                  style: AppTextStyle.w600s17(ColorName.black000),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Từ vựng',
                                      style: AppTextStyle.w600s20(ColorName.black000),
                                    ),
                                    const Spacer(),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        controller.onSearch(' ');
                                        controller.onSearch('');
                                        controller.scrolltoBottom();
                                      },
                                      child: const Icon(
                                        CupertinoIcons.arrow_2_circlepath_circle_fill,
                                        size: 30,
                                        color: ColorName.primaryColor,
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        if (!controller.isSearching.value) {
                                          controller.onSearch('');
                                          controller.scrolltoBottom();
                                          controller.isSearching.value = true;
                                        }
                                      },
                                      child: const Icon(
                                        CupertinoIcons.search_circle_fill,
                                        size: 30,
                                        color: ColorName.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Obx(
                                  () => _buildSimpleTreeView(context),
                                ),
                              ),
                              const SizedBox(height: 35),
                            ],
                          ),
                        ),
                      ),
                      Obx(
                        () {
                          return controller.isSearching.value
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  width: double.infinity,
                                  child: SearchCommon(
                                    autofocus: true,
                                    onChange: (value) {
                                      controller.onSearch(value);
                                    },
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: ColorName.black000.withOpacity(0.6),
                    child: const LoadingWidget(
                      color: ColorName.whiteFff,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSimpleTreeView(BuildContext context) {
    return TreeView(
      treeController: controller.treeController,
      indent: 10,
      nodes: controller.listCourseLevelView.map(
        (courseLevel) {
          return TreeNode(
            color: ColorName.grayD9d.withOpacity(0.6),
            content: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          courseLevel.title,
                          maxLines: 10,
                          overflow: TextOverflow.visible,
                          style: AppTextStyle.w700s18(ColorName.black000),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.book_solid,
                              size: 18,
                              color: ColorName.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${courseLevel.totalWords}',
                              style: AppTextStyle.w500s16(ColorName.gray4f4),
                            ),
                            const SizedBox(width: 15),
                            const Icon(
                              CupertinoIcons.drop_fill,
                              size: 18,
                              color: ColorName.primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${courseLevel.level}',
                              style: AppTextStyle.w500s16(ColorName.gray4f4),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            children: courseLevel.vocabularies?.map(
              (vocabulary) {
                return TreeNode(
                  color: ColorName.grayD9d.withOpacity(0.6),
                  content: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      N.toVocabularyDetail(vocabulary: vocabulary);
                    },
                    child: _buildItem(vocabulary, courseLevel, context),
                  ),
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }

  Widget _buildItem(Vocabulary vocabulary, CourseLevel courseLevel, BuildContext context) {
    return Row(
      children: [
        vocabulary.image.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: vocabulary.image,
                height: 75,
                width: 75,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Assets.images.logoIcon.image(width: 75, height: 75, fit: BoxFit.cover),
              )
            : Assets.images.logoIcon.image(width: 75, height: 75, fit: BoxFit.cover),
        const SizedBox(width: 15),
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vocabulary.englishText,
                style: AppTextStyle.w700s18(ColorName.black000),
              ),
              Text(
                '[${vocabulary.wordType}]',
                style: AppTextStyle.w700s18(ColorName.green27b),
              ),
              Text(
                vocabulary.vietnameseText,
                style: AppTextStyle.w500s16(ColorName.gray838),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
