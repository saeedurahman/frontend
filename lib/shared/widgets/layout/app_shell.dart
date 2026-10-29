import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/branches/presentation/widgets/branch_selector_chip.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:frantend/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:frantend/features/notifications/presentation/widgets/notification_bell_button.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/subscription/presentation/widgets/subscription_banner.dart';
import 'package:frantend/shared/widgets/layout/app_nav.dart';
import 'package:frantend/shared/widgets/sync/offline_banner.dart';
import 'package:frantend/shared/widgets/sync/sync_status_chip.dart';
import 'package:frantend/shared/widgets/layout/sign_out_flow.dart';
import 'package:frantend/utils/responsive/adaptive_layout.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _lastLocation;

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

            return LayoutBuilder(
              builder: (context, constraints) {
                final wide = Breakpoints.usesSidebar(constraints.maxWidth);
                final location = GoRouterState.of(context).uri.path;
                _closeDrawerOnNavigation(location);

                final sidebar = _Sidebar(user: user, unreadCount: unreadCount);
                final content = Column(
                  children: [
                    wide
                        ? _TopBar(
                            title: widget.title,
                            breadcrumb: widget.breadcrumb,
                            user: user,
                          )
                        : _CompactTopBar(title: widget.title),
                    const OfflineBanner(),
                    const SubscriptionBanner(),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF8FAFC),
                        padding: EdgeInsets.all(
                          wide ? AppDimensions.spacingMd : 8,
                        ),
                        child: widget.child,
                      ),
                    ),
                  ],
                );

                return Scaffold(
                  key: _scaffoldKey,
                  drawer: wide ? null : Drawer(width: 260, child: sidebar),
                  bottomNavigationBar: Breakpoints.usesBottomNav(
                    constraints.maxWidth,
                  )
                      ? _BottomNav(location: location)
                      : null,
                  body: wide
                      ? Row(children: [sidebar, Expanded(child: content)])
                      : content,
                );
              },
            );
          },
        );
      },
    );
  }

  /// The drawer stays mounted across ShellRoute navigations; close it once
  /// the user picked a destination.
  void _closeDrawerOnNavigation(String location) {
    final changed = _lastLocation != null && _lastLocation != location;
    _lastLocation = location;
    if (changed && _scaffoldKey.currentState?.isDrawerOpen == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldKey.currentState?.closeDrawer();
      });
    }
  }
}

/// Phone/tablet top bar: menu button, title, connection chip, bell.
class _CompactTopBar extends StatelessWidget {
  const _CompactTopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            IconButton(
              key: const Key('open-drawer'),
              tooltip: 'Menu',
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SyncStatusChip(onFailedTap: () => context.go(RouteNames.syncFailed)),
            const SizedBox(width: 4),
            const NotificationBellButton(),
          ],
        ),
      ),
    );
  }
}

/// The few destinations a phone user needs one tap away; everything else is
/// in the drawer ("More").
class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessCubit>().state.access;
    final flags = sl<BusinessSessionCubit>().state.flags;
    final visible = {
      for (final section in AppNav.visibleSections(access, flags))
        for (final entry in section.items) entry.route: entry,
    };
    final primary = [
      for (final route in const [
        RouteNames.dashboard,
        RouteNames.pos,
        RouteNames.sales,
      ])
        if (visible.containsKey(route)) visible[route]!,
    ];
    final selected = primary.indexWhere(
      (e) => e.route == RouteNames.dashboard
          ? location == RouteNames.dashboard
          : location.startsWith(e.route),
    );

    return NavigationBar(
      key: const Key('bottom-nav'),
      selectedIndex: selected < 0 ? primary.length : selected,
      onDestinationSelected: (i) {
        if (i < primary.length) {
          context.go(primary[i].route);
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
      destinations: [
        for (final e in primary)
          NavigationDestination(icon: Icon(e.icon), label: e.label),
        const NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
      ],
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
    final businessName =
        user?.businessName ?? '${AppBrand.current.shortName} Business';

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
                    Text(
                      AppBrand.current.shortName,
                      style: const TextStyle(
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
              child: SidebarNav(
                access: context.watch<AccessCubit>().state.access,
                flags: sl<BusinessSessionCubit>().state.flags,
                location: location,
                unreadCount: unreadCount,
              ),
            ),
            _SidebarFooter(user: user),
          ],
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
    final name = user?.name ?? '${AppBrand.current.shortName} User';
    final role = user?.role ?? '';

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
            onPressed: () => signOutWithGuard(context),
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
                    delegate: _GlobalSearchDelegate(
                      access: context.read<AccessCubit>().state.access,
                      flags: sl<BusinessSessionCubit>().state.flags,
                    ),
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
            SyncStatusChip(
              onFailedTap: () => context.go(RouteNames.syncFailed),
            ),
            const SizedBox(width: 12),
            const NotificationBellButton(),
            const SizedBox(width: 16),
            const BranchSelectorChip(),
            const SizedBox(width: 20),
            PopupMenuButton<String>(
              tooltip: 'User menu',
              onSelected: (value) async {
                if (value == 'logout') await signOutWithGuard(context);
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
  _GlobalSearchDelegate({required UserAccess access, required this.flags})
    : _items = [
        for (final entry in AppNav.visibleEntries(access, flags))
          _SearchRouteItem(entry.label, entry.route),
      ];

  final BusinessFeatureFlags flags;
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
