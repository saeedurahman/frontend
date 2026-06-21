Map<String, dynamic>? _jsonMap(dynamic raw) {
  if (raw == null) return null;
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

DateTime _parseDateTime(dynamic raw) {
  if (raw == null) return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  if (raw is DateTime) return raw.toUtc();
  return DateTime.tryParse(raw.toString())?.toUtc() ??
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

class AuditLogModel {
  const AuditLogModel({
    required this.id,
    required this.businessId,
    this.userId,
    this.userName,
    required this.action,
    required this.tableName,
    required this.recordId,
    this.oldValues,
    this.newValues,
    this.ipAddress,
    this.userAgent,
    this.localId,
    this.serverId,
    required this.syncStatus,
    required this.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
        id: json['id']?.toString() ?? '',
        businessId: json['business_id']?.toString() ?? '',
        userId: json['user_id']?.toString(),
        userName: json['user_name']?.toString(),
        action: json['action']?.toString() ?? '',
        tableName: json['table_name']?.toString() ?? '',
        recordId: json['record_id']?.toString() ?? '',
        oldValues: _jsonMap(json['old_values']),
        newValues: _jsonMap(json['new_values']),
        ipAddress: json['ip_address']?.toString(),
        userAgent: json['user_agent']?.toString(),
        localId: json['local_id']?.toString(),
        serverId: json['server_id']?.toString(),
        syncStatus: json['sync_status']?.toString() ?? '',
        createdAt: _parseDateTime(json['created_at']),
      );

  final String id;
  final String businessId;
  final String? userId;
  final String? userName;
  final String action;
  final String tableName;
  final String recordId;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String? ipAddress;
  final String? userAgent;
  final String? localId;
  final String? serverId;
  final String syncStatus;
  final DateTime createdAt;

  bool get hasValueDiff {
    final oldEmpty = oldValues == null || oldValues!.isEmpty;
    final newEmpty = newValues == null || newValues!.isEmpty;
    return !oldEmpty || !newEmpty;
  }

  String get shortRecordId =>
      recordId.length > 8 ? recordId.substring(0, 8) : recordId;
}
