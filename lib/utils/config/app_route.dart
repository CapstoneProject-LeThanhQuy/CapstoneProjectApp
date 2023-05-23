import 'package:easy_english/base/presentation/tab_bar/tab_bar_bindings.dart';
import 'package:easy_english/base/presentation/tab_bar/tab_bar_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_otp_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/forgot_password/forgot_password_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/landing/landing_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/landing/landing_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/login/login_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/login/login_page.dart';
import 'package:easy_english/feature/authentication/presentation/view/register/register_bindings.dart';
import 'package:easy_english/feature/authentication/presentation/view/register/register_page.dart';
import 'package:easy_english/feature/course/presentation/view/course_detail/course_detail_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/course_detail/course_detail_page.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/course_vocabulary_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/course_vocabulary/course_vocabulary_page.dart';
import 'package:easy_english/feature/course/presentation/view/learning/learning_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/learning/learning_page.dart';
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
  static String tabBar = '/tabBar';
  static String cousreDetail = '/cousreDetail';
  static String cousreVocabulary = '/cousreVocabulary';
  static String learning = '/learning';

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
      name: tabBar,
      page: TabBarPage.new,
      binding: TabBarBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cousreDetail,
      page: CourseDetailPage.new,
      binding: CourseDetailBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: cousreVocabulary,
      page: CourseVocabularyPage.new,
      binding: CourseVocabularyBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: learning,
      page: LearningPage.new,
      binding: LearningBindings(),
      transition: Transition.cupertino,
    ),
  ];
}
