class SalesTrendPointModel {
  const SalesTrendPointModel({
    required this.label,
    required this.revenue,
    required this.profit,
  });

  factory SalesTrendPointModel.fromJson(Map<String, dynamic> json) {
    return SalesTrendPointModel(
      label: json['label']?.toString() ??
          json['date']?.toString() ??
          json['period']?.toString() ??
          '-',
      revenue: _toDouble(json['revenue']),
      profit: _toDouble(json['profit']),
    );
  }

  final String label;
  final double revenue;
  final double profit;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
