import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/utils/config/app_config.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

import 'widgets/widget.dart';

class CoursePage extends BaseWidget<CourseController> {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorName.grayEce,
          body: Column(
            children: [
              Expanded(
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
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return CourseItem(
                              course: Course(1, 'Từ vựng TOEIC cơ bản - QUYLT TOEIC', '', 1500, 1500, 100, 100),
                              onPressed: () {},
                              typeCourse: TypeCourse.myCourse,
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Các Khóa học Đã Được Tải Về',
                            style: AppTextStyle.w600s15(ColorName.blue007),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.courses.length,
                          itemBuilder: (context, index) {
                            return CourseItem(
                              course: controller.courses[index],
                              onPressed: () {
                                AppConfig.currentCourse = controller.courses[index];
                                N.toCousreDetailPage(
                                  course: controller.courses[index],
                                );
                              },
                              typeCourse: TypeCourse.downloadCourse,
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Các Khóa Học Khác',
                            style: AppTextStyle.w600s15(ColorName.redFf3),
                          ),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return CourseItem(
                              course: Course(1, 'Chinh phục 600+ TOEIC', '', 1500, 0, 100, 100),
                              onPressed: () {},
                              typeCourse: TypeCourse.followCourse,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                color: Colors.transparent,
                child: CommonButton(
                  height: 50,
                  onPressed: () {},
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
