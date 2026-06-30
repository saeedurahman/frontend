import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/presentation/utils/table_pos_navigation.dart';

void main() {
  group('DiningTableModel', () {
    test('parses backend DiningTableResponse JSON', () {
      final table = DiningTableModel.fromJson({
        'id': '11111111-1111-1111-1111-111111111111',
        'business_id': '22222222-2222-2222-2222-222222222222',
        'branch_id': '33333333-3333-3333-3333-333333333333',
        'floor_plan_id': '44444444-4444-4444-4444-444444444444',
        'table_number': 'T12',
        'capacity': 6,
        'status': 'occupied',
        'pos_x': '120.50',
        'pos_y': '80.00',
        'is_active': true,
        'active_sale_id': '66666666-6666-6666-6666-666666666666',
        'created_at': '2026-06-30T10:00:00Z',
        'updated_at': '2026-06-30T10:00:00Z',
      });

      expect(table.tableNumber, 'T12');
      expect(table.status, 'occupied');
      expect(table.capacity, 6);
      expect(table.posX, '120.50');
      expect(table.floorPlanId, isNotNull);
      expect(table.activeSaleId, '66666666-6666-6666-6666-666666666666');
    });
  });

  group('table resume navigation', () {
    test('occupied table with activeSaleId shows Resume order label', () {
      const table = DiningTableModel(
        id: 't-occupied',
        businessId: 'biz',
        branchId: 'branch',
        tableNumber: '7',
        status: 'occupied',
        activeSaleId: 'sale-held-1',
      );

      expect(tableOrderActionLabel(table), 'Resume order');
      expect(canLaunchTableOrder(table), isTrue);
      expect(table.activeSaleId, 'sale-held-1');
    });
  });

  group('FloorLayoutModel', () {
    test('parses nested floor layout response', () {
      final layout = FloorLayoutModel.fromJson({
        'branch_id': '33333333-3333-3333-3333-333333333333',
        'floor_plans': [
          {
            'id': '44444444-4444-4444-4444-444444444444',
            'business_id': '22222222-2222-2222-2222-222222222222',
            'branch_id': '33333333-3333-3333-3333-333333333333',
            'name': 'Main Hall',
            'sort_order': 0,
            'is_active': true,
            'layout_json': {},
            'tables': [
              {
                'id': '55555555-5555-5555-5555-555555555555',
                'business_id': '22222222-2222-2222-2222-222222222222',
                'branch_id': '33333333-3333-3333-3333-333333333333',
                'table_number': 'T1',
                'capacity': 4,
                'status': 'available',
                'is_active': true,
              },
            ],
          },
        ],
        'unassigned_tables': [],
      });

      expect(layout.floorPlans, hasLength(1));
      expect(layout.floorPlans.first.name, 'Main Hall');
      expect(layout.floorPlans.first.tables.first.tableNumber, 'T1');
    });
  });
}
