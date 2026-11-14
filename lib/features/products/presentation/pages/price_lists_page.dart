import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/products/data/models/price_list_detail_models.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/presentation/cubit/price_lists_cubit.dart';
import 'package:frantend/features/products/presentation/pages/price_list_dialogs.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/utils/app_alerts.dart';

class PriceListsPage extends StatelessWidget {
  const PriceListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PriceListsCubit>()..loadPriceLists(),
      child: const _PriceListsView(),
    );
  }
}

class _PriceListsView extends StatefulWidget {
  const _PriceListsView();

  @override
  State<_PriceListsView> createState() => _PriceListsViewState();
}

class _PriceListsViewState extends State<_PriceListsView> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String val, PriceListsCubit cubit) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      cubit.loadItems(search: val.trim(), skip: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PriceListsCubit>();

    return BlocConsumer<PriceListsCubit, PriceListsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
          cubit.clearMessages();
        }
        if (state.successMessage != null) {
          AppAlerts.showSuccessMessage(context, state.successMessage!);
          cubit.clearMessages();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!state.isOnline)
                Container(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline mode: Viewing cached price lists is available. Editing price lists requires an active internet connection.',
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Panel: Lists master selector
                    SizedBox(
                      width: 340,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(right: BorderSide(color: AppColors.border)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(AppDimensions.spacingMd),
                              child: Row(
                                children: [
                                  const Text(
                                    'Price Lists',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    ),
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text('New', style: TextStyle(fontSize: 12)),
                                    onPressed: !state.isOnline
                                        ? null
                                        : () => PriceListFormDialog.show(
                                              context,
                                              onSave: cubit.createPriceList,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Expanded(
                              child: state.isLoadingLists
                                  ? const Center(child: CircularProgressIndicator())
                                  : state.priceLists.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              'No price lists found.',
                                              style: TextStyle(color: Colors.grey.shade600),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.all(8),
                                          itemCount: state.priceLists.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                                          itemBuilder: (context, idx) {
                                            final list = state.priceLists[idx];
                                            final isSelected = list.id == state.selectedListId;
                                            return _PriceListTile(
                                              list: list,
                                              isSelected: isSelected,
                                              isOnline: state.isOnline,
                                              onSelect: () => cubit.selectList(list.id),
                                              onEdit: () => PriceListFormDialog.show(
                                                context,
                                                initialList: list,
                                                onSave: ({
                                                  required name,
                                                  required listType,
                                                  isDefault = false,
                                                  isActive = true,
                                                  validFrom,
                                                  validTo,
                                                }) =>
                                                    cubit.updatePriceList(
                                                  list.id,
                                                  name: name,
                                                  listType: listType,
                                                  isDefault: isDefault,
                                                  isActive: isActive,
                                                  validFrom: validFrom,
                                                  validTo: validTo,
                                                ),
                                              ),
                                              onSetDefault: () => cubit.setDefault(list.id),
                                              onCopy: () => PriceListCopyDialog.show(
                                                context,
                                                sourceList: list,
                                                onCopy: ({
                                                  required name,
                                                  percent,
                                                  listType,
                                                  validFrom,
                                                  validTo,
                                                }) =>
                                                    cubit.copyPriceList(
                                                  list.id,
                                                  name: name,
                                                  percent: percent,
                                                  listType: listType,
                                                  validFrom: validFrom,
                                                  validTo: validTo,
                                                ),
                                              ),
                                              onDelete: () => _confirmDeleteList(context, list, cubit),
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Panel: Selected Price List Product Grid
                    Expanded(
                      child: state.selectedList == null
                          ? const Center(child: Text('Select a price list to view and manage prices.'))
                          : _PriceListDetailPanel(
                              list: state.selectedList!,
                              state: state,
                              cubit: cubit,
                              searchController: _searchController,
                              onSearchChanged: (val) => _onSearchChanged(val, cubit),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteList(
    BuildContext context,
    PriceListModel list,
    PriceListsCubit cubit,
  ) async {
    if (list.isDefault) {
      AppAlerts.showErrorMessage(context, 'The default price list cannot be deleted.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${list.name}"?'),
        content: Text(
          'Are you sure you want to delete this price list? Any customers currently assigned to "${list.name}" will automatically fall back to the default list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deletePriceList(list.id);
    }
  }
}

// ── Left Side: Master Price List Tile ───────────────────────────────────────

class _PriceListTile extends StatelessWidget {
  const _PriceListTile({
    required this.list,
    required this.isSelected,
    required this.isOnline,
    required this.onSelect,
    required this.onEdit,
    required this.onSetDefault,
    required this.onCopy,
    required this.onDelete,
  });

  final PriceListModel list;
  final bool isSelected;
  final bool isOnline;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    list.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                ),
                if (list.isDefault) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onSelected: (val) {
                    if (!isOnline) {
                      AppAlerts.showErrorMessage(context, 'Modifying price lists requires internet.');
                      return;
                    }
                    if (val == 'edit') onEdit();
                    if (val == 'default') onSetDefault();
                    if (val == 'copy') onCopy();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit Details')),
                    if (!list.isDefault) const PopupMenuItem(value: 'default', child: Text('Set as Default')),
                    const PopupMenuItem(value: 'copy', child: Text('Copy List')),
                    if (!list.isDefault)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete List', style: TextStyle(color: AppColors.error)),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    list.listType.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 6),
                if (!list.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'INACTIVE',
                      style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.w600),
                    ),
                  ),
                const Spacer(),
                Text(
                  '${list.itemCount} items',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 6),
                Text(
                  '${list.customerCount} cust',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
            if (list.validFrom != null || list.validTo != null) ...[
              const SizedBox(height: 4),
              Text(
                'Valid: ${list.validFrom?.split('T').first ?? 'Start'} to ${list.validTo?.split('T').first ?? 'Indefinite'}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Right Side: Price List Detail Panel & Price Grid ────────────────────────

class _PriceListDetailPanel extends StatelessWidget {
  const _PriceListDetailPanel({
    required this.list,
    required this.state,
    required this.cubit,
    required this.searchController,
    required this.onSearchChanged,
  });

  final PriceListModel list;
  final PriceListsState state;
  final PriceListsCubit cubit;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Toolbar
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            list.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          if (list.isDefault)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        'Type: ${list.listType.toUpperCase()} | Total products priced: ${state.totalItems}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.percent, size: 16),
                    label: const Text('Bulk % Adjust'),
                    onPressed: !state.isOnline ? null : () => PriceListAdjustDialog.show(context, cubit),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.file_upload_outlined, size: 16),
                    label: const Text('Import CSV'),
                    onPressed: !state.isOnline ? null : () => PriceListImportDialog.show(context, cubit),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    label: 'Add Price',
                    onPressed: !state.isOnline
                        ? null
                        : () => PriceItemFormDialog.show(
                              context,
                              onSave: cubit.savePriceItem,
                            ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search input
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search products by name or SKU in this price list...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: onSearchChanged,
              ),
            ],
          ),
        ),

        // Products Grid / Table
        Expanded(
          child: state.isLoadingItems
              ? const Center(child: CircularProgressIndicator())
              : state.items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.price_check_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? 'No prices match "${state.searchQuery}"'
                                : 'No custom prices defined for this list yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Products without a custom price here use their base price from the default list.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 16),
                          if (state.isOnline)
                            PrimaryButton(
                              label: 'Add First Price',
                              onPressed: () => PriceItemFormDialog.show(
                                context,
                                onSave: cubit.savePriceItem,
                              ),
                            ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Table header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          color: Colors.grey.shade100,
                          child: const Row(
                            children: [
                              Expanded(flex: 2, child: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 4, child: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 3, child: Text('Variation', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Min Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Unit Price', style: TextStyle(fontWeight: FontWeight.bold))),
                              SizedBox(width: 100, child: Text('Actions', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.items.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, idx) {
                              final item = state.items[idx];
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                color: idx.isEven ? Colors.white : Colors.grey.shade50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(item.sku ?? '-', style: const TextStyle(fontSize: 13, fontFamily: 'monospace')),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(item.variationName ?? 'Base product', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text('${item.minQty} units', style: const TextStyle(fontSize: 12)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Rs ${item.unitPrice}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 18),
                                            tooltip: 'Edit Price',
                                            onPressed: !state.isOnline
                                                ? null
                                                : () => PriceItemFormDialog.show(
                                                      context,
                                                      initialItem: item,
                                                      onSave: cubit.savePriceItem,
                                                    ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                            tooltip: 'Remove Price',
                                            onPressed: !state.isOnline
                                                ? null
                                                : () => _confirmDeleteItem(context, item, cubit),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Pagination bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(top: BorderSide(color: AppColors.border)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Showing ${state.items.isEmpty ? 0 : state.skip + 1} - ${state.skip + state.items.length} of ${state.totalItems} prices',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left),
                                    onPressed: state.skip > 0
                                        ? () => cubit.loadItems(skip: (state.skip - state.limit).clamp(0, double.infinity).toInt())
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right),
                                    onPressed: state.skip + state.items.length < state.totalItems
                                        ? () => cubit.loadItems(skip: state.skip + state.limit)
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    PriceListItemDetailModel item,
    PriceListsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Price?'),
        content: Text(
          'Remove price tier of Rs ${item.unitPrice} for "${item.productName}"? It will fall back to the default price.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.deletePriceItem(item.id);
    }
  }
}
