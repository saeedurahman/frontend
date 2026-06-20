import 'package:decimal/decimal.dart';

class PaymentLineModel {
  const PaymentLineModel({
    required this.paymentMethod,
    required this.amount,
    this.referenceNo,
    this.walletLabel,
  });

  final String paymentMethod;
  final Decimal amount;
  final String? referenceNo;
  /// UI label for wallet sub-types (Easypaisa / JazzCash).
  final String? walletLabel;

  PaymentLineModel copyWith({
    String? paymentMethod,
    Decimal? amount,
    String? referenceNo,
    String? walletLabel,
  }) {
    return PaymentLineModel(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      referenceNo: referenceNo ?? this.referenceNo,
      walletLabel: walletLabel ?? this.walletLabel,
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
