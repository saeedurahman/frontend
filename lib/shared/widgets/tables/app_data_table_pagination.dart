import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

class AppDataTablePaginationData {
  const AppDataTablePaginationData({
    required this.from,
    required this.to,
    required this.total,
    required this.itemLabel,
    this.currentPage = 1,
    this.totalPages = 1,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 25, 50],
    this.onPageSizeChanged,
    this.onGoToPage,
  });

  final int from;
  final int to;
  final int total;
  final String itemLabel;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final ValueChanged<int>? onGoToPage;
}

class AppDataTablePaginationFooter extends StatelessWidget {
  const AppDataTablePaginationFooter({super.key, required this.data});

  final AppDataTablePaginationData data;

  @override
  Widget build(BuildContext context) {
    final showPageControls = data.onGoToPage != null && data.totalPages > 1;
    final showPageSize = data.onPageSizeChanged != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Text(
            'Showing ${data.from} to ${data.to} of ${data.total} ${data.itemLabel}',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (showPageSize) ...[
            const Text(
              'Rows per page',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: data.pageSizeOptions.contains(data.pageSize)
                      ? data.pageSize
                      : data.pageSizeOptions.first,
                  items: data.pageSizeOptions
                      .map(
                        (size) => DropdownMenuItem(
                          value: size,
                          child: Text('$size'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) data.onPageSizeChanged!(value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          if (showPageControls) ...[
            _PaginationIconButton(
              icon: Icons.first_page,
              onPressed: data.currentPage > 1
                  ? () => data.onGoToPage!(1)
                  : null,
            ),
            _PaginationIconButton(
              icon: Icons.chevron_left,
              onPressed: data.currentPage > 1
                  ? () => data.onGoToPage!(data.currentPage - 1)
                  : null,
            ),
            _PaginationPageButton(page: data.currentPage),
            _PaginationIconButton(
              icon: Icons.chevron_right,
              onPressed: data.currentPage < data.totalPages
                  ? () => data.onGoToPage!(data.currentPage + 1)
                  : null,
            ),
            _PaginationIconButton(
              icon: Icons.last_page,
              onPressed: data.currentPage < data.totalPages
                  ? () => data.onGoToPage!(data.totalPages)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaginationIconButton extends StatelessWidget {
  const _PaginationIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              icon,
              size: 18,
              color: onPressed != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaginationPageButton extends StatelessWidget {
  const _PaginationPageButton({required this.page});

  final int page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.brandingPanel,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$page',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
