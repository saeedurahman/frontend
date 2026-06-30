import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_state.dart';
import 'package:frantend/features/users/presentation/widgets/users_data_table.dart';
import 'package:frantend/features/users/presentation/widgets/users_empty_state.dart';
import 'package:frantend/features/users/presentation/widgets/users_list_toolbar.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersListCubit>()..init(),
      child: const _UsersListView(),
    );
  }
}

class _UsersListView extends StatelessWidget {
  const _UsersListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersListCubit, UsersListState>(
      listener: (context, state) {
        if (state is UsersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is UsersListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view staff",
          );
        }

        final count = switch (state) {
          UsersListLoaded(:final users) => users.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UsersListToolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                UsersListInitial() || UsersListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                UsersListLoaded(:final users) when users.isEmpty =>
                  const UsersEmptyState(),
                UsersListLoaded(:final users) => UsersDataTable(users: users),
                UsersListError(:final message) => Center(child: Text(message)),
                UsersListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}
