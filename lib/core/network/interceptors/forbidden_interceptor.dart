import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';

/// Reports HTTP 403 so the app can re-read the user's permissions (they may
/// have been changed by an admin). It never alters the response.
class ForbiddenInterceptor extends Interceptor {
  ForbiddenInterceptor({required this.onForbidden});

  final void Function(RequestOptions request) onForbidden;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403 && _shouldReport(err.requestOptions)) {
      onForbidden(err.requestOptions);
    }
    handler.next(err);
  }

  /// `/auth/me` is the refresh itself; credential endpoints are not about
  /// permissions.
  static bool _shouldReport(RequestOptions request) {
    if (AuthInterceptor.isAuthExchangePath(request.path)) return false;
    return !request.path.endsWith(ApiConstants.me);
  }
}
