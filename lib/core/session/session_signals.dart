import 'package:dio/dio.dart';
import 'package:frantend/core/error/failures.dart';

/// Lets the HTTP layer report session-level events (402, 403) without
/// knowing about cubits or DI. [SessionServices] connects the handlers.
abstract final class SessionSignals {
  static void Function(SubscriptionFailure failure)? onSubscriptionFailure;
  static void Function(RequestOptions request)? onForbiddenRequest;

  static void subscriptionFailure(SubscriptionFailure failure) =>
      onSubscriptionFailure?.call(failure);

  static void forbidden(RequestOptions request) =>
      onForbiddenRequest?.call(request);
}
