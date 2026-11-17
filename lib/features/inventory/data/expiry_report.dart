import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart' show ReceiptApiException;

/// One batch of one product in the expiry report.
class ExpiryRow {
  const ExpiryRow({
    required this.product,
    required this.variation,
    required this.sku,
    required this.branch,
    required this.batchNo,
    required this.expiryDate,
    required this.daysToExpiry,
    required this.qty,
    required this.costPerUnit,
    required this.value,
  });

  final String product;
  final String? variation;
  final String? sku;
  final String? branch;
  final String? batchNo;
  final String expiryDate;

  /// Negative once expired.
  final int daysToExpiry;
  final String qty;
  final String costPerUnit;
  final String value;

  bool get expired => daysToExpiry < 0;

  factory ExpiryRow.fromJson(Map<String, dynamic> j) => ExpiryRow(
        product: '${j['product'] ?? ''}',
        variation: j['variation'] == null ? null : '${j['variation']}',
        sku: j['sku'] == null ? null : '${j['sku']}',
        branch: j['branch'] == null ? null : '${j['branch']}',
        batchNo: j['batch_no'] == null ? null : '${j['batch_no']}',
        expiryDate: '${j['expiry_date'] ?? ''}',
        daysToExpiry: int.tryParse('${j['days_to_expiry']}') ?? 0,
        qty: '${j['qty'] ?? '0'}',
        costPerUnit: '${j['cost_per_unit'] ?? '0'}',
        value: '${j['value'] ?? '0'}',
      );
}

class ExpiryTotals {
  const ExpiryTotals({
    this.expiredQty = '0',
    this.expiredValue = '0',
    this.nearExpiryQty = '0',
    this.nearExpiryValue = '0',
  });

  final String expiredQty;
  final String expiredValue;
  final String nearExpiryQty;
  final String nearExpiryValue;
}

/// `GET /stock/expiry-report`.
class ExpiryReport {
  const ExpiryReport({
    required this.asOf,
    required this.withinDays,
    required this.expired,
    required this.nearExpiry,
    required this.totals,
  });

  final String asOf;
  final int withinDays;
  final List<ExpiryRow> expired;
  final List<ExpiryRow> nearExpiry;
  final ExpiryTotals totals;

  bool get isEmpty => expired.isEmpty && nearExpiry.isEmpty;

  factory ExpiryReport.fromJson(Map<String, dynamic> j) {
    List<ExpiryRow> rows(Object? v) => [
          if (v is List)
            for (final e in v)
              if (e is Map) ExpiryRow.fromJson(Map<String, dynamic>.from(e)),
        ];
    final t = j['totals'] is Map ? Map<String, dynamic>.from(j['totals'] as Map) : const {};
    return ExpiryReport(
      asOf: '${j['as_of'] ?? ''}',
      withinDays: int.tryParse('${j['within_days']}') ?? 30,
      expired: rows(j['expired']),
      nearExpiry: rows(j['near_expiry']),
      totals: ExpiryTotals(
        expiredQty: '${t['expired_qty'] ?? '0'}',
        expiredValue: '${t['expired_value'] ?? '0'}',
        nearExpiryQty: '${t['near_expiry_qty'] ?? '0'}',
        nearExpiryValue: '${t['near_expiry_value'] ?? '0'}',
      ),
    );
  }
}

typedef ExpiryReportLoader = Future<ExpiryReport> Function({
  required int withinDays,
  String? branchId,
});

class ExpiryReportApi {
  ExpiryReportApi(this._dio);

  final Dio _dio;

  Future<ExpiryReport> load({required int withinDays, String? branchId}) async {
    try {
      final res = await _dio.get<Object>(
        ApiConstants.stockExpiryReport,
        queryParameters: {
          'within_days': withinDays,
          if (branchId != null && branchId.isNotEmpty) 'branch_id': branchId,
        },
      );
      final data = res.data;
      if (data is! Map) throw const ReceiptApiException(UserErrorMessage.generic);
      return ExpiryReport.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw ReceiptApiException.from(e);
    }
  }
}
