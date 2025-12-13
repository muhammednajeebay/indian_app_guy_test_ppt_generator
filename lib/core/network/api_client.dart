import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../utils/logger.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          bluePrint('➡️ REQUEST [${options.method}] => PATH: ${options.path}');
          if (options.data != null) {
            bluePrint('➡️ DATA: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            bluePrint('➡️ QUERY PARAMS: ${options.queryParameters}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          greenPrint(
            '✅ RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          greenPrint('✅ DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          redPrint(
            '❌ ERROR [${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          if (e.response != null) {
            redPrint('❌ ERROR DATA: ${e.response?.data}');
          }
          redPrint('❌ MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }
}
