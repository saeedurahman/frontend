import 'package:dio/dio.dart';

/// Adds `X-Device-ID` and `X-App-Version` to every authenticated request
/// (backend README: devices register on first pull/push; the header is the
/// alternative to the `device_id` query parameter).
class DeviceHeaderInterceptor extends Interceptor {
  DeviceHeaderInterceptor({
    required Future<String> Function() deviceId,
    required this.appVersion,
  }) : _deviceId = deviceId;

  final Future<String> Function() _deviceId;
  final String appVersion;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.headers['X-Device-ID'] = await _deviceId();
    } catch (_) {
      // Never block a request over a missing device id.
    }
    options.headers['X-App-Version'] = appVersion;
    handler.next(options);
  }
}
