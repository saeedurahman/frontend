import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/notifications/data/models/paginated_notifications_model.dart';
import 'package:injectable/injectable.dart';

abstract class NotificationsRemoteDataSource {
  Future<PaginatedNotificationsModel> getNotifications({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  });

  Future<int> markRead(List<String> notificationIds);

  Future<int> markAllRead();

  Future<void> deleteNotification(String id);

  Future<({int lowStock, int expiry})> checkAlerts();
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<PaginatedNotificationsModel> getNotifications({
    bool? isRead,
    String? notificationType,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.notifications,
      queryParameters: {
        if (isRead != null) 'is_read': isRead,
        if (notificationType != null) 'notification_type': notificationType,
        'skip': skip,
        'limit': limit,
      },
    );
    return PaginatedNotificationsModel.fromJson(response.data ?? const {});
  }

  @override
  Future<int> markRead(List<String> notificationIds) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.notificationsMarkRead,
      data: {'notification_ids': notificationIds},
    );
    return (response.data?['updated'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<int> markAllRead() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.notificationsMarkAllRead,
    );
    return (response.data?['updated'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _dio.delete<void>(ApiConstants.notificationById(id));
  }

  @override
  Future<({int lowStock, int expiry})> checkAlerts() async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.notificationsCheckAlerts,
    );
    final data = response.data ?? const {};
    return (
      lowStock: (data['low_stock'] as num?)?.toInt() ?? 0,
      expiry: (data['expiry'] as num?)?.toInt() ?? 0,
    );
  }
}
