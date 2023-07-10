import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/course_model.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';
import 'package:easy_english/feature/course/presentation/controller/preview_image/preview_image_controller.dart';

import '../extension/route_type.dart';
import 'app_route.dart';

class N {
  static void toDemoPage({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.demo);
  }

  static void toLandingPage({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.landing);
  }

  static void toRegisterPage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.register);
  }

  static void toLoginPage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.login);
  }

  static void toForgotPasswordPage({RouteType type = RouteType.to, String title = "Quên mật khẩu"}) {
    type.navigate(name: AppRoute.forgotPassword, arguments: title);
  }

  static void toForgotPasswordOtpPage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.forgotPasswordOtp);
  }

  static void toTabBar({RouteType type = RouteType.offAll}) {
    type.navigate(name: AppRoute.tabBar);
  }

  static void toCousreDetailPage({RouteType type = RouteType.to, required Course course}) {
    type.navigate(name: AppRoute.cousreDetail, arguments: course);
  }

  static void toCousreVocabularyPage({RouteType type = RouteType.to, required CourseLevel courseLevel}) {
    type.navigate(name: AppRoute.cousreVocabulary, arguments: courseLevel);
  }

  static void toLearningPage({RouteType type = RouteType.to, required List<Vocabulary> vocabularies}) {
    type.navigate(name: AppRoute.learning, arguments: vocabularies);
  }

  static void toCreateCoursePage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.createCourse);
  }

  static void toCreateVocabulary({RouteType type = RouteType.offAndTo, required CourseModel courseModel}) {
    type.navigate(name: AppRoute.createVocabulary, arguments: courseModel);
  }

  static void toPreviewImage({RouteType type = RouteType.to, required ImagePreviewitem previewImageItem}) {
    type.navigate(name: AppRoute.previewImage, arguments: previewImageItem);
  }

  static void toHomeCourseDetail({RouteType type = RouteType.to, required CourseModel courseModel}) {
    type.navigate(name: AppRoute.homeCourseDetail, arguments: courseModel);
  }

  static void toVocabularyDetail({RouteType type = RouteType.to, required Vocabulary vocabulary}) {
    type.navigate(name: AppRoute.vocabularyDetail, arguments: vocabulary);
  }

  static void toLearnDifficultWord({RouteType type = RouteType.to, required List<Vocabulary> vocabularies}) {
    type.navigate(name: AppRoute.learnDifficultWord, arguments: vocabularies);
  }

  static void toLearningDifficult({RouteType type = RouteType.to, required Vocabulary vocabulary}) {
    type.navigate(name: AppRoute.learningDifficult, arguments: vocabulary);
  }

  static void toGamePlay({RouteType type = RouteType.to, required List<Vocabulary> vocabularies}) {
    type.navigate(name: AppRoute.gamePlay, arguments: vocabularies);
  }
}
