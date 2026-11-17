// Fixture for tests that talk to a REAL running backend.
//
// Start the backend against its TEST database (never the dev one), then run:
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live
//
// Without LIVE_API_BASE every live test is skipped (see [liveSkip]).
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:frantend/core/network/dio_client.dart';

String? liveApiBase() {
  final v = Platform.environment['LIVE_API_BASE'];
  return v == null || v.trim().isEmpty ? null : v.trim().replaceAll(RegExp(r'/+$'), '');
}

/// Pass as `skip:` of every live test.
Object? get liveSkip => liveApiBase() == null
    ? 'set LIVE_API_BASE to a backend started on the TEST database to run live tests'
    : false;

class LiveDio implements DioClient {
  LiveDio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

/// A throw-away business registered through the public API.
class LiveTenant {
  LiveTenant({
    required this.base,
    required this.dio,
    required this.businessId,
    required this.branchId,
    required this.unitId,
    required this.token,
  });

  final String base;
  final Dio dio;
  final String businessId;
  final String branchId;
  final String unitId;
  final String token;

  DioClient get client => LiveDio(dio);

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async =>
      Map<String, dynamic>.from(
        (await dio.get<Object?>(path, queryParameters: query)).data! as Map,
      );

  Future<List<dynamic>> getList(String path, {Map<String, dynamic>? query}) async {
    final data = (await dio.get<Object?>(path, queryParameters: query)).data;
    if (data is List) return data;
    return List<dynamic>.from((data! as Map)['items'] as List);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async =>
      Map<String, dynamic>.from((await dio.post<Object?>(path, data: body)).data! as Map);

  /// Registers a business + owner, logs in implicitly and creates a base unit.
  static Future<LiveTenant> register(String base, {String label = 'Live'}) async {
    final rnd = Random();
    final suffix = rnd.nextInt(9000000) + 1000000;
    final plain = Dio(BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      validateStatus: (_) => true,
    ));
    final reg = await plain.post<Object?>('/auth/register', data: {
      'business_name': '$label ${DateTime.now().millisecondsSinceEpoch}',
      'business_type_code': 'retail',
      'owner_name': 'Live Owner',
      'owner_phone': '300${suffix.toString().padLeft(7, '0')}',
      'owner_password': 'Passw0rd!x1',
      'branch_name': 'Main',
    });
    if (reg.statusCode != 201) {
      throw StateError('register failed: ${reg.statusCode} ${reg.data}');
    }
    final body = Map<String, dynamic>.from(reg.data! as Map);
    final token = body['access_token'] as String;
    final user = Map<String, dynamic>.from(body['user'] as Map);
    final dio = Dio(BaseOptions(
      baseUrl: base,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Authorization': 'Bearer $token'},
    ));
    final unit = await dio.post<Object?>('/units', data: {
      'name': 'Piece',
      'symbol': 'pc',
      'is_base_unit': true,
    });
    return LiveTenant(
      base: base,
      dio: dio,
      businessId: '${user['business_id']}',
      branchId: '${user['branch_id']}',
      unitId: '${(unit.data! as Map)['id']}',
      token: token,
    );
  }
}
