import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/login_request.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/register_request%20.dart';

abstract class AuthRepo {
  Future<TokenModel> login(LoginRequest request);
  Future<TokenModel> register(RegisterRequest request);
  Future<AccountModel> getAccount();
}
