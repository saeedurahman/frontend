import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';

class ReportSectionCard extends StatelessWidget {
  const ReportSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class ReportKpiTile extends StatelessWidget {
  const ReportKpiTile({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class ModuleLinkCard extends StatelessWidget {
  const ModuleLinkCard({
    super.key,
    required this.title,
    required this.description,
    required this.routeLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String routeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ReportSectionCard(
      title: title,
      child: Row(
        children: [
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(onPressed: onTap, child: Text(routeLabel)),
        ],
      ),
    );
  }
}

/// Embedded report table with green header, sort, and client pagination.
class ReportPaginatedTable<T> extends StatelessWidget {
  const ReportPaginatedTable({
    super.key,
    required this.columns,
    required this.items,
    required this.itemId,
    required this.rowBuilder,
    this.sortCompare,
    this.itemLabel = 'rows',
    this.initialPageSize = 10,
  });

  final List<AppDataTableColumn> columns;
  final List<T> items;
  final String Function(T item) itemId;
  final AppDataTableRowBuilder<T> rowBuilder;
  final AppDataTableColumnSort<T>? sortCompare;
  final String itemLabel;
  final int initialPageSize;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'No data for selected period',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return AppPaginatedDataTable<T>(
      columns: columns,
      items: items,
      itemId: itemId,
      rowBuilder: rowBuilder,
      sortCompare: sortCompare,
      itemLabel: itemLabel,
      initialPageSize: initialPageSize,
      paginationMode: AppTablePaginationMode.client,
      showSelection: false,
      showActions: false,
      embedded: true,
    );
  }
}

Widget reportTableText(
  String text, {
  bool secondary = false,
  FontWeight? fontWeight,
  Color? color,
}) {
  return Text(
    text,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 13,
      color: color ??
          (secondary ? AppColors.textSecondary : AppColors.textPrimary),
      fontWeight: fontWeight,
    ),
  );
}

AppDataTableRowLayout reportTableRow({
  required List<AppDataTableColumn> columns,
  required List<Widget> cells,
}) {
  return AppDataTableRowLayout(
    columns: columns,
    showSelection: false,
    selected: false,
    onSelected: (_) {},
    actionsWidth: 0,
    actions: const SizedBox.shrink(),
    cells: cells,
  );
}

double reportMoneySortKey(String? raw) => double.tryParse(raw ?? '') ?? 0;

String money(String? raw) {
  final v = double.tryParse(raw ?? '') ?? 0;
  return 'Rs. ${v.toStringAsFixed(2)}';
}

String pct(String? raw) {
  final v = double.tryParse(raw ?? '') ?? 0;
  return '${v.toStringAsFixed(1)}%';
}
