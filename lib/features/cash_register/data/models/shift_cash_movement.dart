import 'package:equatable/equatable.dart';

/// One non-sale drawer movement of a shift, as the server lists it in
/// `cash_movements[]` (oldest first). Sales and refunds are not in the list.
class ShiftCashMovement extends Equatable {
  const ShiftCashMovement({
    required this.id,
    required this.type,
    required this.amount,
    required this.source,
    this.partyType,
    this.partyId,
    this.partyName,
    this.reference,
    this.ledgerEntryId,
    this.time,
    this.reversed = false,
    this.notes,
  });

  factory ShiftCashMovement.fromJson(Map<String, dynamic> json) {
    String? text(String key) {
      final value = json[key]?.toString().trim();
      return value == null || value.isEmpty ? null : value;
    }

    return ShiftCashMovement(
      id: '${json['id']}',
      type: '${json['type']}',
      amount: '${json['amount'] ?? '0'}',
      source: '${json['source'] ?? 'manual'}',
      partyType: text('party_type'),
      partyId: text('party_id'),
      partyName: text('party_name'),
      reference: text('reference'),
      ledgerEntryId: text('ledger_entry_id'),
      time: text('time'),
      reversed: json['reversed'] == true,
      notes: text('notes'),
    );
  }

  /// The register transaction.
  final String id;

  /// `cash_in`, `cash_out` or `expense`.
  final String type;

  /// Always positive; [type] gives the direction.
  final String amount;

  /// `supplier_payment`, `supplier_payment_reversal`, `customer_payment`,
  /// `customer_payment_reversal`, `expense` or `manual`.
  final String source;

  final String? partyType;
  final String? partyId;
  final String? partyName;
  final String? reference;

  /// The payment row (a reversal is made with this id).
  final String? ledgerEntryId;
  final String? time;

  /// A payment that has since been reversed. The reversal is its own movement.
  final bool reversed;
  final String? notes;

  bool get intoDrawer => type == 'cash_in';

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'source': source,
        'party_type': partyType,
        'party_id': partyId,
        'party_name': partyName,
        'reference': reference,
        'ledger_entry_id': ledgerEntryId,
        'time': time,
        'reversed': reversed,
        'notes': notes,
      };

  @override
  List<Object?> get props => [
        id, type, amount, source, partyType, partyId, partyName, reference,
        ledgerEntryId, time, reversed, notes, //
      ];
}
