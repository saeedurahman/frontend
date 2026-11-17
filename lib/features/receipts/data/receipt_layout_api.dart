import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/user_error_message.dart';

/// A readable problem from the layouts API (offline, 409 "assigned", 422...).
class ReceiptApiException implements Exception {
  const ReceiptApiException(this.message, {this.status, this.code, this.offline = false});

  final String message;
  final int? status;
  final String? code;

  /// The server could not be reached; nothing was changed.
  final bool offline;

  @override
  String toString() => message;

  /// Turns any Dio failure into a [ReceiptApiException] with words for the
  /// screen. Shared by the devices API.
  static ReceiptApiException from(Object error) {
    if (error is ReceiptApiException) return error;
    if (error is DioException) {
      if (UserErrorMessage.isConnectionError(error)) {
        return const ReceiptApiException(UserErrorMessage.offline, offline: true);
      }
      final data = error.response?.data;
      var code = '';
      var message = '';
      if (data is Map) {
        final detail = data['detail'];
        if (detail is Map) {
          code = '${detail['code'] ?? ''}';
          message = '${detail['message'] ?? ''}';
        }
      }
      if (message.isEmpty) {
        message = ApiErrorParser.message(data, fallback: '');
      }
      if (message.isEmpty) message = UserErrorMessage.generic;
      return ReceiptApiException(
        message,
        status: error.response?.statusCode,
        code: code.isEmpty ? null : code,
      );
    }
    return ReceiptApiException(UserErrorMessage.from(error));
  }
}

/// Dio client for `/receipt-layouts` (all `settings.manage`, online only).
class ReceiptLayoutApi {
  ReceiptLayoutApi(this._dio);

  final Dio _dio;

  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ReceiptApiException.from(e);
    }
  }

  Map<String, dynamic> _map(Object? data) => data is Map
      ? Map<String, dynamic>.from(data)
      : throw const ReceiptApiException(UserErrorMessage.generic);

  List<Map<String, dynamic>> _list(Object? data) => [
        if (data is List)
          for (final e in data)
            if (e is Map) Map<String, dynamic>.from(e),
      ];

  Future<List<Map<String, dynamic>>> list() => _run(() async {
        final res = await _dio.get<Object>(ApiConstants.receiptLayouts);
        return _list(res.data);
      });

  /// The designs the server offers (paper options and default config).
  Future<List<Map<String, dynamic>>> designs() => _run(() async {
        final res = await _dio.get<Object>(ApiConstants.receiptLayoutDesigns);
        final data = res.data;
        return data is Map ? _list(data['designs']) : _list(data);
      });

  Future<Map<String, dynamic>> create({
    required String name,
    required String design,
    String? paper,
    Map<String, Object?>? config,
  }) =>
      _run(() async {
        final res = await _dio.post<Object>(
          ApiConstants.receiptLayouts,
          data: {
            'name': name,
            'design': design,
            if (paper != null) 'paper': paper,
            if (config != null) 'config': config,
          },
        );
        return _map(res.data);
      });

  Future<Map<String, dynamic>> update(
    String id, {
    String? name,
    String? paper,
    Map<String, Object?>? config,
    bool? isActive,
  }) =>
      _run(() async {
        final res = await _dio.put<Object>(
          ApiConstants.receiptLayoutById(id),
          data: {
            if (name != null) 'name': name,
            if (paper != null) 'paper': paper,
            if (config != null) 'config': config,
            if (isActive != null) 'is_active': isActive,
          },
        );
        return _map(res.data);
      });

  Future<void> delete(String id) => _run(() async {
        await _dio.delete<Object>(ApiConstants.receiptLayoutById(id));
      });

  Future<Map<String, dynamic>> duplicate(String id, {String? name}) => _run(() async {
        final res = await _dio.post<Object>(
          ApiConstants.receiptLayoutDuplicate(id),
          data: {if (name != null) 'name': name},
        );
        return _map(res.data);
      });

  Future<List<Map<String, dynamic>>> assignments() => _run(() async {
        final res = await _dio.get<Object>(ApiConstants.receiptLayoutAssignments);
        return _list(res.data);
      });

  /// Upserts assignments; `layout_id: null` removes a branch override.
  Future<List<Map<String, dynamic>>> putAssignments(
    List<Map<String, Object?>> assignments,
  ) =>
      _run(() async {
        final res = await _dio.put<Object>(
          ApiConstants.receiptLayoutAssignments,
          data: {'assignments': assignments},
        );
        final data = res.data;
        return data is Map ? _list(data['assignments']) : _list(data);
      });
}

/// Dio client for `/devices` (owner only): the register code of each device.
class DevicesApi {
  DevicesApi(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> list() async {
    try {
      final res = await _dio.get<Object>(ApiConstants.devices);
      final data = res.data;
      return [
        if (data is List)
          for (final e in data)
            if (e is Map) Map<String, dynamic>.from(e),
      ];
    } catch (e) {
      throw ReceiptApiException.from(e);
    }
  }

  Future<Map<String, dynamic>> setShortCode(String deviceId, String code) async {
    try {
      final res = await _dio.put<Object>(
        ApiConstants.deviceById(deviceId),
        data: {'short_code': code},
      );
      final data = res.data;
      return data is Map ? Map<String, dynamic>.from(data) : const {};
    } catch (e) {
      throw ReceiptApiException.from(e);
    }
  }
}
