import 'package:dio/dio.dart';
import 'package:easy_english/base/data/local/repositories_imp/course_local_repo_imp.dart';
import 'package:easy_english/base/data/local/repositories_imp/vocabulary_local_repo_imp.dart';
import 'package:easy_english/base/domain/repositoties/course_local_repo.dart';
import 'package:easy_english/base/domain/repositoties/vocabulary_local_repo.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/user_api.dart';
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
  }

  void injectRepository() {
    Get.put<UserRepo>(UserRepoImpl());
    Get.put<VocabularyLocalRepo>(VocabularyLocalRepoImp());
    Get.put<CourseLocalRepo>(CourseLocalRepoImp());
  }
}
