import 'package:equatable/equatable.dart';
import 'package:frantend/features/audit/data/models/audit_log_model.dart';

sealed class RecordHistoryState extends Equatable {
  const RecordHistoryState();
}

class RecordHistoryInitial extends RecordHistoryState {
  const RecordHistoryInitial();
  @override
  List<Object?> get props => [];
}

class RecordHistoryLoading extends RecordHistoryState {
  const RecordHistoryLoading();
  @override
  List<Object?> get props => [];
}

class RecordHistoryLoaded extends RecordHistoryState {
  const RecordHistoryLoaded({
    required this.logs,
    required this.total,
    required this.skip,
    required this.limit,
    this.isLoadingMore = false,
  });

  final List<AuditLogModel> logs;
  final int total;
  final int skip;
  final int limit;
  final bool isLoadingMore;

  bool get hasMore => skip + logs.length < total;

  @override
  List<Object?> get props => [logs, total, skip, limit, isLoadingMore];
}

class RecordHistoryError extends RecordHistoryState {
  const RecordHistoryError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class RecordHistoryAccessDenied extends RecordHistoryState {
  const RecordHistoryAccessDenied();
  @override
  List<Object?> get props => [];
}
