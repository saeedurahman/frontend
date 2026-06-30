import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/restaurant/presentation/cubit/tables_floor_state.dart';

bool showTablesNav({
  required BusinessFeatureFlags flags,
  required String? role,
  required List<String> permissionKeys,
}) {
  return flags.showTablesNav &&
      UserRoleUtils.canViewTables(
        role: role,
        permissionKeys: permissionKeys,
      );
}

void main() {
  group('TablesFloorState', () {
    const layout = FloorLayoutModel(
      branchId: 'branch-1',
      floorPlans: [
        FloorPlanWithTablesModel(
          id: 'plan-a',
          businessId: 'biz-1',
          branchId: 'branch-1',
          name: 'Ground',
          tables: [
            DiningTableModel(
              id: 't1',
              businessId: 'biz-1',
              branchId: 'branch-1',
              tableNumber: '1',
              status: 'available',
            ),
          ],
        ),
        FloorPlanWithTablesModel(
          id: 'plan-b',
          businessId: 'biz-1',
          branchId: 'branch-1',
          name: 'Roof',
          tables: [
            DiningTableModel(
              id: 't2',
              businessId: 'biz-1',
              branchId: 'branch-1',
              tableNumber: '2',
              status: 'occupied',
            ),
          ],
        ),
      ],
      unassignedTables: [
        DiningTableModel(
          id: 't3',
          businessId: 'biz-1',
          branchId: 'branch-1',
          tableNumber: '3',
          status: 'available',
        ),
      ],
    );

    test('selects floor plan and exposes its tables', () {
      const state = TablesFloorState(
        status: TablesFloorStatus.loaded,
        layout: layout,
        selectedFloorPlanId: 'plan-b',
      );

      expect(state.selectedFloorPlan?.name, 'Roof');
      expect(state.visibleTables.single.tableNumber, '2');
      expect(state.hasMultipleFloorPlans, isTrue);
    });

    test('falls back to unassigned tables when no floor plans', () {
      const state = TablesFloorState(
        status: TablesFloorStatus.loaded,
        layout: FloorLayoutModel(
          branchId: 'branch-1',
          unassignedTables: [
            DiningTableModel(
              id: 't3',
              businessId: 'biz-1',
              branchId: 'branch-1',
              tableNumber: '3',
              status: 'available',
            ),
          ],
        ),
      );

      expect(state.visibleTables.single.tableNumber, '3');
    });
  });

  group('Tables nav gating', () {
    const restaurantFlags = BusinessFeatureFlags(
      enableRestaurant: true,
      enableTableManagement: true,
    );

    test('hidden when feature flags are off', () {
      expect(
        showTablesNav(
          flags: BusinessFeatureFlags.disabled,
          role: 'owner',
          permissionKeys: const ['restaurant.tables.view'],
        ),
        isFalse,
      );
    });

    test('hidden for kitchen-only staff without tables permission', () {
      expect(
        showTablesNav(
          flags: restaurantFlags,
          role: 'kitchen',
          permissionKeys: const [
            'restaurant.kot.view',
            'restaurant.kot.update',
          ],
        ),
        isFalse,
      );
    });

    test('visible for cashier with tables permission', () {
      expect(
        showTablesNav(
          flags: restaurantFlags,
          role: 'cashier',
          permissionKeys: const [
            'sales.create',
            'restaurant.tables.view',
          ],
        ),
        isTrue,
      );
    });
  });
}
