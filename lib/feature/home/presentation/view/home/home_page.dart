import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/feature/home/data/models/target.dart';
import 'package:easy_english/feature/home/presentation/controller/home/home_controller.dart';
import 'package:easy_english/feature/home/presentation/view/home/widgets/widget.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';

class HomePage extends BaseWidget<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.grayF2f,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              TargetItem( 
                target: Target(15, 5, 30, 30, 19, 130),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
