import 'package:equatable/equatable.dart';

/// Wire shapes of the offline sync API (backend README, "Offline sync").

class SyncChange extends Equatable {
  const SyncChange({
    required this.entity,
    required this.id,
    required this.op,
    required this.seq,
    this.data,
  });

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
        entity: json['entity'] as String,
        id: json['id'].toString(),
        op: json['op'] as String,
        seq: (json['seq'] as num?)?.toInt() ?? 0,
        data: json['data'] == null
            ? null
            : Map<String, dynamic>.from(json['data'] as Map),
      );

  final String entity;
  final String id;

  /// `upsert` or `delete`.
  final String op;
  final int seq;
  final Map<String, dynamic>? data;

  bool get isDelete => op == 'delete';

  Map<String, dynamic> toJson() =>
      {'entity': entity, 'id': id, 'op': op, 'seq': seq, 'data': data};

  @override
  List<Object?> get props => [entity, id, op, seq, data];
}

List<SyncChange> _changes(dynamic raw) => [
      for (final c in (raw as List? ?? const []))
        SyncChange.fromJson(Map<String, dynamic>.from(c as Map)),
    ];

class PullPage {
  const PullPage({
    required this.changes,
    required this.nextCursor,
    required this.hasMore,
    required this.permissionsVersion,
    this.fullResyncRequired = false,
    this.fullResyncReason,
    this.restricted = false,
    this.entities = const [],
    this.serverTime,
  });

  factory PullPage.fromJson(Map<String, dynamic> json) => PullPage(
        changes: _changes(json['changes']),
        nextCursor: json['next_cursor'] as String?,
        hasMore: json['has_more'] == true,
        permissionsVersion: json['permissions_version']?.toString() ?? '',
        fullResyncRequired: json['full_resync_required'] == true,
        fullResyncReason: json['full_resync_reason'] as String?,
        restricted: json['restricted'] == true,
        entities: [for (final e in (json['entities'] as List? ?? const [])) '$e'],
        serverTime: DateTime.tryParse('${json['server_time']}'),
      );

  final List<SyncChange> changes;
  final String? nextCursor;
  final bool hasMore;
  final String permissionsVersion;
  final bool fullResyncRequired;
  final String? fullResyncReason;
  final bool restricted;
  final List<String> entities;
  final DateTime? serverTime;
}

class SnapshotPage {
  const SnapshotPage({
    required this.changes,
    required this.nextPageToken,
    required this.hasMore,
    required this.cursor,
    required this.permissionsVersion,
    this.restricted = false,
    this.entities = const [],
  });

  factory SnapshotPage.fromJson(Map<String, dynamic> json) => SnapshotPage(
        changes: _changes(json['changes']),
        nextPageToken: json['next_page_token'] as String?,
        hasMore: json['has_more'] == true,
        cursor: json['cursor'] as String? ?? '',
        permissionsVersion: json['permissions_version']?.toString() ?? '',
        restricted: json['restricted'] == true,
        entities: [for (final e in (json['entities'] as List? ?? const [])) '$e'],
      );

  final List<SyncChange> changes;
  final String? nextPageToken;
  final bool hasMore;
  final String cursor;
  final String permissionsVersion;
  final bool restricted;
  final List<String> entities;
}

class OpError extends Equatable {
  const OpError({required this.code, required this.message, this.retryable = false});

  factory OpError.fromJson(Map<String, dynamic> json) => OpError(
        code: '${json['code']}',
        message: '${json['message'] ?? ''}',
        retryable: json['retryable'] == true,
      );

  final String code;
  final String message;
  final bool retryable;

  @override
  List<Object?> get props => [code, message, retryable];
}

class OpResult {
  const OpResult({
    required this.opId,
    required this.status,
    this.serverId,
    this.officialNumber,
    this.flags = const [],
    this.error,
    this.originalStatus,
  });

