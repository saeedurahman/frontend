import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/quick_add/domain/gs1_parser.dart';
import 'package:frantend/features/quick_add/domain/scan_interpreter.dart';

void main() {
  // A fixed "today" so the two-digit year window never changes under the test.
  final now = DateTime(2026, 11, 20);
  const gtin = '08964000370018'; // GTIN-14 of EAN-13 8964000370018
  const gs = '\x1D';

  group('bracketed form', () {
    test('GTIN + batch + expiry', () {
      final s = Gs1Parser.parse('(01)$gtin(10)B17(17)270630', now: now)!;
      expect(s.gtin, gtin);
      expect(s.barcode, '8964000370018');
      expect(s.batch, 'B17');
      expect(s.expiry, DateTime(2027, 6, 30));
      expect(s.issues, isEmpty);
    });

    test('all four AIs, any order', () {
      final s = Gs1Parser.parse('(21)SER99(17)271231(10)LOT-7(01)$gtin', now: now)!;
      expect(s.batch, 'LOT-7');
      expect(s.serial, 'SER99');
      expect(s.expiry, DateTime(2027, 12, 31));
      expect(s.gtin, gtin);
    });

    test('only the GTIN', () {
      final s = Gs1Parser.parse('(01)$gtin', now: now)!;
      expect(s.batch, isNull);
      expect(s.expiry, isNull);
    });

    test('GTIN + expiry only', () {
      final s = Gs1Parser.parse('(01)$gtin(17)261100', now: now)!;
      expect(s.expiry, DateTime(2026, 11, 30), reason: 'day 00 = end of month');
      expect(s.expiryDayWasZero, isTrue);
    });

    test('no GTIN is not a usable scan', () {
      expect(Gs1Parser.parse('(10)B17(17)270630', now: now), isNull);
    });
  });

  group('raw FNC1 / GS form', () {
    test('batch last (no separator needed)', () {
      final s = Gs1Parser.parse('0108964000370018' '17270630' '10B17', now: now)!;
      expect(s.gtin, gtin);
      expect(s.expiry, DateTime(2027, 6, 30));
      expect(s.batch, 'B17');
    });

    test('variable batch followed by GS then expiry', () {
      final s = Gs1Parser.parse('0108964000370018' '10B17${gs}17270630', now: now)!;
      expect(s.batch, 'B17');
      expect(s.expiry, DateTime(2027, 6, 30));
    });

    test('batch + serial with GS between', () {
      final s = Gs1Parser.parse('0108964000370018' '10LOT1${gs}21SN-5', now: now)!;
      expect(s.batch, 'LOT1');
      expect(s.serial, 'SN-5');
    });

    test('plain GTIN element string', () {
      final s = Gs1Parser.parse('0108964000370018', now: now)!;
      expect(s.barcode, '8964000370018');
    });

    test('tolerates a scanner prefix and Enter / GS suffixes', () {
      for (final wrapped in [
        ']C10108964000370018' '17270630' '10B17',
        ']d20108964000370018' '17270630' '10B17\r\n',
        '\x02' '0108964000370018' '17270630' '10B17$gs\r',
        '  0108964000370018' '17270630' '10B17  ',
      ]) {
        final s = Gs1Parser.parse(wrapped, now: now);
        expect(s, isNotNull, reason: wrapped);
        expect(s!.batch, 'B17', reason: wrapped);
        expect(s.expiry, DateTime(2027, 6, 30), reason: wrapped);
      }
    });

    test('unknown trailing AI keeps what was read', () {
      final s = Gs1Parser.parse('(01)$gtin(10)B1', now: now)!;
      expect(s.batch, 'B1');
    });

    test('a plain EAN-13 is NOT a GS1 string', () {
      expect(Gs1Parser.parse('8964000370018', now: now), isNull);
      expect(Gs1Parser.looksLikeGs1('8964000370018'), isFalse);
    });

    test('a numeric code that merely starts with 01 stays a plain code', () {
      // 16 digits, starts with 01, but the GTIN check digit is wrong.
      expect(Gs1Parser.parse('0112345678901234', now: now), isNull);
    });

    test('truncated field is rejected for a raw string', () {
      expect(Gs1Parser.parse('0108964000370018' '1727', now: now), isNull);
    });
  });

  group('YYMMDD', () {
    DateTime? d(String s) => Gs1Parser.parseDate(s, now: now)?.date;

    test('plain dates', () {
      expect(d('270630'), DateTime(2027, 6, 30));
      expect(d('300101'), DateTime(2030, 1, 1));
    });

    test('day 00 is the last day of the month', () {
      expect(d('270200'), DateTime(2027, 2, 28));
      expect(d('280200'), DateTime(2028, 2, 29), reason: 'leap year');
      expect(d('271200'), DateTime(2027, 12, 31));
      expect(d('270400'), DateTime(2027, 4, 30));
    });

    test('invalid dates are rejected', () {
      expect(d('271301'), isNull, reason: 'month 13');
      expect(d('270001'), isNull, reason: 'month 00');
      expect(d('270230'), isNull, reason: '30 February');
      expect(d('270431'), isNull, reason: '31 April');
      expect(d('27063'), isNull, reason: 'too short');
      expect(d('27O630'), isNull, reason: 'letter O');
    });

    test('century window follows GS1 (49 back, 50 ahead)', () {
      expect(d('760101')!.year, 2076);
      expect(d('770101')!.year, 1977);
      expect(d('000101')!.year, 2000);
    });

    test('a bad expiry keeps the rest of the scan and reports it', () {
      final s = Gs1Parser.parse('(01)$gtin(10)B17(17)271399', now: now)!;
      expect(s.expiry, isNull);
      expect(s.batch, 'B17');
      expect(s.issues, contains(Gs1Issue.badExpiry));
    });
  });

  group('bad input', () {
    test('empty and junk', () {
      expect(Gs1Parser.parse('', now: now), isNull);
      expect(Gs1Parser.parse('hello', now: now), isNull);
      expect(Gs1Parser.parse('(01)', now: now), isNull);
      expect(Gs1Parser.parse('(01)ABC', now: now), isNull);
    });

    test('a GTIN with a wrong check digit in brackets still parses, with a warning', () {
      final s = Gs1Parser.parse('(01)08964000370019', now: now)!;
      expect(s.issues, contains(Gs1Issue.badGtinCheckDigit));
    });

    test('short GTIN is zero padded to 14', () {
      final s = Gs1Parser.parse('(01)8964000370018', now: now)!;
      expect(s.gtin, gtin);
    });
  });

  group('scan interpreter', () {
    test('GS1 fills barcode, batch and expiry from one scan', () {
      final i = ScanInterpreter.interpret('(01)$gtin(10)B17(17)270630', now: now);
      expect(i.fromGs1, isTrue);
      expect(i.barcode.canonical, '8964000370018');
      expect(i.barcode.valid, isTrue);
      expect(i.batch, 'B17');
      expect(i.expiry, DateTime(2027, 6, 30));
    });

    test('a plain barcode goes through the normaliser', () {
      final i = ScanInterpreter.interpret(' 036000291452 ', now: now);
      expect(i.fromGs1, isFalse);
      expect(i.barcode.canonical, '0036000291452', reason: 'UPC-A becomes EAN-13');
      expect(i.batch, isNull);
    });

    test('nothing useful is empty', () {
      expect(ScanInterpreter.interpret('   ', now: now).isEmpty, isTrue);
    });
  });
}
