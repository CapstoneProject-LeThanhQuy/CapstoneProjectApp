import 'package:easy_english/feature/authentication/data/providers/remote/request/register_request%20.dart';
import 'package:easy_english/feature/authentication/domain/repositoties/auth_repo.dart';

import '../../../../base/domain/base_usecase.dart';

class RegisterUsecase extends UseCaseIO<RegisterRequest, bool> {
  RegisterUsecase(this._authRepo);
  final AuthRepo _authRepo;

  @override
  Future<bool> build(RegisterRequest input) {
    return _authRepo.register(input);
  }
}
