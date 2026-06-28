import 'package:frantend/shared/widgets/tables/app_data_table_pagination.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';

export 'app_table_pagination_helpers.dart'
    show AppTablePaginationHelpers, AppTablePaginationMode;

/// Backwards-compatible wrapper — prefer [AppTablePaginationHelpers].
abstract final class ClientTablePagination {
  static int totalPages(int itemCount, int pageSize) =>
      AppTablePaginationHelpers.totalPages(itemCount, pageSize);

  static List<T> pageSlice<T>(List<T> items, int page, int pageSize) =>
      AppTablePaginationHelpers.pageSlice(items, page, pageSize);

  static AppDataTablePaginationData data({
    required int totalItems,
    required int currentPage,
    required int pageSize,
    required String itemLabel,
    required void Function(int) onPageSizeChanged,
    required void Function(int) onGoToPage,
  }) =>
      AppTablePaginationHelpers.client(
        totalItems: totalItems,
        currentPage: currentPage,
        pageSize: pageSize,
        itemLabel: itemLabel,
        onPageSizeChanged: onPageSizeChanged,
        onGoToPage: onGoToPage,
      );
}
