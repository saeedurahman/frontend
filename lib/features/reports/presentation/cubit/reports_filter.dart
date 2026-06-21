import 'package:frantend/features/reports/data/datasources/reports_remote_datasource.dart';

class ReportsFilter {
  const ReportsFilter({
    required this.dateFrom,
    required this.dateTo,
    this.branchId,
    this.presetLabel = 'Last 7 Days',
  });

  final DateTime dateFrom;
  final DateTime dateTo;
  final String? branchId;
  final String presetLabel;

  DateRangeQuery get query => (
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
      );

  ReportsFilter copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
    String? presetLabel,
    bool clearBranch = false,
  }) {
    return ReportsFilter(
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      branchId: clearBranch ? null : (branchId ?? this.branchId),
      presetLabel: presetLabel ?? this.presetLabel,
    );
  }

  static ReportsFilter last7Days({String? branchId}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return ReportsFilter(
      dateFrom: today.subtract(const Duration(days: 6)),
      dateTo: today,
      branchId: branchId,
    );
  }
}
