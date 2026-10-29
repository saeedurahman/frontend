import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';

/// Which permission a route needs (any one of the listed keys suffices).
///
/// Matching is by path segments, `:param` matches any one segment, and the most
/// specific (longest) pattern wins, so `/products/:id/edit` is stricter than
/// `/products`. Deep links and typed URLs go through the same table because
/// the guard runs on every navigation.
abstract final class RoutePermissions {
  static const _rules = <_Rule>[
    // Point of sale
    _Rule(RouteNames.pos, [Perm.salesCreate]),

    // Catalog
    _Rule(RouteNames.products, [Perm.productsView]),
    _Rule('/products/new', [Perm.productsCreate]),
    _Rule('/products/:id/edit', [Perm.productsUpdate]),

    // Inventory
    _Rule(RouteNames.inventory, [Perm.inventoryView]),
    _Rule('/purchases', [Perm.purchasesView]),
    _Rule('/purchases/new', [Perm.purchasesCreate]),
    _Rule('/purchases/:id/receive', [Perm.purchasesReceive]),
    _Rule(RouteNames.manufacturing, [Perm.productionView, Perm.bomView]),
    _Rule('/manufacturing/new', [Perm.productionCreate]),
    _Rule('/manufacturing/boms', [Perm.bomView]),
    _Rule('/manufacturing/boms/new', [Perm.bomManage]),

    // Sales
    _Rule(RouteNames.sales, [Perm.salesView]),
    _Rule('/sales/:id/return', [Perm.returnsCreate]),
    _Rule(RouteNames.returns, [Perm.returnsView]),
    _Rule(RouteNames.restaurantTables, [Perm.tablesView]),
    _Rule(RouteNames.kitchen, [Perm.kotView, Perm.kotUpdateStatus]),

    // People
    _Rule(RouteNames.customers, [Perm.customersView]),
    _Rule('/customers/new', [Perm.customersCreate]),
    _Rule('/customers/:id/edit', [Perm.customersUpdate]),
    _Rule(RouteNames.suppliers, [Perm.suppliersView]),
    _Rule('/suppliers/new', [Perm.suppliersCreate]),
    _Rule('/suppliers/:id/edit', [Perm.suppliersUpdate]),

    // Finance
    _Rule(RouteNames.expenses, [Perm.expensesView]),
    _Rule('/expenses/new', [Perm.expensesCreate]),
    _Rule('/expenses/:id/edit', [Perm.expensesUpdate]),
    _Rule(RouteNames.accounting, [Perm.journalView, Perm.coaView]),
    _Rule('/accounting/new', [Perm.journalCreate]),
    _Rule('/accounting/:id/edit', [Perm.journalCreate]),
    _Rule('/accounting/coa', [Perm.coaView]),
    _Rule('/accounting/coa/new', [Perm.coaManage]),
    _Rule(RouteNames.cashRegister, [Perm.shiftsView]),
    _Rule(RouteNames.closeShift, [Perm.shiftsClose]),

    // Reports
    _Rule(RouteNames.analytics, [Perm.reportsView]),

    // System
    _Rule(RouteNames.staff, [Perm.usersView]),
    _Rule('/staff/new', [Perm.usersCreate]),
    _Rule(RouteNames.settingsRoles, [Perm.rolesManage]),
    _Rule(RouteNames.notifications, [Perm.notificationsView]),
    _Rule(RouteNames.auditLogs, [Perm.auditView]),
  ];

  /// Routes any signed-in user may open: the landing page, the account area of
  /// Settings (change password, subscription; business options are gated inside
  /// the page) and the two status pages.
  static const openRoutes = <String>[
    RouteNames.dashboard,
    RouteNames.settings,
    RouteNames.noAccess,
    RouteNames.subscriptionExpired,
    RouteNames.syncFailed,
  ];

  /// The permissions that open [location], or `null` when it needs none.
  static List<String>? requiredFor(String location) {
    final segments = _segments(location);
    _Rule? best;
    var bestLength = -1;
    for (final rule in _rules) {
      final pattern = rule.segments;
      if (pattern.length > segments.length) continue;
      if (!_prefixMatches(pattern, segments)) continue;
      if (pattern.length > bestLength) {
        best = rule;
        bestLength = pattern.length;
      }
    }
    return best?.anyOf;
  }

  /// True when the user may open [location].
  static bool isAllowed(String location, bool Function(String) can) {
    final required = requiredFor(location);
    return required == null || required.any(can);
  }

  static bool _prefixMatches(List<String> pattern, List<String> segments) {
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i].startsWith(':')) continue;
      if (pattern[i] != segments[i]) return false;
    }
    return true;
  }

  static List<String> _segments(String location) {
    final path = Uri.tryParse(location)?.path ?? location;
    return path.split('/').where((s) => s.isNotEmpty).toList();
  }

  /// Every pattern in the table (used by tests to prove full coverage).
  static Iterable<String> get patterns => _rules.map((r) => r.pattern);
}

class _Rule {
  const _Rule(this.pattern, this.anyOf);

  final String pattern;
  final List<String> anyOf;

  List<String> get segments =>
      pattern.split('/').where((s) => s.isNotEmpty).toList();
}
