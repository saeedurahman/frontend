import 'package:decimal/decimal.dart';

class PaymentLineModel {
  const PaymentLineModel({
    required this.paymentMethod,
    required this.amount,
    this.referenceNo,
    this.walletLabel,
    this.tendered,
  });

  final String paymentMethod;
  final Decimal amount;
  final String? referenceNo;
  /// UI label for wallet sub-types (Easypaisa / JazzCash).
  final String? walletLabel;

  /// Cash handed over by the customer; [amount] is the part applied to the
  /// sale, so `tendered - amount` is the change. Null for non-cash lines.
  final Decimal? tendered;

  Decimal get change {
    final t = tendered;
    if (t == null || t <= amount) return Decimal.zero;
    return t - amount;
  }

  PaymentLineModel copyWith({
    String? paymentMethod,
    Decimal? amount,
    String? referenceNo,
    String? walletLabel,
    Decimal? tendered,
  }) {
    return PaymentLineModel(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      referenceNo: referenceNo ?? this.referenceNo,
      walletLabel: walletLabel ?? this.walletLabel,
      tendered: tendered ?? this.tendered,
    );
  }
}

/// Payment method constants matching backend PaymentMethodEnum.
abstract final class PaymentMethods {
  static const cash = 'cash';
  static const card = 'card';
  static const upi = 'upi';
  static const bankTransfer = 'bank_transfer';
  static const wallet = 'wallet';
  static const credit = 'credit';
  static const cheque = 'cheque';
  static const other = 'other';
}
