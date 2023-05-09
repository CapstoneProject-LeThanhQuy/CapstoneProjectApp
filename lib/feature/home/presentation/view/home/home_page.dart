import 'package:easy_english/base/presentation/base_app_bar.dart';
import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:get/get.dart';

class HomePage extends BaseWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: const Text('HomePage'),
      ),
      body: Container(),
    );
  }
}
