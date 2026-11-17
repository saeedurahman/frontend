import 'package:flutter/material.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';

/// One screen reachable from Settings.
class SettingsEntry {
  const SettingsEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.permission,
    this.needsBranches = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  /// The permission needed to see the entry (null: everyone).
  final String? permission;

  /// Only shown to businesses with more than one branch.
  final bool needsBranches;
}

class SettingsGroup {
  const SettingsGroup(this.id, this.title, this.entries);

  final String id;
  final String title;
  final List<SettingsEntry> entries;
}

/// The Settings home: grouped entries, in the order they are shown.
abstract final class SettingsCatalog {
  static const business = 'business';

  static const groups = <SettingsGroup>[
    SettingsGroup(business, 'Business & Receipts', [
      SettingsEntry(
        id: 'business-profile',
        title: 'Business Profile',
        subtitle: 'Name, address, phone, NTN and your logo.',
        icon: Icons.storefront_outlined,
        route: RouteNames.settingsBusiness,
      ),
      SettingsEntry(
        id: 'tax-rates',
        title: 'Tax Rates',
        subtitle: 'The tax rates you charge and the default one.',
        icon: Icons.percent,
        route: RouteNames.settingsTax,
      ),
      SettingsEntry(
        id: 'tax-prices',
        title: 'Tax & Prices',
        subtitle: 'Whether prices include tax and how totals are rounded.',
        icon: Icons.price_change_outlined,
        route: RouteNames.settingsTaxPrices,
      ),
      SettingsEntry(
        id: 'receipt-layouts',
        title: 'Receipt Layouts',
        subtitle: 'How receipts look: design, language, paper size and wording.',
        icon: Icons.receipt_long_outlined,
        route: RouteNames.settingsReceiptLayouts,
        permission: Perm.settingsManage,
      ),
      SettingsEntry(
        id: 'receipt-printer',
        title: 'Receipt Printer',
        subtitle: 'Printer, copies, auto-print, cash drawer and Urdu font.',
        icon: Icons.print_outlined,
        route: RouteNames.settingsPrinter,
      ),
    ]),
    SettingsGroup('people', 'People & Security', [
      SettingsEntry(
        id: 'roles',
        title: 'Roles & Permissions',
        subtitle: 'Manage staff roles and what they can access.',
        icon: Icons.admin_panel_settings_outlined,
        route: RouteNames.settingsRoles,
        permission: Perm.rolesManage,
      ),
      SettingsEntry(
        id: 'security',
        title: 'Security',
        subtitle: 'Password, PIN and sign-in options.',
        icon: Icons.lock_outline,
        route: RouteNames.settingsSecurity,
      ),
    ]),
    SettingsGroup('pos', 'Point of Sale & Offline', [
      SettingsEntry(
        id: 'pos',
        title: 'POS Settings',
        subtitle: 'How the sales screen behaves at the counter.',
        icon: Icons.point_of_sale,
        route: RouteNames.settingsPos,
      ),
      SettingsEntry(
        id: 'offline',
        title: 'Offline & Sync',
        subtitle: 'Working without internet and keeping devices in step.',
        icon: Icons.cloud_sync_outlined,
        route: RouteNames.settingsOffline,
      ),
      SettingsEntry(
        id: 'devices',
        title: 'Devices',
        subtitle: 'Each counter and the code that starts its receipt numbers.',
        icon: Icons.devices,
        route: RouteNames.settingsDevices,
        permission: Perm.settingsManage,
      ),
    ]),
    SettingsGroup('account', 'Account & Branches', [
      SettingsEntry(
        id: 'subscription',
        title: 'Subscription',
        subtitle: 'Your plan, end date and how to renew.',
        icon: Icons.workspace_premium_outlined,
        route: RouteNames.settingsSubscription,
      ),
      SettingsEntry(
        id: 'branch-overrides',
        title: 'Branch Overrides',
        subtitle: 'Settings that differ for one branch.',
        icon: Icons.account_tree_outlined,
        route: RouteNames.settingsBranchOverrides,
        needsBranches: true,
      ),
    ]),
  ];

  static SettingsEntry? byRoute(String route) {
    for (final g in groups) {
      for (final e in g.entries) {
        if (e.route == route) return e;
      }
    }
    return null;
  }

  /// The groups this user sees: entries they have no permission for, and
  /// branch-only entries on a one-branch business, are left out.
  static List<SettingsGroup> visible({
    required bool Function(String permission) can,
    required bool multiBranch,
  }) {
    final out = <SettingsGroup>[];
    for (final g in groups) {
      final entries = [
        for (final e in g.entries)
          if ((e.permission == null || can(e.permission!)) && (!e.needsBranches || multiBranch)) e,
      ];
      if (entries.isNotEmpty) out.add(SettingsGroup(g.id, g.title, entries));
    }
    return out;
  }
}
