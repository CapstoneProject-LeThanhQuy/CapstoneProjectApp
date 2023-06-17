import 'package:easy_english/base/presentation/base_controller.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/auth_api.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/login_request.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/register_request%20.dart';
import 'package:easy_english/feature/authentication/domain/repositoties/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final _authAPI = Get.find<AuthAPI>();

  @override
  Future<TokenModel> login(LoginRequest request) {
    return _authAPI.login(request);
  }

  @override
  Future<TokenModel> register(RegisterRequest request) {
    return _authAPI.register(request);
  }

  @override
  Future<AccountModel> getAccount() {
    return _authAPI.getAccount();
  }
}
