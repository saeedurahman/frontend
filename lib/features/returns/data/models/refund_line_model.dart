import 'package:decimal/decimal.dart';

/// Local refund allocation line for building the return request.
class RefundLineModel {
  const RefundLineModel({
    required this.paymentMethod,
    required this.amount,
    this.label,
    this.walletLabel,
  });

  final String paymentMethod;
  final Decimal amount;
  final String? label;
  final String? walletLabel;

  RefundLineModel copyWith({
    String? paymentMethod,
    Decimal? amount,
    String? label,
    String? walletLabel,
  }) {
    return RefundLineModel(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      label: label ?? this.label,
      walletLabel: walletLabel ?? this.walletLabel,
    );
  }
}
