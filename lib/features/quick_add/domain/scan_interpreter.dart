import 'barcode_normalizer.dart';
import 'gs1_parser.dart';

/// What one scan of the scan field means.
class ScanInput {
  const ScanInput({
    required this.barcode,
    this.batch,
    this.expiry,
    this.fromGs1 = false,
    this.gs1Issues = const [],
  });

  /// The code to look up and save (already normalised the way the server does).
  final NormalizedBarcode barcode;

  /// Batch / expiry that came inside a GS1 code (pharmacy packs).
  final String? batch;
  final DateTime? expiry;
  final bool fromGs1;
  final List<Gs1Issue> gs1Issues;

  bool get isEmpty => barcode.isEmpty;
}

/// Turns the text of the scan field into a [ScanInput]: a GS1 element string
/// fills barcode + batch + expiry from one scan, anything else is a plain
/// barcode run through [BarcodeNormalizer].
abstract final class ScanInterpreter {
  static ScanInput interpret(String raw, {DateTime? now}) {
    if (Gs1Parser.looksLikeGs1(raw)) {
      final gs1 = Gs1Parser.parse(raw, now: now);
      if (gs1 != null) {
        return ScanInput(
          barcode: BarcodeNormalizer.normalize(gs1.barcode),
          batch: gs1.batch,
          expiry: gs1.expiry,
          fromGs1: true,
          gs1Issues: gs1.issues,
        );
      }
    }
    return ScanInput(barcode: BarcodeNormalizer.normalize(raw));
  }
}
