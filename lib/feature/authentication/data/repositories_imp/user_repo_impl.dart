import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/user_api.dart';

import '../../domain/repositoties/user_repo.dart';
import '../models/list_user_model.dart';

class UserRepoImpl implements UserRepo {
  final userAPI = Get.find<UserAPI>();
  @override
  Future<ListUserModel> getUserData() async {
    final listUser = await userAPI.getUserData();
    return listUser;
  }
}
