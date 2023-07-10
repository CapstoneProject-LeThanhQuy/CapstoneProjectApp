import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/widget.dart';

class CoursePage extends BaseWidget<CourseController> {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        if (!controller.isLoading1.value && !controller.isLoading2.value && !controller.isLoading2.value) {
          controller.refreshController.refreshCompleted();
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorName.grayEce,
          body: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  scrollController: controller.scrollController,
                  enablePullDown: true,
                  controller: controller.refreshController,
                  onRefresh: controller.onRefresh,
                  onLoading: controller.onLoading,
                  header: const WaterDropMaterialHeader(
                    backgroundColor: ColorName.primaryColor,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Các khóa học đã được tạo',
                              style: AppTextStyle.w600s15(ColorName.green27b),
                            ),
                          ),
                          if (controller.myCourses.isEmpty && !controller.isLoading2.value)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chưa có khóa học nào được tạo',
                                    style: AppTextStyle.w600s15(ColorName.black000),
                                  ),
                                ],
                              ),
                            ),
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.myCourses.length,
                            itemBuilder: (context, index) {
                              return CourseItem(
                                course: controller.myCourses[index],
                                onPressedDetail: () {
                                  controller.toCourseDetailMyCourse(index);
                                },
                                onPressed: () {
                                  controller.toCourseUpdate(index);
                                },
                                typeCourse: TypeCourse.myCourse,
                              );
                            },
                          ),
                          if (controller.isLoading2.value)
                            Shimmer.fromColors(
                              baseColor: ColorName.grayE0e,
                              highlightColor: ColorName.grayD2d,
                              child: Column(
                                children: [
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
                                  ),
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Các Khóa học Đã Được Tải Về',
                              style: AppTextStyle.w600s15(ColorName.blue007),
                            ),
                          ),
                          if (controller.localCourses.isEmpty && !controller.isLoading1.value)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chưa có khóa học nào được tải về',
                                    style: AppTextStyle.w600s15(ColorName.black000),
                                  ),
                                ],
                              ),
                            ),
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.localCourses.length,
                            itemBuilder: (context, index) {
                              return CourseItem(
                                onPressedDetail: () {
                                  controller.toCourseDetailFollow(index);
                                },
                                course: controller.localCourses[index],
                                onPressed: () {
                                  AppConfig.currentCourse = controller.localCourses[index];
                                  N.toCousreDetailPage(
                                    course: controller.localCourses[index],
                                  );
                                },
                                typeCourse: TypeCourse.downloadCourse,
                              );
                            },
                          ),
                          if (controller.isLoading1.value)
                            Shimmer.fromColors(
                              baseColor: ColorName.grayE0e,
                              highlightColor: ColorName.grayD2d,
                              child: Column(
                                children: [
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
                                  ),
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Các Khóa Học Khác',
                              style: AppTextStyle.w600s15(ColorName.redFf3),
                            ),
                          ),
                          if (controller.followCourses.isEmpty && !controller.isLoading3.value)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chưa tham gia khóa học nào',
                                    style: AppTextStyle.w600s15(ColorName.black000),
                                  ),
                                ],
                              ),
                            ),
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.followCourses.length,
                            itemBuilder: (context, index) {
                              return CourseItem(
                                course: controller.followCourses[index],
                                onPressedDetail: () {
                                  controller.toCourseDetail(index);
                                },
                                onPressed: () {
                                  controller.toCourseDetail(index);
                                },
                                typeCourse: TypeCourse.followCourse,
                              );
                            },
                          ),
                          if (controller.isLoading3.value)
                            Shimmer.fromColors(
                              baseColor: ColorName.grayE0e,
                              highlightColor: ColorName.grayD2d,
                              child: Column(
                                children: [
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
                                  ),
                                  CourseItem(
                                    course: Course(0, 0, '', '', '', 0, 0, 0, 0, 0),
                                    onPressed: () {},
                                    typeCourse: TypeCourse.myCourse,
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
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                color: Colors.transparent,
                child: CommonButton(
                  height: 50,
                  onPressed: () {
                    controller.createCourse();
                  },
                  fillColor: ColorName.primaryColor,
                  child: Text(
                    'Tạo mới khóa học',
                    style: AppTextStyle.w700s18(ColorName.whiteFff),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
