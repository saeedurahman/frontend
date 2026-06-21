import 'package:equatable/equatable.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';

enum AuditDatePreset { today, last7Days, last30Days, custom }

class AuditLogsFilters extends Equatable {
  const AuditLogsFilters({
    this.userId,
    this.action,
    this.tableName,
    this.dateFrom,
    this.dateTo,
    this.datePreset = AuditDatePreset.last7Days,
  });

  final String? userId;
  final String? action;
  final String? tableName;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final AuditDatePreset datePreset;

  AuditLogsFilters copyWith({
    String? userId,
    String? action,
    String? tableName,
    DateTime? dateFrom,
    DateTime? dateTo,
    AuditDatePreset? datePreset,
    bool clearUserId = false,
    bool clearAction = false,
    bool clearTableName = false,
    bool clearDates = false,
  }) {
    return AuditLogsFilters(
      userId: clearUserId ? null : (userId ?? this.userId),
      action: clearAction ? null : (action ?? this.action),
      tableName: clearTableName ? null : (tableName ?? this.tableName),
      dateFrom: clearDates ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDates ? null : (dateTo ?? this.dateTo),
      datePreset: datePreset ?? this.datePreset,
    );
  }

  bool get hasActiveFilters =>
      userId != null ||
      action != null ||
      tableName != null ||
      dateFrom != null ||
      dateTo != null;

  @override
  List<Object?> get props =>
      [userId, action, tableName, dateFrom, dateTo, datePreset];
}

sealed class AuditLogsState extends Equatable {
  const AuditLogsState();
}

class AuditLogsInitial extends AuditLogsState {
  const AuditLogsInitial();
  @override
  List<Object?> get props => [];
}

class AuditLogsAccessDenied extends AuditLogsState {
  const AuditLogsAccessDenied();
  @override
  List<Object?> get props => [];
}

class AuditLogsLoading extends AuditLogsState {
  const AuditLogsLoading({this.filters = const AuditLogsFilters()});

  final AuditLogsFilters filters;
  @override
  List<Object?> get props => [filters];
}

class AuditLogsLoaded extends AuditLogsState {
  const AuditLogsLoaded({
    required this.logs,
    required this.total,
    required this.skip,
    required this.limit,
    required this.filters,
    this.isLoadingMore = false,
  });

  final List<AuditLogModel> logs;
  final int total;
  final int skip;
  final int limit;
  final AuditLogsFilters filters;
  final bool isLoadingMore;

  bool get hasMore => skip + logs.length < total;

  AuditLogsLoaded copyWith({
    List<AuditLogModel>? logs,
    int? total,
    int? skip,
    int? limit,
    AuditLogsFilters? filters,
    bool? isLoadingMore,
  }) {
    return AuditLogsLoaded(
      logs: logs ?? this.logs,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [logs, total, skip, limit, filters, isLoadingMore];
}

class AuditLogsError extends AuditLogsState {
  const AuditLogsError(this.message, {this.filters = const AuditLogsFilters()});

  final String message;
  final AuditLogsFilters filters;
  @override
  List<Object?> get props => [message, filters];
}
