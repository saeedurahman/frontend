import 'package:dio/dio.dart';
import 'package:frantend/core/sync/sync_models.dart';

/// [SyncApi] over the authenticated Dio client.
///
/// `X-Device-ID` and `X-App-Version` are also added to every request by
/// `DeviceHeaderInterceptor`; the query parameter is sent as well because the
/// pull/snapshot endpoints accept either.
class HttpSyncApi implements SyncApi {
  HttpSyncApi({
    required Dio dio,
    required Future<String> Function() deviceId,
    required Future<String> Function() deviceName,
    required this.appVersion,
  })  : _dio = dio,
        _deviceId = deviceId,
        _deviceName = deviceName;

  final Dio _dio;
  final Future<String> Function() _deviceId;
  final Future<String> Function() _deviceName;
  final String appVersion;

  static final _options = Options(extra: const {'no_retry': true});

  @override
  Future<PullPage> pull({
    String? since,
    int limit = 500,
    String? branchId,
  }) async {
    final json = await _get('/sync/pull', {
      if (since != null) 'since': since,
      'limit': limit,
      if (branchId != null) 'branch_id': branchId,
      'device_id': await _deviceId(),
    });
    return PullPage.fromJson(json);
  }

  @override
  Future<SnapshotPage> snapshot({String? pageToken, int limit = 500}) async {
    final json = await _get('/sync/snapshot', {
      'limit': limit,
      if (pageToken != null) 'page_token': pageToken,
      'device_id': await _deviceId(),
    });
    return SnapshotPage.fromJson(json);
  }

  @override
  Future<PushResponse> push({
    required String batchId,
    required List<Map<String, dynamic>> ops,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/sync/push',
        data: {
          'device_id': await _deviceId(),
          'batch_id': batchId,
          'device_name': await _deviceName(),
          'app_version': appVersion,
          'ops': ops,
        },
        options: _options,
      );
      return PushResponse.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<List<FlaggedSale>> flags({
    String? flag,
    int skip = 0,
    int limit = 100,
  }) async {
    final json = await _get('/sync/flags', {
      if (flag != null) 'flag': flag,
      'skip': skip,
      'limit': limit,
    });
    return [
      for (final item in (json['items'] as List? ?? const []))
        FlaggedSale.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<Map<String, dynamic>> _get(
    String path,
    Map<String, dynamic> query,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
        options: _options,
      );
      return response.data ?? const {};
    } on DioException catch (e) {
      throw mapError(e);
    }
  }

  /// Turns a transport error into the typed whole-request errors.
  static SyncApiException mapError(DioException e) {
    final status = e.response?.statusCode;
    if (status == null) {
      return SyncUnreachableException(e.message ?? 'No connection');
    }
    final data = e.response?.data;
    final detail = data is Map ? data['detail'] : null;
    final code = detail is Map ? '${detail['code']}' : null;
    final message =
        detail is Map ? '${detail['message'] ?? ''}' : (detail?.toString() ?? '');

    if (status == 403 && code == 'device_revoked') {
      return DeviceRevokedException(message);
    }
    if (status == 413) return BatchTooLargeException(message);
    if (status == 429) {
      final raw = e.response?.headers.value('retry-after');
      final seconds = int.tryParse(raw ?? '') ?? 60;
      return RateLimitedException(Duration(seconds: seconds < 1 ? 1 : seconds));
    }
    if (status == 400 && code == 'invalid_cursor') {
      return InvalidCursorException(message);
    }
    return SyncServerException(
      message.isEmpty ? 'Server error $status' : message,
      statusCode: status,
    );
  }
}
