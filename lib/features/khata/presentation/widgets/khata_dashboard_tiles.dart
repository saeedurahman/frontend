import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_overview_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:go_router/go_router.dart';

/// The hub address that opens on [type]'s tab.
String khataHubLocation(PartyType type) =>
    '${RouteNames.khata}?tab=${type.apiValue}';

/// "To receive" and "To pay" on the dashboard; a tap opens the khata hub on
/// that tab.
class KhataDashboardTiles extends StatelessWidget {
  const KhataDashboardTiles({super.key, this.createCubit, this.onOpen});

  final KhataOverviewCubit Function()? createCubit;
  final void Function(BuildContext context, PartyType type)? onOpen;

  KhataOverviewCubit _create() => KhataOverviewCubit(
        sl<KhataRepository>(),
        branchId: sl.isRegistered<BranchSelectorCubit>()
            ? sl<BranchSelectorCubit>().state.selectedBranchId
            : null,
        probe: sl.isRegistered<ConnectivityProbe>()
            ? sl<ConnectivityProbe>()
            : null,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (createCubit?.call() ?? _create())..load(),
      child: Builder(
        builder: (context) {
          final tiles = _Tiles(onOpen: onOpen);
          if (!sl.isRegistered<BranchSelectorCubit>()) return tiles;
          return BlocListener<BranchSelectorCubit, BranchSelectorState>(
            bloc: sl<BranchSelectorCubit>(),
            listenWhen: (a, b) =>
                a.selectedBranchId != b.selectedBranchId && b.isInitialized,
            listener: (context, branch) => context
                .read<KhataOverviewCubit>()
                .onBranchChanged(branch.selectedBranchId),
            child: tiles,
          );
        },
      ),
    );
  }
}

class _Tiles extends StatelessWidget {
  const _Tiles({this.onOpen});

  final void Function(BuildContext context, PartyType type)? onOpen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhataOverviewCubit, KhataOverviewState>(
      builder: (context, state) {
        final data = state.data;
        if (data == null && !state.loading) {
          return KhataCard(
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppDimensions.spacing12),
                Expanded(
                  child: Text(
                    state.error ?? KhataUiText.somethingWrong,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                TextButton(
                  onPressed: context.read<KhataOverviewCubit>().load,
                  child: const Text(KhataUiText.retry),
                ),
              ],
            ),
          );
        }
        Widget tile(PartyType type) => data == null
            ? const KhataTotalCardSkeleton(dense: true)
            : KhataTotalCard(
                key: ValueKey('dashboard-khata-${type.apiValue}'),
                type: type,
                side: data.value.side(type),
                dense: true,
                onTap: () => onOpen != null
                    ? onOpen!(context, type)
                    : context.go(khataHubLocation(type)),
              );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data != null && data.offline && data.asOf != null) ...[
              AsOfLabel(asOf: data.asOf!),
              const SizedBox(height: AppDimensions.spacingSm),
            ],
            LayoutBuilder(
              builder: (context, box) {
                final customer = tile(PartyType.customer);
                final supplier = tile(PartyType.supplier);
                if (box.maxWidth < 560) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      customer,
                      const SizedBox(height: AppDimensions.spacing12),
                      supplier,
                    ],
                  );
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: customer),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(child: supplier),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
