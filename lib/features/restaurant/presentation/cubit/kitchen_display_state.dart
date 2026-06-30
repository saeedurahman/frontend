import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';

enum KitchenDisplayStatus { initial, loading, loaded, error }

class KitchenDisplayState {
  const KitchenDisplayState({
    this.status = KitchenDisplayStatus.initial,
    this.tickets = const [],
    this.isRefreshing = false,
    this.accessDenied = false,
    this.isUpdatingStatus = false,
    this.updatingTicketId,
    this.errorMessage,
    this.lastRefreshedAt,
  });

  final KitchenDisplayStatus status;
  final List<KotOrderModel> tickets;
  final bool isRefreshing;
  final bool accessDenied;
  final bool isUpdatingStatus;
  final String? updatingTicketId;
  final String? errorMessage;
  final DateTime? lastRefreshedAt;

  List<KotOrderModel> ticketsForColumn(String status) =>
      tickets.where((ticket) => ticket.status == status).toList();

  KitchenDisplayState copyWith({
    KitchenDisplayStatus? status,
    List<KotOrderModel>? tickets,
    bool? isRefreshing,
    bool? accessDenied,
    bool? isUpdatingStatus,
    String? updatingTicketId,
    String? errorMessage,
    DateTime? lastRefreshedAt,
  }) {
    return KitchenDisplayState(
      status: status ?? this.status,
      tickets: tickets ?? this.tickets,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      accessDenied: accessDenied ?? this.accessDenied,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
      updatingTicketId: updatingTicketId ?? this.updatingTicketId,
      errorMessage: errorMessage,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
    );
  }
}
