import 'package:easy_english/feature/course/data/models/course.dart';
import 'package:easy_english/feature/course/data/models/course_level.dart';
import 'package:easy_english/feature/course/data/models/vocabulary.dart';

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

  static void toForgotPasswordPage({RouteType type = RouteType.to}) {
    type.navigate(name: AppRoute.forgotPassword);
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
}
