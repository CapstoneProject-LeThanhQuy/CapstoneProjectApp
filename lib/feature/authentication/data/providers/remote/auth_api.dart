import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:easy_english/feature/authentication/data/models/account_model.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/login_request.dart';
import 'package:easy_english/feature/authentication/data/providers/remote/request/register_request%20.dart';
import 'package:retrofit/http.dart';

part 'auth_api.g.dart';

@RestApi(parser: Parser.DartJsonMapper)
abstract class AuthAPI {
  factory AuthAPI(Dio dioBuilder) = _AuthAPI;

  @POST('/auth/login')
  Future<TokenModel> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<TokenModel> register(@Body() RegisterRequest request);

  @GET('/auth/info')
  Future<AccountModel> getAccount();
}
