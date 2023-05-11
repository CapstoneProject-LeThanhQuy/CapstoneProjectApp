import 'package:easy_english/base/presentation/base_widget.dart';
import 'package:easy_english/base/presentation/widgets/input_otp_widget.dart';
import 'package:easy_english/utils/config/app_text_style.dart';
import 'package:easy_english/utils/gen/assets.gen.dart';
import 'package:easy_english/utils/gen/colors.gen.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../base/presentation/base_app_bar.dart';
import '../../controller/forgot_password/forgot_password_controller.dart';

class ForgotPasswordOtpPage extends BaseWidget<ForgotPasswordController> {
  const ForgotPasswordOtpPage({Key? key}) : super(key: key);

  @override
  Widget onBuild(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        title: const Text('Quên mật khẩu'),
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => IgnorePointer(
          ignoring: controller.ignoringPointer.value,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Assets.images.phoneIcon.image(scale: 3),
                    const SizedBox(height: 20),
                    Text(
                      'Nhập mã OTP',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.w400s12(ColorName.gray4f4),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Chúng tôi đã gửi tin nhắn SMS có mã kích hoạt đến bạn',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.w400s12(ColorName.gray838),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+84 343440509',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.w400s12(ColorName.black000),
                    ),
                    const SizedBox(height: 37),
                  ],
                ),
              ),
              InputOTPWidget(
                callback: (otpCode) {
                  print('Thành công');
                },
              ),
              const SizedBox(height: 47),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: Text(
                  'Gửi lại mã (10s)',
                  style: AppTextStyle.w400s12(ColorName.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
