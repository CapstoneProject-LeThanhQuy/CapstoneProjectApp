import 'package:dio/dio.dart';
import 'package:easy_english/base/data/local/repositories_imp/course_level_local_repo_imp.dart';
import 'package:easy_english/base/data/local/repositories_imp/course_local_repo_imp.dart';
import 'package:easy_english/base/data/local/repositories_imp/vocabulary_local_repo_imp.dart';
import 'package:easy_english/base/domain/repositoties/course_level_local_repo.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/auth_api.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/user_api.dart';
import 'package:easy_english/feature/authentication/data/repositories_imp/auth_repo_impl.dart';
import 'package:easy_english/feature/authentication/domain/repositoties/auth_repo.dart';
import 'package:easy_english/feature/course/data/providers/remote/course_api.dart';
import 'package:easy_english/feature/course/data/repositories_imp/course_repo_impl.dart';
import 'package:easy_english/feature/course/domain/repositoties/course_repo.dart';
import 'package:easy_english/utils/services/storage_service.dart';
import 'package:easy_english/utils/services/storage_service_impl.dart';
import 'package:get/instance_manager.dart';

import '../../../feature/authentication/data/repositories_imp/user_repo_impl.dart';
import '../../../feature/authentication/domain/repositoties/user_repo.dart';
import '../../base/data/remote/builder/dio_builder.dart';
import 'app_config.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectNetworkProvider();
    injectRepository();
    injectService();
  }

  void injectNetworkProvider() {
    Get.lazyPut(
      () => DioBuilder(
        options: BaseOptions(baseUrl: AppConfig.baseUrl),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => UserAPI(Get.find<DioBuilder>()),
      fenix: true,
    );
    Get.lazyPut(
      () => AuthAPI(Get.find<DioBuilder>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CourseAPI(Get.find<DioBuilder>()),
      fenix: true,
    );
  }

  void injectRepository() {
    Get.put<UserRepo>(UserRepoImpl());
    Get.put<VocabularyLocalRepo>(VocabularyLocalRepoImp());
    Get.put<CourseLocalRepo>(CourseLocalRepoImp());
    Get.put<CourseLevelLocalRepo>(CourseLevelLocalRepoImp());
    Get.put<AuthRepo>(AuthRepoImpl());
    Get.put<CourseRepo>(CourseRepoImpl());
  }

  void injectService() {
    Get.put<StorageService>(StorageServiceImpl());
  }
}
