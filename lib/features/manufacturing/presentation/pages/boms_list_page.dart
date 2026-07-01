import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/boms_list_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/boms_list_state.dart';
import 'package:frantend/features/manufacturing/presentation/utils/manufacturing_navigation.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/bom_status_chip.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:shimmer/shimmer.dart';

const _bomTableColumns = [
  AppDataTableColumn(label: 'Recipe', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Product', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Version', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Output qty', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Ingredients', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Updated', flex: 2, sortable: true),
];

class BomsListPage extends StatelessWidget {
  const BomsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BomsListCubit>()..init(),
      child: const _BomsListView(),
    );
  }
}

class _BomsListView extends StatefulWidget {
  const _BomsListView();

  @override
  State<_BomsListView> createState() => _BomsListViewState();
}

class _BomsListViewState extends State<_BomsListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BomsListCubit, BomsListState>(
      listener: (context, state) {
        if (state is BomsListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is BomsListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view BOMs",
          );
        }

        final count = switch (state) {
          BomsListLoaded(:final filteredBoms) => filteredBoms.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(
              total: count,
              canManage: state is BomsListLoaded && state.canManage,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is BomsListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                BomsListInitial() || BomsListLoading() => Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                BomsListLoaded(:final filteredBoms) when filteredBoms.isEmpty =>
                  const EmptyState(
                    icon: Icons.menu_book_outlined,
                    message: 'No BOMs found',
                  ),
                BomsListLoaded loaded => _BomsTable(
                    boms: loaded.filteredBoms,
                    canManage: loaded.canManage,
                  ),
                BomsListError(:final message) => Center(child: Text(message)),
                BomsListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.total, required this.canManage});

  final int total;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: () => openManufacturingHome(context),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Back to Production'),
        ),
        const SizedBox(width: 8),
        Text('BOMs (Recipes)', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total recipes)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        if (canManage)
          ElevatedButton.icon(
            onPressed: () async {
              final created = await openBomForm(context);
              if (created == true && context.mounted) {
                await context.read<BomsListCubit>().refresh();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New BOM'),
          ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final BomsListLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BomsListCubit>();
    final view = context.findAncestorStateOfType<_BomsListViewState>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            controller: view?._searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search recipe or product',
              isDense: true,
            ),
            onChanged: cubit.setSearchQuery,
          ),
        ),
        FilterChip(
          label: const Text('Active only'),
          selected: state.activeOnlyFilter,
          onSelected: cubit.setActiveOnlyFilter,
        ),
      ],
    );
  }
}

class _BomsTable extends StatelessWidget {
  const _BomsTable({required this.boms, required this.canManage});

  final List<BomHeaderModel> boms;
  final bool canManage;

  String _formatUpdated(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormatter.formatDateTime(parsed.toLocal());
  }

  int _sortCompare(BomHeaderModel a, BomHeaderModel b, int columnIndex) {
    return switch (columnIndex) {
      0 => a.name.compareTo(b.name),
      1 => a.productName.compareTo(b.productName),
      2 => a.version.compareTo(b.version),
      3 => a.outputQty.compareTo(b.outputQty),
      4 => a.isActive == b.isActive ? 0 : (a.isActive ? -1 : 1),
      5 => a.lines.length.compareTo(b.lines.length),
      6 => a.updatedAt.compareTo(b.updatedAt),
      _ => 0,
    };
  }

  Future<void> _openBom(BuildContext context, BomHeaderModel bom) async {
    final saved = await openBomForm(context, bomId: bom.id);
    if (saved == true && context.mounted) {
      await context.read<BomsListCubit>().refresh();
    }
  }

  Future<void> _confirmDelete(BuildContext context, BomHeaderModel bom) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete BOM?',
      message: 'Delete "${bom.name}" (v${bom.version})? This cannot be undone.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<BomsListCubit>().deleteBom(bom.id);
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'BOM deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<BomHeaderModel>(
      columns: _bomTableColumns,
      items: boms,
      itemId: (bom) => bom.id,
      itemLabel: 'recipes',
      paginationMode: AppTablePaginationMode.summary,
      sortCompare: _sortCompare,
      onRowTap: (bom) => _openBom(context, bom),
      rowBuilder: (context, bom, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _bomTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              bom.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              bom.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
            Text('v${bom.version}', style: const TextStyle(fontSize: 13)),
            Text(bom.outputQty, style: const TextStyle(fontSize: 13)),
            BomStatusChip(isActive: bom.isActive),
            Text('${bom.lines.length}', style: const TextStyle(fontSize: 13)),
            Text(
              _formatUpdated(bom.updatedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          actions: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canManage)
                AppTableActionButton(
                  icon: Icons.delete_outline,
                  tooltip: 'Delete',
                  onPressed: () => _confirmDelete(context, bom),
                ),
              AppTableActionButton(
                icon: Icons.chevron_right,
                tooltip: 'Edit',
                onPressed: () => _openBom(context, bom),
              ),
            ],
          ),
        );
      },
    );
  }
}
