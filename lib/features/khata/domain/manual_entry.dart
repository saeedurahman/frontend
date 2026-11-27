/// Money written into an account without a sale, a purchase or a payment.
library;

import 'package:frantend/features/khata/data/khata_remote_datasource.dart'
    show khataIsoDay;
import 'package:frantend/features/khata/domain/khata_amount.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

/// Which way an opening balance points.
enum OpeningDirection {
  theyOweUs('they_owe_us'),
  weOweThem('we_owe_them');

  const OpeningDirection(this.apiValue);

  final String apiValue;

  /// What a new account usually starts with.
  static OpeningDirection defaultFor(PartyType type) =>
      type.isCustomer ? theyOweUs : weOweThem;
}

/// An opening balance as it is being typed.
class OpeningBalanceDraft {
  const OpeningBalanceDraft({
    this.amountText = '',
    required this.direction,
    required this.date,
  });

  factory OpeningBalanceDraft.empty(PartyType type, DateTime today) =>
      OpeningBalanceDraft(
        direction: OpeningDirection.defaultFor(type),
        date: DateTime(today.year, today.month, today.day),
      );

  final String amountText;
  final OpeningDirection direction;

  /// "As of": the balance was true at the start of this day.
  final DateTime date;

  /// Nothing typed: the account simply starts at zero.
  bool get isFilled => amountText.trim().isNotEmpty;

  /// Two-decimal amount, or null when it is not a positive number.
  String? get amount => KhataAmount.parse(amountText);

  OpeningBalanceDraft copyWith({
    String? amountText,
    OpeningDirection? direction,
    DateTime? date,
  }) =>
      OpeningBalanceDraft(
        amountText: amountText ?? this.amountText,
        direction: direction ?? this.direction,
        date: date ?? this.date,
      );

  /// The server's `opening_balance` object. Only valid when [amount] is set.
  Map<String, dynamic> toJson({String? branchId}) => {
        'amount': amount,
        'direction': direction.apiValue,
        'as_of_date': khataIsoDay(date),
        if (branchId != null) 'branch_id': branchId,
      };
}

/// The manual entries the server accepts.
enum ManualKind {
  udhaarGiven('udhaar_given'),
  goodsOnCredit('goods_on_credit_manual'),
  adjustmentIncrease('adjustment_increase'),
  adjustmentDecrease('adjustment_decrease');

  const ManualKind(this.apiValue);

  final String apiValue;

  static ManualKind? parse(String? value) {
    for (final k in values) {
      if (k.apiValue == value) return k;
    }
    return null;
  }

  /// "Give udhaar" or "Goods on credit": money newly owed.
  static ManualKind newDebtFor(PartyType type) =>
      type.isCustomer ? udhaarGiven : goodsOnCredit;

  bool get isAdjustment =>
      this == adjustmentIncrease || this == adjustmentDecrease;

  /// Whether the amount owed on this account goes up.
  bool get addsToOwed => this != adjustmentDecrease;
}
