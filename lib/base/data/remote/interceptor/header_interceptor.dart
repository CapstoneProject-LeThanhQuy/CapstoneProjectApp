import 'package:dio/dio.dart';
import 'package:easy_english/base/presentation/base_helper.dart';
import 'package:easy_english/feature/authentication/data/models/token_model.dart';
import 'package:easy_english/utils/config/app_config.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Content-Type'] = 'application/json';

    TokenModel token = AppConfig.tokenInfo;
    if (token.accessToken != null) {
      options.headers["Authorization"] = "Bearer ${token.accessToken}";
    }

    debugPrint('==================================================');
    debugPrint('🚀Endpoint🚀: ${options.method} => ${options.uri}');
    debugPrint('==================================================');

    handler.next(options);
  }
}
