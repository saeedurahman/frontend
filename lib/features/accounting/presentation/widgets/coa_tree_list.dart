import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';
import 'package:frantend/features/accounting/presentation/widgets/account_type_chip.dart';
import 'package:frantend/features/accounting/presentation/widgets/coa_system_badge.dart';

class CoaTreeList extends StatelessWidget {
  const CoaTreeList({
    super.key,
    required this.roots,
    required this.onAccountTap,
    this.onDelete,
    this.canManage = false,
    this.filteredNodes,
  });

  final List<ChartOfAccountModel> roots;
  final List<FlatCoaNode>? filteredNodes;
  final ValueChanged<ChartOfAccountModel> onAccountTap;
  final ValueChanged<ChartOfAccountModel>? onDelete;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    if (filteredNodes != null) {
      return ListView.separated(
        itemCount: filteredNodes!.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final node = filteredNodes![index];
          return _CoaRow(
            account: node.account,
            depth: node.depth,
            canManage: canManage,
            onTap: () => onAccountTap(node.account),
            onDelete: onDelete == null ? null : () => onDelete!(node.account),
          );
        },
      );
    }

    return ListView.separated(
      itemCount: roots.length,
      separatorBuilder: (_, __) => const SizedBox.shrink(),
      itemBuilder: (context, index) => _CoaTreeNode(
        account: roots[index],
        depth: 0,
        canManage: canManage,
        onAccountTap: onAccountTap,
        onDelete: onDelete,
      ),
    );
  }
}

class _CoaTreeNode extends StatelessWidget {
  const _CoaTreeNode({
    required this.account,
    required this.depth,
    required this.canManage,
    required this.onAccountTap,
    this.onDelete,
  });

  final ChartOfAccountModel account;
  final int depth;
  final bool canManage;
  final ValueChanged<ChartOfAccountModel> onAccountTap;
  final ValueChanged<ChartOfAccountModel>? onDelete;

  @override
  Widget build(BuildContext context) {
    if (account.children.isEmpty) {
      return Column(
        children: [
          _CoaRow(
            account: account,
            depth: depth,
            canManage: canManage,
            onTap: () => onAccountTap(account),
            onDelete: onDelete == null ? null : () => onDelete!(account),
          ),
          const Divider(height: 1),
        ],
      );
    }

    return Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.only(left: 16 + depth * 20.0, right: 8),
          childrenPadding: EdgeInsets.zero,
          title: _CoaRowContent(account: account, depth: depth),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canManage && !account.isSystem && onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: 'Delete account',
                  onPressed: () => onDelete!(account),
                ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                tooltip: 'Open account',
                onPressed: () => onAccountTap(account),
              ),
            ],
          ),
          children: account.children
              .map(
                (child) => _CoaTreeNode(
                  account: child,
                  depth: depth + 1,
                  canManage: canManage,
                  onAccountTap: onAccountTap,
                  onDelete: onDelete,
                ),
              )
              .toList(),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _CoaRow extends StatelessWidget {
  const _CoaRow({
    required this.account,
    required this.depth,
    required this.canManage,
    required this.onTap,
    this.onDelete,
  });

  final ChartOfAccountModel account;
  final int depth;
  final bool canManage;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16 + depth * 20.0, vertical: 12),
        child: Row(
          children: [
            Expanded(child: _CoaRowContent(account: account, depth: depth)),
            if (canManage && !account.isSystem && onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                tooltip: 'Delete account',
                onPressed: onDelete,
              ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _CoaRowContent extends StatelessWidget {
  const _CoaRowContent({required this.account, required this.depth});

  final ChartOfAccountModel account;
  final int depth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(
            account.accountCode,
            style: AppTextStyles.labelLarge.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      account.accountName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (account.isSystem) ...[
                    const SizedBox(width: 8),
                    const CoaSystemBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  AccountTypeChip(
                    accountType: account.accountType,
                    accountSubtype: account.accountSubtype,
                  ),
                  CoaActiveChip(isActive: account.isActive),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
