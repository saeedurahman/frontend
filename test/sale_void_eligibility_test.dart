import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';

void main() {
  group('SaleStatus.isVoidCandidate', () {
    SaleResponseModel base({
      String status = SaleStatus.completed,
      String? shiftId = 'shift-1',
      List<SaleLineModel> lines = const [],
    }) =>
        SaleResponseModel(
          id: 'sale-1',
          branchId: 'branch-1',
          saleType: 'pos',
          saleStatus: status,
          registerShiftId: shiftId,
          lines: lines,
        );

    test('true for completed sale with shift and no returns', () {
      expect(
        SaleStatus.isVoidCandidate(base()),
        isTrue,
      );
    });

    test('false when shift is missing', () {
      expect(
        SaleStatus.isVoidCandidate(base(shiftId: null)),
        isFalse,
      );
    });

    test('false when any line has returned qty', () {
      expect(
        SaleStatus.isVoidCandidate(
          base(
            lines: const [
              SaleLineModel(
                id: 'line-1',
                productId: 'p1',
                qty: '1',
                unitPrice: '10',
                returnedQty: '1',
              ),
            ],
          ),
        ),
        isFalse,
      );
    });

    test('false when status is not completed', () {
      expect(
        SaleStatus.isVoidCandidate(base(status: SaleStatus.voided)),
        isFalse,
      );
    });
  });
}
