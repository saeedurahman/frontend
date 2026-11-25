import 'package:decimal/decimal.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';

/// What a receiving screen (Quick Add) asks of the "Paid now" section when it
/// saves. Keeps the screen's brain free of widgets and of the shift check.
abstract class PaidNowHook {
  /// The `payment` to send for a bill of [total]; null = everything on credit.
  ReceiptPaymentInput? inputFor(Decimal total);

  /// Why the bill cannot be saved with this payment yet, or null.
  String? blockingProblem(Decimal total);

  /// The server refused: shows [fallback] (or the plain words for [code])
  /// under the section.
  String? explain(String? code, String fallback);

  /// The bill was saved. [paid] says whether a payment went with it.
  Future<void> saved({required bool paid, ReceiptPaymentResult? result});
}
