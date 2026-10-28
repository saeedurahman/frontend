import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/shared/widgets/layout/app_nav.dart';

import '../helpers/session_fixtures.dart';

const _allFlags = BusinessFeatureFlags(
  enableRestaurant: true,
  enableTableManagement: true,
  enableKot: true,
  enableManufacturing: true,
  enableAccounting: true,
);

Future<void> pumpNav(
  WidgetTester tester,
  UserAccess access, {
  BusinessFeatureFlags flags = BusinessFeatureFlags.disabled,
}) async {
  tester.view.physicalSize = const Size(400, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SidebarNav(access: access, flags: flags, location: '/dashboard'),
      ),
    ),
  );
}

void main() {
  const everything = [
    'Dashboard',
    'Point of Sale',
    'Products',
    'Inventory',
    'Purchases',
    'Sales',
    'Returns',
    'Customers',
    'Expenses',
    'Suppliers',
    'Cash Register',
    'Analytics',
    'Staff',
    'Settings',
    'Notifications',
    'Audit Logs',
  ];

  testWidgets('owner sees every item (empty key list is fine)', (tester) async {
    await pumpNav(tester, ownerAccess);
    for (final label in everything) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    // Business modules stay off unless the business enabled them.
    for (final label in ['Manufacturing', 'Accounting', 'Tables', 'Kitchen']) {
      expect(find.text(label), findsNothing, reason: label);
    }
  });

  testWidgets('owner sees the optional modules when enabled', (tester) async {
    await pumpNav(tester, ownerAccess, flags: _allFlags);
    for (final label in ['Manufacturing', 'Accounting', 'Tables', 'Kitchen']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('manager: no audit logs, nothing else gated away by name',
      (tester) async {
    await pumpNav(tester, managerAccess);
    expect(find.text('Audit Logs'), findsNothing);
    for (final label in [
      'Dashboard',
      'Point of Sale',
      'Products',
      'Returns',
      'Suppliers',
      'Expenses',
      'Cash Register',
      'Analytics',
      'Staff',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('cashier sees only selling items', (tester) async {
    await pumpNav(tester, cashierAccess);
    for (final label in [
      'Dashboard',
      'Point of Sale',
      'Products',
      'Inventory',
      'Sales',
      'Customers',
      'Notifications',
      'Settings',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    for (final label in [
      'Purchases',
      'Returns',
      'Expenses',
      'Suppliers',
      'Cash Register',
      'Analytics',
      'Staff',
      'Audit Logs',
    ]) {
      expect(find.text(label), findsNothing, reason: label);
    }
  });

  testWidgets('custom role sees exactly its view permissions', (tester) async {
    await pumpNav(tester, customAccess);
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    for (final label in ['Point of Sale', 'Sales', 'Customers', 'Staff']) {
      expect(find.text(label), findsNothing, reason: label);
    }
  });

  testWidgets('a section label disappears with its last item', (tester) async {
    await pumpNav(
      tester,
      const UserAccess(role: 'x', permissionKeys: [Perm.productsView]),
    );
    expect(find.text('CATALOG'), findsOneWidget);
    expect(find.text('FINANCE'), findsNothing);
    expect(find.text('REPORTS'), findsNothing);
  });

  testWidgets('non-owner with no keys sees only the open pages',
      (tester) async {
    await pumpNav(tester, const UserAccess(role: 'manager'));
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Products'), findsNothing);
    expect(find.text('Point of Sale'), findsNothing);
  });

  test('visibleEntries matches the sidebar (used by global search)', () {
    final labels = AppNav.visibleEntries(
      cashierAccess,
      BusinessFeatureFlags.disabled,
    ).map((e) => e.label);
    expect(labels, contains('Point of Sale'));
    expect(labels, isNot(contains('Returns')));
  });
}
