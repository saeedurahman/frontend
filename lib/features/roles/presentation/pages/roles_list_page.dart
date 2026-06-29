import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_state.dart';
import 'package:frantend/features/roles/presentation/utils/roles_navigation.dart';
import 'package:frantend/features/roles/presentation/widgets/roles_data_table.dart';
import 'package:frantend/features/roles/presentation/widgets/roles_empty_state.dart';
import 'package:frantend/features/roles/presentation/widgets/roles_list_toolbar.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class RolesListPage extends StatelessWidget {
  const RolesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RolesListCubit>()..init(),
      child: const _RolesListView(),
    );
  }
}

class _RolesListView extends StatelessWidget {
  const _RolesListView();

  Future<void> _openCreate(BuildContext context) =>
      openRoleForm(context, RouteNames.settingsRoleNew);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RolesListCubit, RolesListState>(
      listener: (context, state) {
        if (state is RolesListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is RolesListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to manage roles",
          );
        }

        final count = switch (state) {
          RolesListLoaded(:final roles) => roles.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RolesListToolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                RolesListInitial() || RolesListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                RolesListLoaded(:final roles) when roles.isEmpty =>
                  RolesEmptyState(onCreate: () => _openCreate(context)),
                RolesListLoaded(:final roles) => RolesDataTable(roles: roles),
                RolesListError(:final message) => Center(
                    child: Text(message),
                  ),
                RolesListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}
