import 'package:dio/dio.dart';
import 'package:app_storethuc/data/spref/spref.dart';
import 'package:app_storethuc/shared/constant.dart';

class BookClient {
  // ignore: unused_field
  static final BaseOptions _options = BaseOptions(
      baseUrl: "https://storethuc.xyz/api",
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000));

  static final Dio _dio = Dio(_options);
  BookClient._internal() {
    //_dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions myOption, RequestInterceptorHandler handler) async {
          var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
          if (token != null) {
            // ignore: prefer_interpolation_to_compose_strings
            // myOption.headers["Authorization"] = "Bearer " + token;
            myOption.headers["Authorization"] = token;
          }

          return handler.next(myOption);
        },
      ),
    );
  }
  static final BookClient instance = BookClient._internal();

  Dio get dio => _dio;
}
