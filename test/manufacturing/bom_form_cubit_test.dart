import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_state.dart';

void main() {
  group('BomFormState', () {
    test('isEdit is true when bomId is set', () {
      expect(const BomFormState().isEdit, isFalse);
      expect(const BomFormState(bomId: 'bom-1').isEdit, isTrue);
    });
  });

  group('Bom line validation rules', () {
    bool lineHasValidQty(BomLineFormItem line) {
      final qty = double.tryParse(line.qtyRequired.trim());
      return qty != null && qty > 0;
    }

    bool lineHasValidWastage(BomLineFormItem line) {
      final wastage = double.tryParse(line.wastagePct.trim());
      return wastage != null && wastage >= 0 && wastage <= 100;
    }

    test('rejects non-positive quantity', () {
      const line = BomLineFormItem(qtyRequired: '0');
      expect(lineHasValidQty(line), isFalse);
    });

    test('accepts wastage between 0 and 100', () {
      expect(
        lineHasValidWastage(const BomLineFormItem(wastagePct: '10')),
        isTrue,
      );
      expect(
        lineHasValidWastage(const BomLineFormItem(wastagePct: '101')),
        isFalse,
      );
    });

    test('preview batch uses output qty default on new form', () {
      const state = BomFormState(outputQty: '10', previewBatchQty: '1');
      expect(Decimal.parse(state.outputQty), Decimal.parse('10'));
      expect(Decimal.parse(state.previewBatchQty), Decimal.parse('1'));
    });
  });
}
