import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/auth_api.dart';

import '../../../../base/domain/base_usecase.dart';

class GetAccountInfoUsecase extends UseCase<AccountModel> {
  GetAccountInfoUsecase(this._authAPI);
  final AuthAPI _authAPI;

  @override
  Future<AccountModel> build() {
    return _authAPI.getAccount();
  }
}
