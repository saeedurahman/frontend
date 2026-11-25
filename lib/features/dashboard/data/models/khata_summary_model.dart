import 'package:decimal/decimal.dart';

/// `GET /analytics/khata-summary`: what customers owe the shop (receivable),
/// what the shop owes suppliers (payable) and the biggest debtors.
class KhataSummaryModel {
  const KhataSummaryModel({
    required this.receivable,
    required this.payable,
    this.branchId,
    this.topDebtors = const [],
  });

  factory KhataSummaryModel.fromJson(Map<String, dynamic> json) {
    Decimal money(Object? v) => Decimal.tryParse('${v ?? 0}') ?? Decimal.zero;
    final raw = json['top_debtors'];
    return KhataSummaryModel(
      receivable: money(json['receivable']),
      payable: money(json['payable']),
      branchId: json['branch_id']?.toString(),
      topDebtors: raw is List
          ? raw
              .whereType<Map<dynamic, dynamic>>()
              .map((e) => TopDebtorModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }

  final Decimal receivable;
  final Decimal payable;
  final String? branchId;
  final List<TopDebtorModel> topDebtors;
}

class TopDebtorModel {
  const TopDebtorModel({
    required this.customerId,
    required this.name,
    required this.balanceOwed,
    this.phone,
  });

  factory TopDebtorModel.fromJson(Map<String, dynamic> json) => TopDebtorModel(
        customerId: '${json['customer_id']}',
        name: '${json['customer_name'] ?? ''}',
        phone: json['phone']?.toString(),
        balanceOwed:
            Decimal.tryParse('${json['balance_owed'] ?? 0}') ?? Decimal.zero,
      );

  final String customerId;
  final String name;
  final String? phone;
  final Decimal balanceOwed;
}
