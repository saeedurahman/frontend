import 'package:dio/dio.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';

/// The two Quick Add endpoints. Throws [DioException] on any failure; the
/// repository turns that into a plain-words failure.
class QuickAddRemoteDataSource {
  QuickAddRemoteDataSource(this._client);

  final DioClient _client;

  static const lookupPath = '/products/lookup';
  static const quickAddPath = '/products/quick-add';

  /// A save of up to 300 lines can take a while on a slow server; the cashier
  /// is not waiting at the counter here, so the long timeout is fine.
  static const saveTimeout = Duration(seconds: 60);

  /// `GET /products/lookup?barcode=...`. Never retried (a slow lookup must not
  /// stack up behind the next scan) and capped at [timeout].
  Future<ProductLookup> lookup(
    String barcode, {
    Duration timeout = const Duration(milliseconds: 1500),
  }) async {
    final response = await _client.dio.get<dynamic>(
      lookupPath,
      queryParameters: {'barcode': barcode},
      options: Options(
        sendTimeout: timeout,
        receiveTimeout: timeout,
        extra: const {'no_retry': true},
      ),
    );
    final data = response.data;
    if (data is! Map) return ProductLookup.notFound;
    return ProductLookup.fromJson(Map<String, dynamic>.from(data));
  }

  /// `POST /products/quick-add`. [idempotencyKey] is sent as given, so a retry
  /// of the same body replays the server's stored answer instead of booking
  /// the stock twice.
  Future<QuickAddResponse> submit(
    QuickAddRequest request, {
    required String idempotencyKey,
  }) async {
    final response = await _client.dio.post<dynamic>(
      quickAddPath,
      data: request.toJson(),
      options: Options(
        sendTimeout: saveTimeout,
        receiveTimeout: saveTimeout,
        headers: {'Idempotency-Key': idempotencyKey},
      ),
    );
    final data = response.data;
    if (data is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Unexpected answer from the server',
      );
    }
    final replayed =
        response.headers.value('idempotent-replay')?.toLowerCase() == 'true';
    return QuickAddResponse.fromJson(Map<String, dynamic>.from(data), replayed: replayed);
  }
}
