import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/course/presentation/controller/course/course_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class CoursePage extends BaseWidget<CourseController> {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
          'CoursePage',
          style: AppTextStyle.w800s33(ColorName.primaryColor),
        )),
      ),
    );
  }
}
