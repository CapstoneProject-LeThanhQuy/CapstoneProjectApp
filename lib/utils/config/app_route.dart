import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_otp_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/landing/landing_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/landing/landing_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/login/login_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/login/login_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/register/register_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/register/register_page.dart';
import 'package:easy_english/feature/home/presentation/view/home/home_bindings.dart';
import 'package:easy_english/feature/home/presentation/view/home/home_page.dart';
import 'package:get/route_manager.dart';

import '../../../feature/authentication/presentation/view/demo/demo_bindings.dart';
import '../../../feature/authentication/presentation/view/demo/demo_page.dart';
import '../../feature/authentication/presentation/view/root/root_bindings.dart';
import '../../feature/authentication/presentation/view/root/root_page.dart';

class AppRoute {
  static String root = '/';
  static String demo = '/demo';
  static String landing = '/landing';
  static String register = '/register';
  static String login = '/login';
  static String forgotPassword = '/forgotPassword';
  static String forgotPasswordOtp = '/forgotPasswordOtp';
  static String home = '/home';

  static List<GetPage> generateGetPages = [
    GetPage(
      name: root,
      page: RootPage.new,
      binding: RootBindings(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: demo,
      page: DemoPage.new,
      binding: DemoBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: landing,
      page: LandingPage.new,
      binding: LandingBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: RegisterPage.new,
      binding: RegisterBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: login,
      page: LoginPage.new,
      binding: LoginBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: forgotPassword,
      page: ForgotPasswordPage.new,
      binding: ForgotPasswordBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: forgotPasswordOtp,
      page: ForgotPasswordOtpPage.new,
      binding: ForgotPasswordBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: home,
      page: HomePage.new,
      binding: HomeBindings(),
      transition: Transition.fadeIn,
    ),
  ];
}
