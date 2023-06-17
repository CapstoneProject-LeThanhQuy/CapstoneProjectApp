import 'package:dio/dio.dart';

import '../interceptor/header_interceptor.dart';

class DioBuilder extends DioMixin implements Dio {
  final String contentType = 'application/json';
  final Duration connectionTimeOutMls = const Duration(milliseconds: 300000);
  final Duration readTimeOutMls = const Duration(milliseconds: 300000);
  final Duration writeTimeOutMls = const Duration(milliseconds: 300000);


  DioBuilder({required BaseOptions options}) {
    options = BaseOptions(
      baseUrl: options.baseUrl,
      contentType: contentType,
      connectTimeout: connectionTimeOutMls,
      receiveTimeout: readTimeOutMls,
      sendTimeout: writeTimeOutMls,
    );

    this.options = options;
    interceptors.add(HeaderInterceptor());

    httpClientAdapter = HttpClientAdapter();
  }
}
