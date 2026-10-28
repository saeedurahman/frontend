import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/permissions/route_permissions.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:go_router/go_router.dart';

/// One sidebar / search entry.
class NavEntry {
  const NavEntry({
    required this.section,
    required this.label,
    required this.icon,
    required this.route,
    this.isEnabledBy,
    this.hiddenForKitchenOnly = false,
  });

  final String section;
  final String label;
  final IconData icon;
  final String route;

  /// Business feature flag gate (restaurant, manufacturing, accounting).
  final bool Function(BusinessFeatureFlags flags)? isEnabledBy;

  /// Kitchen display staff use the kitchen shell instead of this entry.
  final bool hiddenForKitchenOnly;
}

class NavSection {
  const NavSection(this.label, this.items);

  final String label;
  final List<NavEntry> items;
}

/// The navigation menu. Visibility is derived from the same route permission
/// table the router guard uses, so an item can never link to a page the user
/// is then refused.
abstract final class AppNav {
  static const entries = <NavEntry>[
    NavEntry(
      section: 'MAIN',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: RouteNames.dashboard,
    ),
    NavEntry(
      section: 'MAIN',
      label: 'Point of Sale',
      icon: Icons.point_of_sale,
      route: RouteNames.pos,
    ),
    NavEntry(
      section: 'CATALOG',
      label: 'Products',
      icon: Icons.inventory_2_outlined,
      route: RouteNames.products,
    ),
    NavEntry(
      section: 'INVENTORY',
      label: 'Inventory',
      icon: Icons.warehouse_outlined,
      route: RouteNames.inventory,
    ),
    NavEntry(
      section: 'INVENTORY',
      label: 'Purchases',
      icon: Icons.shopping_cart_outlined,
      route: RouteNames.purchases,
    ),
    NavEntry(
      section: 'INVENTORY',
      label: 'Manufacturing',
      icon: Icons.precision_manufacturing_outlined,
      route: RouteNames.manufacturing,
      isEnabledBy: _manufacturing,
    ),
    NavEntry(
      section: 'SALES',
      label: 'Sales',
      icon: Icons.receipt_long_outlined,
      route: RouteNames.sales,
    ),
    NavEntry(
      section: 'SALES',
      label: 'Tables',
      icon: Icons.table_restaurant_outlined,
      route: RouteNames.restaurantTables,
      isEnabledBy: _tables,
    ),
    NavEntry(
      section: 'SALES',
      label: 'Kitchen',
      icon: Icons.kitchen_outlined,
      route: RouteNames.kitchen,
      isEnabledBy: _kitchen,
      hiddenForKitchenOnly: true,
    ),
    NavEntry(
      section: 'SALES',
      label: 'Returns',
      icon: Icons.assignment_return_outlined,
      route: RouteNames.returns,
    ),
    NavEntry(
      section: 'SALES',
      label: 'Customers',
      icon: Icons.people_outline,
      route: RouteNames.customers,
    ),
    NavEntry(
      section: 'FINANCE',
      label: 'Expenses',
      icon: Icons.account_balance_wallet_outlined,
      route: RouteNames.expenses,
    ),
    NavEntry(
      section: 'FINANCE',
      label: 'Suppliers',
      icon: Icons.local_shipping_outlined,
      route: RouteNames.suppliers,
    ),
    NavEntry(
      section: 'FINANCE',
      label: 'Accounting',
      icon: Icons.account_balance_outlined,
      route: RouteNames.accounting,
      isEnabledBy: _accounting,
    ),
    NavEntry(
      section: 'FINANCE',
      label: 'Cash Register',
      icon: Icons.point_of_sale_outlined,
      route: RouteNames.cashRegister,
    ),
    NavEntry(
      section: 'REPORTS',
      label: 'Analytics',
      icon: Icons.bar_chart_outlined,
      route: RouteNames.analytics,
    ),
    NavEntry(
      section: 'SYSTEM',
      label: 'Staff',
      icon: Icons.badge_outlined,
      route: RouteNames.staff,
    ),
    NavEntry(
      section: 'SYSTEM',
      label: 'Settings',
      icon: Icons.settings_outlined,
      route: RouteNames.settings,
    ),
    NavEntry(
      section: 'SYSTEM',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      route: RouteNames.notifications,
    ),
    NavEntry(
      section: 'SYSTEM',
      label: 'Audit Logs',
      icon: Icons.history_outlined,
      route: RouteNames.auditLogs,
    ),
  ];

  static bool _tables(BusinessFeatureFlags f) => f.showTablesNav;
  static bool _kitchen(BusinessFeatureFlags f) => f.showKitchenNav;
  static bool _manufacturing(BusinessFeatureFlags f) => f.showManufacturingNav;
  static bool _accounting(BusinessFeatureFlags f) => f.showAccountingNav;

  /// Entries the user may open, grouped by section (empty sections dropped).
  static List<NavSection> visibleSections(
    UserAccess access,
    BusinessFeatureFlags flags,
  ) {
    final kitchenOnly = flags.showKitchenNav &&
        UserRoleUtils.isKitchenOnlyUser(
          role: access.role,
          permissionKeys: access.permissionKeys,
        );

    final sections = <String, List<NavEntry>>{};
    for (final entry in entries) {
      if (entry.isEnabledBy != null && !entry.isEnabledBy!(flags)) continue;
      if (entry.hiddenForKitchenOnly && kitchenOnly) continue;
      if (!RoutePermissions.isAllowed(entry.route, access.can)) continue;
      sections.putIfAbsent(entry.section, () => []).add(entry);
    }
    return [
      for (final e in sections.entries) NavSection(e.key, e.value),
    ];
  }

  /// Flat list (global search).
  static List<NavEntry> visibleEntries(
    UserAccess access,
    BusinessFeatureFlags flags,
  ) =>
      [for (final s in visibleSections(access, flags)) ...s.items];
}

/// The scrolling menu inside the sidebar.
class SidebarNav extends StatelessWidget {
  const SidebarNav({
    super.key,
    required this.access,
    required this.flags,
    required this.location,
    this.unreadCount = 0,
  });

  final UserAccess access;
  final BusinessFeatureFlags flags;
  final String location;
  final int unreadCount;

  bool _isActive(NavEntry entry) {
    if (entry.route == RouteNames.dashboard) {
      return location == RouteNames.dashboard;
    }
    if (entry.route == RouteNames.pos) return location == RouteNames.pos;
    return location.startsWith(entry.route);
  }

  @override
  Widget build(BuildContext context) {
    final sections = AppNav.visibleSections(access, flags);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
            child: Text(
              section.label,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 0.7,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final item in section.items)
            NavItemTile(
              icon: item.icon,
              label: item.label,
              routePath: item.route,
              isActive: _isActive(item),
              badgeCount:
                  item.route == RouteNames.notifications ? unreadCount : 0,
            ),
        ],
      ],
    );
  }
}

class NavItemTile extends StatefulWidget {
  const NavItemTile({
    super.key,
    required this.icon,
    required this.label,
    required this.routePath,
    required this.isActive,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final String routePath;
  final bool isActive;
  final int badgeCount;

  @override
  State<NavItemTile> createState() => _NavItemTileState();
}

class _NavItemTileState extends State<NavItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    final showHover = _hovered && !active;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.go(widget.routePath),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : showHover
                    ? const Color(0xFFF0F9F4)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: active ? AppColors.accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 25,
                color: active ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              if (widget.badgeCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: active ? Colors.white : AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.badgeCount > 99 ? '99+' : '${widget.badgeCount}',
                    style: TextStyle(
                      fontSize: 11,
                      color: active ? AppColors.primary : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