  factory OpResult.fromJson(Map<String, dynamic> json) => OpResult(
        opId: '${json['op_id']}',
        status: '${json['status']}',
        serverId: json['server_id']?.toString(),
        officialNumber: json['official_number'] as String?,
        flags: [for (final f in (json['flags'] as List? ?? const [])) '$f'],
        error: json['error'] == null
            ? null
            : OpError.fromJson(Map<String, dynamic>.from(json['error'] as Map)),
        originalStatus: json['original_status'] as String?,
      );

  final String opId;

  /// applied | duplicate | rejected | conflict
  final String status;
  final String? serverId;
  final String? officialNumber;
  final List<String> flags;
  final OpError? error;
  final String? originalStatus;

  bool get isDone => status == 'applied' || status == 'duplicate';
}

class PushResponse {
  const PushResponse({required this.batchId, required this.results});

  factory PushResponse.fromJson(Map<String, dynamic> json) => PushResponse(
        batchId: '${json['batch_id']}',
        results: [
          for (final r in (json['results'] as List? ?? const []))
            OpResult.fromJson(Map<String, dynamic>.from(r as Map)),
        ],
      );

  final String batchId;
  final List<OpResult> results;
}

class FlaggedSale extends Equatable {
  const FlaggedSale({
    required this.id,
    required this.saleNumber,
    required this.flags,
    required this.totalAmount,
    required this.cashierName,
    this.clientReceiptNo,
    this.soldAt,
    this.status = '',
  });

  factory FlaggedSale.fromJson(Map<String, dynamic> json) => FlaggedSale(
        id: '${json['id']}',
        saleNumber: '${json['sale_number'] ?? ''}',
        clientReceiptNo: json['client_receipt_no'] as String?,
        flags: [for (final f in (json['flags'] as List? ?? const [])) '$f'],
        totalAmount: '${json['total_amount'] ?? '0'}',
        cashierName: '${json['cashier_name'] ?? ''}',
        soldAt: DateTime.tryParse('${json['sold_at']}'),
        status: '${json['status'] ?? ''}',
      );

  final String id;
  final String saleNumber;
  final String? clientReceiptNo;
  final List<String> flags;
  final String totalAmount;
  final String cashierName;
  final DateTime? soldAt;
  final String status;

  @override
  List<Object?> get props => [id, saleNumber, flags];
}

// ── whole-request errors ────────────────────────────────────────────────

class SyncApiException implements Exception {
  const SyncApiException(this.message, {this.code, this.statusCode});
  final String message;
  final String? code;
  final int? statusCode;

  @override
  String toString() => 'SyncApiException($statusCode $code: $message)';
}

/// 403 device_revoked.
class DeviceRevokedException extends SyncApiException {
  const DeviceRevokedException(String message)
      : super(message, code: 'device_revoked', statusCode: 403);
}

/// 413 batch_too_large.
class BatchTooLargeException extends SyncApiException {
  const BatchTooLargeException(String message)
      : super(message, code: 'batch_too_large', statusCode: 413);
}

/// 429.
class RateLimitedException extends SyncApiException {
  const RateLimitedException(this.retryAfter)
      : super('Too many requests', statusCode: 429);
  final Duration retryAfter;
}

/// 400 invalid_cursor.
class InvalidCursorException extends SyncApiException {
  const InvalidCursorException(String message)
      : super(message, code: 'invalid_cursor', statusCode: 400);
}

/// No answer from the server at all (offline, timeout, DNS ...).
class SyncUnreachableException extends SyncApiException {
  const SyncUnreachableException(String message) : super(message);
}

/// 5xx or any other unexpected answer: keep everything pending.
class SyncServerException extends SyncApiException {
  const SyncServerException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

/// Transport for the sync endpoints (the real one is [HttpSyncApi]).
abstract class SyncApi {
  Future<PullPage> pull({String? since, int limit = 500, String? branchId});

  Future<SnapshotPage> snapshot({String? pageToken, int limit = 500});

  Future<PushResponse> push({
    required String batchId,
    required List<Map<String, dynamic>> ops,
  });

  Future<List<FlaggedSale>> flags({String? flag, int skip = 0, int limit = 100});
}
