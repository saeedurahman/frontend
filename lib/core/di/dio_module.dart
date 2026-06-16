import 'package:dio/dio.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dio(DioClient client) => client.dio;
}
