import 'package:frantend/features/audit/data/models/audit_log_model.dart';

class PaginatedAuditLogsModel {
  const PaginatedAuditLogsModel({
    required this.total,
    required this.skip,
    required this.limit,
    required this.items,
  });

  factory PaginatedAuditLogsModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((e) => AuditLogModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <AuditLogModel>[];

    return PaginatedAuditLogsModel(
      total: (json['total'] as num?)?.toInt() ?? items.length,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
      items: items,
    );
  }

  final int total;
  final int skip;
  final int limit;
  final List<AuditLogModel> items;

  bool get hasMore => skip + items.length < total;
}
