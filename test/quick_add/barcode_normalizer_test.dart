import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';

// Same published codes as the backend's tests/unit/test_barcode_utils.py, so
// the two implementations are checked against the same facts.
void main() {
  const cocaCola = '5449000000996';
  const pk = '8964000370018';
  const ean8 = '96385074';
  const upca = '036000291452';
  const gtin14 = '10012345678902';

  group('formats and check digits', () {
    for (final (code, fmt) in [
      (cocaCola, 'EAN13'),
      (pk, 'EAN13'),
      (ean8, 'EAN8'),
      (upca, 'UPCA'),
      (gtin14, 'GTIN14'),
    ]) {
      test('$code is $fmt and valid', () {
        final n = BarcodeNormalizer.normalize(code);
        expect(n.format, fmt);
        expect(n.valid, isTrue);
        expect(n.hasBadCheckDigit, isFalse);
        expect(BarcodeNormalizer.isValidGtin(code), isTrue);
      });
    }

    test('UPC-A becomes EAN-13 with a leading zero (same check digit)', () {
      final n = BarcodeNormalizer.normalize(upca);
      expect(n.canonical, '0$upca');
      expect(BarcodeNormalizer.isValidGtin(n.canonical), isTrue);
    });

    test('GTIN-14 is kept; its base item is tried for lookup only', () {
      final n = BarcodeNormalizer.normalize(gtin14);
      expect(n.canonical, gtin14);
      expect(n.lookupForms, contains('0012345678905'));
      expect(n.forms, isNot(contains('0012345678905')));
    });

    for (final bad in ['5449000000995', '96385075', '036000291453', '10012345678903']) {
      test('bad check digit $bad is flagged, never rejected', () {
        final n = BarcodeNormalizer.normalize(bad);
        expect(n.valid, isFalse);
        expect(n.hasBadCheckDigit, isTrue);
        // Still usable as typed (a 12-digit UPC-A only gains its leading 0).
        expect(n.canonical, bad.length == 12 ? '0$bad' : bad);
        expect(n.isEmpty, isFalse);
      });
    }

    test('unknown length is kept as it is, not flagged as a bad GTIN', () {
      final n = BarcodeNormalizer.normalize('12345');
      expect(n.format, 'UNKNOWN');
      expect(n.canonical, '12345');
      expect(n.hasBadCheckDigit, isFalse);
    });
  });

  group('messy input', () {
    test('spaces, dashes, scanner prefix, Arabic digits', () {
      expect(BarcodeNormalizer.normalize(' 5449-0000 00996 \r\n').canonical, cocaCola);
      expect(BarcodeNormalizer.normalize(']E0$cocaCola').canonical, cocaCola);
      expect(BarcodeNormalizer.normalize('٥٤٤٩٠٠٠٠٠٠٩٩٦').canonical, cocaCola);
      expect(BarcodeNormalizer.normalize('۵۴۴۹۰۰۰۰۰۰۹۹۶').canonical, cocaCola);
    });

    test('empty', () {
      expect(BarcodeNormalizer.normalize('').isEmpty, isTrue);
      expect(BarcodeNormalizer.normalize(null).isEmpty, isTrue);
      expect(BarcodeNormalizer.normalize('---').isEmpty, isTrue);
    });
  });

  group('custom codes', () {
    test('letters keep the code verbatim', () {
      final n = BarcodeNormalizer.normalize('AB-123');
      expect(n.custom, isTrue);
      expect(n.canonical, 'AB-123');
      expect(n.forms, isEmpty);
    });

    test('a custom code is never the same item as its digits', () {
      final custom = BarcodeNormalizer.normalize('AB-123');
      final digits = BarcodeNormalizer.normalize('123');
      expect(custom.sameItemAs(digits), isFalse);
      expect(custom.sameItemAs(BarcodeNormalizer.normalize('AB-123')), isTrue);
    });
  });

  group('same item across spellings', () {
    test('UPC-A, EAN-13 and GTIN-14 of one item match', () {
      final a = BarcodeNormalizer.normalize('012345678905');
      final b = BarcodeNormalizer.normalize('0012345678905');
      final c = BarcodeNormalizer.normalize('00012345678905');
      expect(a.sameItemAs(b), isTrue);
      expect(b.sameItemAs(c), isTrue);
      expect(a.sameItemAs(c), isTrue);
    });

    test('036000291452 equals 0036000291452', () {
      expect(
        BarcodeNormalizer.normalize('036000291452')
            .sameItemAs(BarcodeNormalizer.normalize('0036000291452')),
        isTrue,
      );
    });

    test('a case code is not the same item as its unit', () {
      expect(
        BarcodeNormalizer.normalize(gtin14)
            .sameItemAs(BarcodeNormalizer.normalize('0012345678905')),
        isFalse,
      );
    });

    test('different products differ', () {
      expect(
        BarcodeNormalizer.normalize(cocaCola).sameItemAs(BarcodeNormalizer.normalize(pk)),
        isFalse,
      );
    });
  });

  test('match candidates start with the code as typed', () {
    expect(BarcodeNormalizer.matchCandidates(' AB-1 ').first, 'AB-1');
    expect(BarcodeNormalizer.matchCandidates(upca), containsAll([upca, '0$upca']));
  });
}
