import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/app_router.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/settings/presentation/settings_catalog.dart';
import 'package:go_router/go_router.dart';

class _Storage implements SecureStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// A signed-in guard that lets everything through, so only the router's own
/// redirects are under test.
class _Guard extends AuthGuard {
  _Guard() : super(_Storage());

  @override
  bool get isAuthenticated => true;

  @override
  String get homeRoute => RouteNames.dashboard;

  @override
  String? redirect(String location) => null;
}

void main() {
  List<String> titles(List<SettingsGroup> g, String id) =>
      [for (final e in g.firstWhere((x) => x.id == id).entries) e.title];

  group('Settings catalog', () {
    test('"Business & Receipts" holds the five screens in order', () {
      final groups = SettingsCatalog.visible(can: (_) => true, multiBranch: true);
      expect(groups.first.title, 'Business & Receipts');
      expect(titles(groups, SettingsCatalog.business), [
        'Business Profile',
        'Tax Rates',
        'Tax & Prices',
        'Receipt Layouts',
        'Receipt Printer',
      ]);
    });

    test('the other groups are still there', () {
      final groups = SettingsCatalog.visible(can: (_) => true, multiBranch: true);
      expect([for (final g in groups) g.title], [
        'Business & Receipts',
        'People & Security',
        'Point of Sale & Offline',
        'Account & Branches',
      ]);
      expect(titles(groups, 'people'), ['Roles & Permissions', 'Security']);
      expect(titles(groups, 'pos'), ['POS Settings', 'Offline & Sync', 'Devices']);
      expect(titles(groups, 'account'), ['Subscription', 'Branch Overrides']);
    });

    test('every entry has its own route and the routes are unique', () {
      final routes = [
        for (final g in SettingsCatalog.groups) for (final e in g.entries) e.route,
      ];
      expect(routes.toSet(), hasLength(routes.length));
      expect(SettingsCatalog.byRoute(RouteNames.settingsReceiptLayouts)!.title, 'Receipt Layouts');
      expect(SettingsCatalog.byRoute(RouteNames.settingsPrinter)!.title, 'Receipt Printer');
    });

    test('entries without the permission are left out', () {
      final groups = SettingsCatalog.visible(
        can: (p) => p != Perm.settingsManage && p != Perm.rolesManage,
        multiBranch: true,
      );
      final all = [for (final g in groups) for (final e in g.entries) e.title];
      expect(all, isNot(contains('Receipt Layouts')));
      expect(all, isNot(contains('Devices')));
      expect(all, isNot(contains('Roles & Permissions')));
      // Open entries stay.
      expect(titles(groups, SettingsCatalog.business),
          ['Business Profile', 'Tax Rates', 'Tax & Prices', 'Receipt Printer']);
    });

    test('Branch Overrides needs more than one branch', () {
      final single = SettingsCatalog.visible(can: (_) => true, multiBranch: false);
      expect(titles(single, 'account'), ['Subscription']);
    });

    test('with no permissions only the open entries remain, and no group is empty', () {
      final groups = SettingsCatalog.visible(can: (_) => false, multiBranch: false);
      expect(groups.any((g) => g.entries.isEmpty), isFalse);
      for (final g in groups) {
        for (final e in g.entries) {
          expect(e.permission, isNull, reason: e.title);
          expect(e.needsBranches, isFalse, reason: e.title);
        }
      }
    });
  });

  group('Settings routes', () {
    late GoRouter router;

    setUp(() => router = AppRouter(_Guard()).router);
    tearDown(() => router.dispose());

    Future<String> resolve(WidgetTester t, String location) async {
      late BuildContext ctx;
      await t.pumpWidget(Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }));
      final list = await router.routeInformationParser.parseRouteInformationWithDependencies(
        RouteInformation(
          uri: Uri.parse(location),
          state: RouteInformationState<void>(type: NavigatingType.go),
        ),
        ctx,
      );
      return list.uri.path;
    }

    testWidgets('the old Receipt & Printing route redirects to Receipt Printer', (t) async {
      expect(await resolve(t, '/settings/receipt'), RouteNames.settingsPrinter);
    });

    for (final route in [
      RouteNames.settings,
      RouteNames.settingsBusiness,
      RouteNames.settingsTax,
      RouteNames.settingsTaxPrices,
      RouteNames.settingsReceiptLayouts,
      RouteNames.settingsReceiptAssignments,
      RouteNames.settingsPrinter,
      RouteNames.settingsDevices,
      RouteNames.settingsSecurity,
    ]) {
      testWidgets('$route still opens (deep link)', (t) async {
        expect(await resolve(t, route), route);
      });
    }

    testWidgets('a layout id opens the editor route', (t) async {
      expect(await resolve(t, RouteNames.settingsReceiptLayoutPath('lay-1')),
          '/settings/receipt-layouts/lay-1');
    });
  });
}
