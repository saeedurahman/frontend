import 'package:decimal/decimal.dart';

import 'quick_add_row.dart';
import 'quick_add_settings.dart';

/// What the stock added by the scan is booked as.
enum QuickAddMode {
  /// Stock you already have on the shelf ("Opening stock").
  openingStock,

  /// Stock bought from a supplier: a purchase order + goods receipt, and the
  /// supplier's account is credited.
  purchase;

  /// The API's `mode` value.
  String get apiValue => this == openingStock ? 'opening_stock' : 'purchase';

  static QuickAddMode fromApi(Object? v) =>
      v == 'purchase' ? QuickAddMode.purchase : QuickAddMode.openingStock;
}

/// The Enter-key order of the cells after a scan, and the checks that run
/// before Save. Pure: unit tested without widgets.
abstract final class QuickAddFlow {
  /// Does this row need a batch / expiry typed (or scanned)?
  static bool needsBatchExpiry(QuickAddRow row) =>
      row.trackExpiry && row.qty > Decimal.zero;

  /// The cells Enter walks through for [row], in order. Empty = nothing to
  /// type: the focus goes straight back to the scan field.
  static List<QuickAddField> steps(
    QuickAddRow row,
    QuickAddSettings settings,
    QuickAddMode mode,
  ) {
    final out = <QuickAddField>[];
    if (!row.isKnown && !row.hasName) out.add(QuickAddField.name);
    if (settings.askCost) {
      final costMissing = row.cost == null || row.cost! <= Decimal.zero;
      // A new product needs a cost; a known one only when the cost is unknown
      // or the stock is bought from a supplier (the price paid changes).
      if (!row.isKnown || costMissing || mode == QuickAddMode.purchase) {
        out.add(QuickAddField.cost);
      }
    }
    if (!row.isKnown) out.add(QuickAddField.salePrice);
    if (needsBatchExpiry(row)) {
      if (row.batchNo.trim().isEmpty) out.add(QuickAddField.batch);
      if (row.expiry == null) out.add(QuickAddField.expiry);
    }
    return out;
  }

  /// Where Enter goes after [from]: the next step, or null for "the scan field".
  static QuickAddField? nextAfter(
    QuickAddRow row,
    QuickAddField from,
    QuickAddSettings settings,
    QuickAddMode mode,
  ) {
    // The step the user just finished may no longer be a step (the cost they
    // typed made it complete), so walk the canonical order instead.
    const order = [
      QuickAddField.name,
      QuickAddField.cost,
      QuickAddField.salePrice,
      QuickAddField.batch,
      QuickAddField.expiry,
    ];
    final pending = steps(row, settings, mode).toSet();
    final at = order.indexOf(from);
    if (at < 0) return null;
    for (var i = at + 1; i < order.length; i++) {
      if (pending.contains(order[i])) return order[i];
    }
    return null;
  }

  /// First cell to focus after a scan created or loaded [row]; null keeps the
  /// focus in the scan field.
  static QuickAddField? firstStop(
    QuickAddRow row,
    QuickAddSettings settings,
    QuickAddMode mode,
  ) {
    final s = steps(row, settings, mode);
    return s.isEmpty ? null : s.first;
  }
}

/// Checks one row before Save. Messages are plain words for shop owners.
abstract final class QuickAddValidator {
  static Map<QuickAddField, String> validate(
    QuickAddRow row, {
    required QuickAddSettings settings,
    required QuickAddMode mode,
    DateTime? now,
  }) {
    final errors = <QuickAddField, String>{};
    final today = now ?? DateTime.now();
    final day = DateTime(today.year, today.month, today.day);

    if (row.barcode.trim().isEmpty) {
      errors[QuickAddField.barcode] = 'The barcode is empty';
    }
    if (!row.isKnown && !row.hasName) {
      errors[QuickAddField.name] = 'Type a name for this item';
    }
    if (row.qty < Decimal.zero) {
      errors[QuickAddField.qty] = 'Quantity cannot be less than 0';
    }
    final cost = row.cost;
    if (cost != null && cost < Decimal.zero) {
      errors[QuickAddField.cost] = 'Cost cannot be less than 0';
    } else if (mode == QuickAddMode.purchase &&
        row.qty > Decimal.zero &&
        (cost == null || cost <= Decimal.zero)) {
      errors[QuickAddField.cost] = 'Type what you paid, the supplier bill needs it';
    }
    final price = row.salePrice;
    if (price != null && price < Decimal.zero) {
      errors[QuickAddField.salePrice] = 'Sale price cannot be less than 0';
    }
    if (QuickAddFlow.needsBatchExpiry(row)) {
      final expiry = row.expiry;
      if (expiry == null) {
        errors[QuickAddField.expiry] = 'Type the expiry date';
      } else if (expiry.isBefore(day)) {
        errors[QuickAddField.expiry] = 'This expiry date has already passed';
      }
    }
    if (settings.requireBatch && row.qty > Decimal.zero && row.batchNo.trim().isEmpty) {
      errors[QuickAddField.batch] = 'Type the batch number';
    }
    return errors;
  }
}
