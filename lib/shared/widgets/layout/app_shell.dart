import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/branches/presentation/widgets/branch_selector_chip.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:frantend/features/notifications/presentation/widgets/notification_bell_button.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.breadcrumb,
    required this.child,
  });

  final String title;
  final String breadcrumb;
  final Widget child;

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

        return BlocBuilder<NotificationsCubit, NotificationsState>(
          bloc: sl<NotificationsCubit>(),
          builder: (context, notifState) {
            final unreadCount = switch (notifState) {
              NotificationsLoaded(:final unreadCount) => unreadCount,
              _ => 0,
            };

            return Scaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final content = Row(
                    children: [
                      _Sidebar(user: user, unreadCount: unreadCount),
                      Expanded(
                        child: Column(
                          children: [
                            _TopBar(
                              title: widget.title,
                              breadcrumb: widget.breadcrumb,
                              user: user,
                            ),
                            Expanded(
                              child: Container(
                                color: const Color(0xFFF8FAFC),
                                padding: const EdgeInsets.all(
                                  AppDimensions.spacingMd,
                                ),
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
            SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/app_logos/pk.png',
                      height: 92,
                      width: 92,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8),
                    const Text(
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
                  BlocBuilder<BranchSelectorCubit, BranchSelectorState>(
                    bloc: sl<BranchSelectorCubit>(),
                    builder: (context, branchState) {
                      return Text(
                        branchState.selectedBranchName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      );
                    },
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
                  if (UserRoleUtils.canCreateSales(
                    role: user?.role,
                    permissionKeys: user?.permissionKeys ?? const [],
                  ))
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
                  if (_showTablesNav(user))
                    _NavItem(
                      icon: Icons.table_restaurant_outlined,
                      label: 'Tables',
                      routePath: RouteNames.restaurantTables,
                      isActive: location.startsWith(RouteNames.restaurantTables),
                    ),
                  if (_showKitchenNav(user))
                    _NavItem(
                      icon: Icons.kitchen_outlined,
                      label: 'Kitchen',
                      routePath: RouteNames.kitchen,
                      isActive: location.startsWith(RouteNames.kitchen),
                    ),
                  if (UserRoleUtils.canViewReturns(
                    role: user?.role,
                    permissionKeys: user?.permissionKeys ?? const [],
                  ))
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
                  if (UserRoleUtils.canViewShifts(
                    role: user?.role,
                    permissionKeys: user?.permissionKeys ?? const [],
                  ))
                    _NavItem(
                      icon: Icons.point_of_sale_outlined,
                      label: 'Cash Register',
                      routePath: RouteNames.cashRegister,
                      isActive: location.startsWith(RouteNames.cashRegister),
                    ),
                  if (UserRoleUtils.canViewReports(user?.role)) ...[
                    const _SectionLabel('REPORTS'),
                    _NavItem(
                      icon: Icons.bar_chart_outlined,
                      label: 'Analytics',
                      routePath: RouteNames.analytics,
                      isActive: location.startsWith(RouteNames.analytics),
                    ),
                  ],
                  const _SectionLabel('SYSTEM'),
                  if (UserRoleUtils.canViewUsers(
                    role: user?.role,
                    permissionKeys: user?.permissionKeys ?? const [],
                  ))
                    _NavItem(
                      icon: Icons.badge_outlined,
                      label: 'Staff',
                      routePath: RouteNames.staff,
                      isActive: location.startsWith(RouteNames.staff),
                    ),
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
                  if (UserRoleUtils.isOwner(user?.role))
                    _NavItem(
                      icon: Icons.history_outlined,
                      label: 'Audit Logs',
                      routePath: RouteNames.auditLogs,
                      isActive: location.startsWith(RouteNames.auditLogs),
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
          fontSize: 14,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.primary,
            onPressed: () async {
              sl<NotificationsCubit>().stopSession();
              sl<BranchSelectorCubit>().stopSession();
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
  });

  final String title;
  final String breadcrumb;
  final UserModel? user;

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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
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
                    delegate: _GlobalSearchDelegate(user: user),
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
            const SizedBox(width: 24),
            StreamBuilder<int>(
              stream: Stream<int>.periodic(
                const Duration(seconds: 1),
                (x) => x,
              ),
              builder: (context, _) => Text(
                DateFormat('EEE, dd MMM yyyy  hh:mm a').format(DateTime.now()),
                style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
            ),
            const SizedBox(width: 14),
            const NotificationBellButton(),
            const SizedBox(width: 16),
            const BranchSelectorChip(),
            const SizedBox(width: 20),
            PopupMenuButton<String>(
              tooltip: 'User menu',
              onSelected: (value) async {
                if (value == 'logout') {
                  sl<NotificationsCubit>().stopSession();
                  sl<BranchSelectorCubit>().stopSession();
                  await sl<AuthRepository>().logout();
                  sl<AuthGuard>().setAuthenticated(false);
                  if (context.mounted) context.go(RouteNames.login);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout', style: TextStyle(fontSize: 16)),
                ),
              ],
              child: CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary,
                child: Text(
                  _initials(user?.name ?? 'U'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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
  _GlobalSearchDelegate({this.user})
    : _items = [
        const _SearchRouteItem('Dashboard', RouteNames.dashboard),
        if (UserRoleUtils.canCreateSales(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        ))
          const _SearchRouteItem('Point of Sale', RouteNames.pos),
        if (_showTablesNav(user))
          const _SearchRouteItem('Tables', RouteNames.restaurantTables),
        if (_showKitchenNav(user))
          const _SearchRouteItem('Kitchen', RouteNames.kitchen),
        const _SearchRouteItem('Products', RouteNames.products),
        const _SearchRouteItem('Inventory', RouteNames.inventory),
        const _SearchRouteItem('Purchases', RouteNames.purchases),
        const _SearchRouteItem('Sales', RouteNames.sales),
        if (UserRoleUtils.canViewReturns(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        ))
          const _SearchRouteItem('Returns', RouteNames.returns),
        const _SearchRouteItem('Customers', RouteNames.customers),
        const _SearchRouteItem('Expenses', RouteNames.expenses),
        const _SearchRouteItem('Suppliers', RouteNames.suppliers),
        if (UserRoleUtils.canViewShifts(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        ))
          const _SearchRouteItem('Cash Register', RouteNames.cashRegister),
        if (UserRoleUtils.canViewReports(user?.role))
          const _SearchRouteItem('Analytics', RouteNames.analytics),
        if (UserRoleUtils.isOwner(user?.role))
          const _SearchRouteItem('Audit Logs', RouteNames.auditLogs),
        const _SearchRouteItem('Settings', RouteNames.settings),
        const _SearchRouteItem('Notifications', RouteNames.notifications),
      ];

  final UserModel? user;
  final List<_SearchRouteItem> _items;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
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

bool _showTablesNav(UserModel? user) {
  final flags = sl<BusinessSessionCubit>().state.flags;
  return flags.showTablesNav &&
      UserRoleUtils.canViewTables(
        role: user?.role,
        permissionKeys: user?.permissionKeys ?? const [],
      );
}

bool _showKitchenNav(UserModel? user) {
  final flags = sl<BusinessSessionCubit>().state.flags;
  return flags.showKitchenNav &&
      UserRoleUtils.canViewKot(
        role: user?.role,
        permissionKeys: user?.permissionKeys ?? const [],
      ) &&
      !UserRoleUtils.isKitchenOnlyUser(
        role: user?.role,
        permissionKeys: user?.permissionKeys ?? const [],
      );
}
