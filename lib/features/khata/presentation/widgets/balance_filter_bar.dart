import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/features/khata/domain/balance_filter.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/list_filter_text.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';

/// "Owes me" / "I owe", "Advance" and the balance order, for the customer and
/// supplier lists.
class BalanceFilterBar extends StatelessWidget {
  const BalanceFilterBar({
    super.key,
    required this.type,
    required this.filter,
    required this.sort,
    required this.onFilter,
    required this.onSort,
  });

  final PartyType type;
  final BalanceFilter filter;
  final BalanceSort sort;
  final ValueChanged<BalanceFilter> onFilter;
  final ValueChanged<BalanceSort> onSort;

  @override
  Widget build(BuildContext context) {
    const sortLabels = {
      BalanceSort.none: ListFilterText.sortDefault,
      BalanceSort.highest: ListFilterText.sortHighest,
      BalanceSort.lowest: ListFilterText.sortLowest,
    };
    Widget pill(BalanceFilter value, String label, Color color, String help) =>
        Tooltip(
          message: help,
          child: KhataFilterPill(
            key: ValueKey('balance-filter-${value.name}'),
            label: label,
            color: color,
            selected: filter == value,
            // A second tap shows everyone again.
            onTap: () =>
                onFilter(filter == value ? BalanceFilter.all : value),
          ),
        );

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        pill(
          BalanceFilter.owing,
          type.isCustomer ? ListFilterText.owesMe : ListFilterText.iOwe,
          AppColors.error,
          type.isCustomer
              ? ListFilterText.owesMeHelp
              : ListFilterText.iOweHelp,
        ),
        pill(
          BalanceFilter.advance,
          ListFilterText.advance,
          AppColors.info,
          type.isCustomer
              ? ListFilterText.customerAdvanceHelp
              : ListFilterText.supplierAdvanceHelp,
        ),
        PopupMenuButton<BalanceSort>(
          key: const Key('balance-sort'),
          tooltip: ListFilterText.sortTooltip,
          initialValue: sort,
          onSelected: onSort,
          itemBuilder: (_) => [
            for (final entry in sortLabels.entries)
              CheckedPopupMenuItem<BalanceSort>(
                key: ValueKey('balance-sort-${entry.key.name}'),
                value: entry.key,
                checked: sort == entry.key,
                child: Text(entry.value),
              ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingSm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_vert, size: 16),
                const SizedBox(width: AppDimensions.spacingXs),
                Text(
                  sortLabels[sort]!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
