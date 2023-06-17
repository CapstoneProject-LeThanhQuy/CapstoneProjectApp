import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/login_request.dart';
import 'package:easy_english/feature/authentication/domain/repositoties/auth_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class LoginUsecase extends UseCaseIO<LoginRequest, TokenModel> {
  LoginUsecase(this._authRepo);
  final AuthRepo _authRepo;

  @override
  Future<TokenModel> build(LoginRequest input) {
    return _authRepo.login(input);
  }
}
