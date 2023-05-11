import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:get/get.dart';

class HomePage extends BaseWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Text(
          'HomePage',
          style: AppTextStyle.w800s33(ColorName.primaryColor),
        )),
      ),
    );
  }
}
