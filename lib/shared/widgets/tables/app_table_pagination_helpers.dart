import 'package:frantend/shared/widgets/tables/app_data_table_pagination.dart';

/// Pagination helpers for [AppPaginatedDataTable] and direct [AppDataTable] use.
abstract final class AppTablePaginationHelpers {
  static AppDataTablePaginationData client({
    required int totalItems,
    required int currentPage,
    required int pageSize,
    required String itemLabel,
    required void Function(int) onPageSizeChanged,
    required void Function(int) onGoToPage,
  }) {
    final pages = totalPages(totalItems, pageSize);
    final from = totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final to = (currentPage * pageSize).clamp(0, totalItems);

    return AppDataTablePaginationData(
      from: from,
      to: to == 0 && totalItems > 0 ? totalItems : to,
      total: totalItems,
      itemLabel: itemLabel,
      currentPage: currentPage.clamp(1, pages),
      totalPages: pages,
      pageSize: pageSize,
      onPageSizeChanged: onPageSizeChanged,
      onGoToPage: onGoToPage,
    );
  }

  static AppDataTablePaginationData server({
    required int skip,
    required int itemCount,
    required int total,
    required String itemLabel,
    required int currentPage,
    required int totalPages,
    required int pageSize,
    required void Function(int) onPageSizeChanged,
    required void Function(int) onGoToPage,
  }) {
    final from = total == 0 ? 0 : skip + 1;
    final to = (skip + itemCount).clamp(0, total);

    return AppDataTablePaginationData(
      from: from,
      to: to,
      total: total,
      itemLabel: itemLabel,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
      onPageSizeChanged: onPageSizeChanged,
      onGoToPage: onGoToPage,
    );
  }

  static AppDataTablePaginationData summary({
    required int total,
    required String itemLabel,
  }) {
    return AppDataTablePaginationData(
      from: total == 0 ? 0 : 1,
      to: total,
      total: total,
      itemLabel: itemLabel,
    );
  }

  static int totalPages(int itemCount, int pageSize) {
    if (itemCount == 0) return 1;
    return (itemCount / pageSize).ceil();
  }

  static List<T> pageSlice<T>(List<T> items, int page, int pageSize) {
    if (items.isEmpty || page < 1) return const [];
    final start = (page - 1) * pageSize;
    if (start >= items.length) return const [];
    return items.skip(start).take(pageSize).toList();
  }
}

/// How [AppPaginatedDataTable] applies pagination to [items].
enum AppTablePaginationMode {
  /// All items in memory; pages are sliced locally.
  client,

  /// [items] is already one server page; footer uses callbacks.
  server,

  /// All items shown; footer is count-only summary.
  summary,
}

/// Column sort: return negative / zero / positive like [Comparable.compareTo].
typedef AppDataTableColumnSort<T> = int Function(T a, T b, int columnIndex);
