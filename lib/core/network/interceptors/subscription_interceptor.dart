import 'package:dio/dio.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/interceptors/auth_interceptor.dart';

/// Turns HTTP 402 into a [SubscriptionFailure] and reports it.
///
/// A 402 means the business's subscription does not allow the request. The
/// session itself is fine, so this never touches tokens and never triggers a
/// refresh (that is [AuthInterceptor]'s job, and it only reacts to 401).
class SubscriptionInterceptor extends Interceptor {
  SubscriptionInterceptor({required this.onFailure});

  final void Function(SubscriptionFailure failure) onFailure;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final isPaymentRequired = err.response?.statusCode == 402;
    if (!isPaymentRequired) return handler.next(err);

    final failure = SubscriptionFailure.fromBody(err.response?.data);
    // A rejected login says nothing about the session already on screen.
    if (!AuthInterceptor.isAuthExchangePath(err.requestOptions.path)) {
      onFailure(failure);
    }
    handler.next(err.copyWith(error: failure));
  }
}
