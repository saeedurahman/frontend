import 'package:decimal/decimal.dart';

/// One supplier payment that came out of the cash drawer.
class DrawerPayment {
  const DrawerPayment({
    required this.id,
    required this.shiftId,
    required this.amount,
    this.supplierName,
    this.note,
  });

  /// The ledger entry id (a reversal removes the row by it).
  final String id;
  final String shiftId;
  final Decimal amount;
  final String? supplierName;
  final String? note;
}

/// Supplier payments taken from the drawer, per shift, as made on this device.
///
/// The server already counts them in "Cash out" and "Expected cash" (they are
/// `cash_out` register transactions); its shift summary only has totals, no
/// list. This log is what lets the shift screens say *what* the money was for.
/// Payments from bank, wallets or the owner's pocket are never recorded here,
/// so they can never appear as drawer cash.
class DrawerPaymentLog {
  final _byId = <String, DrawerPayment>{};

  void add(DrawerPayment payment) => _byId[payment.id] = payment;

  /// A reversed payment is no longer money that left the drawer.
  void remove(String id) => _byId.remove(id);

  List<DrawerPayment> forShift(String shiftId) => [
        for (final p in _byId.values)
          if (p.shiftId == shiftId) p,
      ];

  Decimal totalForShift(String shiftId) => forShift(shiftId)
      .fold(Decimal.zero, (sum, p) => sum + p.amount);
}
