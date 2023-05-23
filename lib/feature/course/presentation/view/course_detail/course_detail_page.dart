import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/common.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/presentation/controller/course_detail/course_detail_controller.dart';
import 'package:easy_english/feature/course/presentation/view/course_detail/widgets/widget.dart';
import 'package:easy_english/utils/config/app_navigation.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class CourseDetailPage extends BaseWidget<CourseDetailController> {
  CourseDetailPage({Key? key}) : super(key: key);
  @override
  Widget onBuild(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: BaseAppBar(
            title: Text(controller.input.title),
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: controller.courseLevels.length,
                    itemBuilder: (context, index) {
                      return CourseLevelItem(
                        courseLevel: controller.courseLevels[index],
                        isShowDots: index < controller.courseLevels.length - 1,
                        onPressed: () {
                          N.toCousreVocabularyPage(courseLevel: controller.courseLevels[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      color: Colors.transparent,
                      child: CommonButton(
                        height: 50,
                        onPressed: () {},
                        fillColor: ColorName.primaryColor,
                        child: Text(
                          'Học từ mới',
                          style: AppTextStyle.w700s18(ColorName.whiteFff),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    color: Colors.transparent,
                    child: CommonButton(
                      height: 50,
                      width: 50,
                      onPressed: () {},
                      fillColor: ColorName.primaryColor,
                      child: Center(
                        child: Assets.images.menuIcon.image(height: 16, width: 16, color: ColorName.whiteFff),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
