import 'package:dio/dio.dart';
import 'package:dio_firebase_performance/dio_firebase_performance.dart';

class DioUtil {
  DioUtil._();

  Dio dio() {
    final dio = Dio();
    dio.interceptors.add(DioFirebasePerformanceInterceptor());
    return dio;
  }
}
