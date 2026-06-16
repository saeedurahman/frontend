import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Container(
      width: AppDimensions.sidebarWidth,
      color: AppColors.surfaceDark,
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.spacingLg),
          const Padding(
            padding: EdgeInsets.all(AppDimensions.spacingMd),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.store, color: AppColors.textOnPrimary),
                ),
                SizedBox(width: AppDimensions.spacingSm),
                Text(
                  'Frantend POS',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.spacingSm),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: RouteNames.dashboard,
                  isSelected: location == RouteNames.dashboard,
                ),
                _SidebarItem(
                  icon: Icons.point_of_sale,
                  label: 'POS',
                  route: RouteNames.pos,
                  isSelected: location == RouteNames.pos,
                ),
                _SidebarItem(
                  icon: Icons.inventory_2,
                  label: 'Products',
                  route: RouteNames.products,
                  isSelected: location.startsWith(RouteNames.products),
                ),
                _SidebarItem(
                  icon: Icons.warehouse,
                  label: 'Inventory',
                  route: RouteNames.inventory,
                  isSelected: location.startsWith(RouteNames.inventory),
                ),
                _SidebarItem(
                  icon: Icons.receipt_long,
                  label: 'Sales',
                  route: RouteNames.sales,
                  isSelected: location.startsWith(RouteNames.sales),
                ),
                _SidebarItem(
                  icon: Icons.people,
                  label: 'Customers',
                  route: RouteNames.customers,
                  isSelected: location.startsWith(RouteNames.customers),
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  route: RouteNames.settings,
                  isSelected: location.startsWith(RouteNames.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final String route;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.accent : AppColors.textOnPrimary,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textOnPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        onTap: () => context.go(route),
      ),
    );
  }
}
