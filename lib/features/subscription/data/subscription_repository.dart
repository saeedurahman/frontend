import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/subscription/data/subscription_status.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._dio, {this.onLease});

  final Dio _dio;

  /// Receives the signed offline lease that rides on the status response.
  final void Function(Object? lease)? onLease;

  /// Throws [SubscriptionFailure] on 402; any other error is rethrown.
  Future<SubscriptionStatus> fetchStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.subscriptionStatus,
      );
      onLease?.call(response.data?['lease']);
      return SubscriptionStatus.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      if (e.response?.statusCode == 402) {
        throw SubscriptionFailure.fromBody(e.response?.data);
      }
      rethrow;
    }
  }
}
