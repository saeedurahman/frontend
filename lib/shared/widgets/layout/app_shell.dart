import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.breadcrumb,
    required this.child,
    this.unreadCount = 0,
  });

  final String title;
  final String breadcrumb;
  final Widget child;
  final int unreadCount;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final Future<UserModel?> _currentUserFuture;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = sl<AuthLocalDataSource>().getCachedUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _currentUserFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final content = Row(
                children: [
                  _Sidebar(user: user, unreadCount: widget.unreadCount),
                  Expanded(
                    child: Column(
                      children: [
                        _TopBar(
                          title: widget.title,
                          breadcrumb: widget.breadcrumb,
                          user: user,
                          unreadCount: widget.unreadCount,
                        ),
                        Expanded(
                          child: Container(
                            color: const Color(0xFFF8FAFC),
                            padding: const EdgeInsets.all(AppDimensions.spacingMd),
                            child: widget.child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (constraints.maxWidth >= 1024) {
                return content;
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: 1024, child: content),
              );
            },
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.user, required this.unreadCount});

  final UserModel? user;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final businessName = user?.businessName ?? 'PakPOS Business';
    final branchName = user?.branchId != null
        ? 'Branch ${user!.branchId!.substring(0, 8)}'
        : 'Main Branch';

    return Material(
      color: Colors.transparent,
      child: Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 64,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('☪', style: TextStyle(fontSize: 24, color: AppColors.primary)),
                  SizedBox(width: 8),
                  Text(
                    'PakPOS',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9F4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  branchName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                const _SectionLabel('MAIN'),
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  routePath: RouteNames.dashboard,
                  isActive: location == RouteNames.dashboard,
                ),
                _NavItem(
                  icon: Icons.point_of_sale,
                  label: 'Point of Sale',
                  routePath: RouteNames.pos,
                  isActive: location == RouteNames.pos,
                ),
                const _SectionLabel('CATALOG'),
                _NavItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Products',
                  routePath: RouteNames.products,
                  isActive: location.startsWith(RouteNames.products),
                ),
                const _SectionLabel('INVENTORY'),
                _NavItem(
                  icon: Icons.warehouse_outlined,
                  label: 'Inventory',
                  routePath: RouteNames.inventory,
                  isActive: location.startsWith(RouteNames.inventory),
                ),
                _NavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Purchases',
                  routePath: RouteNames.purchases,
                  isActive: location.startsWith(RouteNames.purchases),
                ),
                const _SectionLabel('SALES'),
                _NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Sales',
                  routePath: RouteNames.sales,
                  isActive: location.startsWith(RouteNames.sales),
                ),
                _NavItem(
                  icon: Icons.assignment_return_outlined,
                  label: 'Returns',
                  routePath: RouteNames.returns,
                  isActive: location.startsWith(RouteNames.returns),
                ),
                _NavItem(
                  icon: Icons.people_outline,
                  label: 'Customers',
                  routePath: RouteNames.customers,
                  isActive: location.startsWith(RouteNames.customers),
                ),
                const _SectionLabel('FINANCE'),
                _NavItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Expenses',
                  routePath: RouteNames.expenses,
                  isActive: location.startsWith(RouteNames.expenses),
                ),
                _NavItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Suppliers',
                  routePath: RouteNames.suppliers,
                  isActive: location.startsWith(RouteNames.suppliers),
                ),
                _NavItem(
                  icon: Icons.point_of_sale_outlined,
                  label: 'Cash Register',
                  routePath: RouteNames.cashRegister,
                  isActive: location.startsWith(RouteNames.cashRegister),
                ),
                const _SectionLabel('REPORTS'),
                _NavItem(
                  icon: Icons.bar_chart_outlined,
                  label: 'Analytics',
                  routePath: RouteNames.analytics,
                  isActive: location.startsWith(RouteNames.analytics),
                ),
                const _SectionLabel('SYSTEM'),
                _NavItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  routePath: RouteNames.settings,
                  isActive: location.startsWith(RouteNames.settings),
                ),
                _NavItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  routePath: RouteNames.notifications,
                  isActive: location.startsWith(RouteNames.notifications),
                  badgeCount: unreadCount,
                ),
              ],
            ),
          ),
          _SidebarFooter(user: user),
        ],
      ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 0.7,
          color: Color(0xFF94A3B8),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
                size: 20,
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
                  ),
                ),
              ),
              if (widget.badgeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter({required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'PakPOS User';
    final role = user?.role ?? 'owner';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Text(
              _initials(name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.primary,
            onPressed: () async {
              await sl<AuthRepository>().logout();
              sl<AuthGuard>().setAuthenticated(false);
              if (context.mounted) context.go(RouteNames.login);
            },
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.breadcrumb,
    required this.user,
    required this.unreadCount,
  });

  final String title;
  final String breadcrumb;
  final UserModel? user;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  breadcrumb,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Flexible(
            child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () async {
              final route = await showSearch<String?>(
                context: context,
                delegate: _GlobalSearchDelegate(),
              );
              if (route != null && context.mounted) context.go(route);
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 320),
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Search products, customers...',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
          const SizedBox(width: 14),
          StreamBuilder<int>(
            stream: Stream<int>.periodic(const Duration(seconds: 1), (x) => x),
            builder: (context, _) => Text(
              DateFormat('EEE, dd MMM yyyy  hh:mm a').format(DateTime.now()),
              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 14),
          Stack(
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => context.go(RouteNames.notifications),
                icon: const Icon(Icons.notifications_none_rounded),
                color: AppColors.primary,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user?.branchId != null
                  ? 'Branch ${user!.branchId!.substring(0, 6)}'
                  : 'Main Branch',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          PopupMenuButton<String>(
            tooltip: 'User menu',
            onSelected: (value) async {
              if (value == 'logout') {
                await sl<AuthRepository>().logout();
                sl<AuthGuard>().setAuthenticated(false);
                if (context.mounted) context.go(RouteNames.login);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.primary,
              child: Text(
                _initials(user?.name ?? 'U'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SearchRouteItem {
  const _SearchRouteItem(this.label, this.route);
  final String label;
  final String route;
}

class _GlobalSearchDelegate extends SearchDelegate<String?> {
  _GlobalSearchDelegate()
      : _items = const [
          _SearchRouteItem('Dashboard', RouteNames.dashboard),
          _SearchRouteItem('Point of Sale', RouteNames.pos),
          _SearchRouteItem('Products', RouteNames.products),
          _SearchRouteItem('Inventory', RouteNames.inventory),
          _SearchRouteItem('Purchases', RouteNames.purchases),
          _SearchRouteItem('Sales', RouteNames.sales),
          _SearchRouteItem('Returns', RouteNames.returns),
          _SearchRouteItem('Customers', RouteNames.customers),
          _SearchRouteItem('Expenses', RouteNames.expenses),
          _SearchRouteItem('Suppliers', RouteNames.suppliers),
          _SearchRouteItem('Cash Register', RouteNames.cashRegister),
          _SearchRouteItem('Analytics', RouteNames.analytics),
          _SearchRouteItem('Settings', RouteNames.settings),
          _SearchRouteItem('Notifications', RouteNames.notifications),
        ];

  final List<_SearchRouteItem> _items;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? _items
        : _items.where((item) => item.label.toLowerCase().contains(q)).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(item.label),
          onTap: () => close(context, item.route),
        );
      },
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return 'U';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
