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
import 'package:easy_english/feature/course/presentation/view/create_course/create_course_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/create_course/create_course_page.dart';
import 'package:easy_english/feature/course/presentation/view/create_vocabulary/create_vocabulary_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/create_vocabulary/create_vocabulary_page.dart';
import 'package:easy_english/feature/course/presentation/view/learning/learning_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/learning/learning_page.dart';
import 'package:easy_english/feature/course/presentation/view/learning_difficult/learning_difficult_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/learning_difficult/learning_difficult_page.dart';
import 'package:easy_english/feature/course/presentation/view/learning_difficult_words/learning_difficult_words_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/learning_difficult_words/learning_difficult_words_page.dart';
import 'package:easy_english/feature/course/presentation/view/preview_image/preview_image_bindings.dart';
import 'package:easy_english/feature/course/presentation/view/preview_image/preview_image_page.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/game_play_bindings.dart';
import 'package:easy_english/feature/game/presentation/view/game_play/game_play_page.dart';
import 'package:easy_english/feature/home/presentation/view/home_course_detail/home_course_detail_bindings.dart';
import 'package:easy_english/feature/home/presentation/view/home_course_detail/home_course_detail_page.dart';
import 'package:easy_english/feature/home/presentation/view/vocabulary_detail/vocabulary_detail_bindings.dart';
import 'package:easy_english/feature/home/presentation/view/vocabulary_detail/vocabulary_detail_page.dart';
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
  static String createCourse = '/createCourse';
  static String createVocabulary = '/createVocabulary';
  static String previewImage = '/previewImage';
  static String homeCourseDetail = '/homeCourseDetail';
  static String vocabularyDetail = '/vocabularyDetail';
  static String learnDifficultWord = '/learnDifficultWord';
  static String learningDifficult = '/learningDifficult';
  static String gamePlay = '/gamePlay';

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
    GetPage(
      name: createCourse,
      page: CreateCoursePage.new,
      binding: CreateCourseBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: createVocabulary,
      page: CreateVocabularyPage.new,
      binding: CreateVocabularyBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: previewImage,
      page: PreviewImagePage.new,
      binding: PreviewImageBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: homeCourseDetail,
      page: HomeCourseDetailPage.new,
      binding: HomeCourseDetailBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: vocabularyDetail,
      page: VocabularyDetailPage.new,
      binding: VocabularyDetailBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: learnDifficultWord,
      page: LearningDifficultWordsPage.new,
      binding: LearningDifficultWordsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: learningDifficult,
      page: LearningDifficultPage.new,
      binding: LearningDifficultBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: gamePlay,
      page: GamePlayPage.new,
      binding: GamePlayBindings(),
      transition: Transition.cupertino,
    ),
  ];
}
