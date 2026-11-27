import 'package:dio/dio.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';

/// Announces every change the server accepts, so screens re-read without each
/// form having to tell them.
class DataChangeInterceptor extends Interceptor {
  DataChangeInterceptor({DataChangeBus? bus})
      : _bus = bus ?? DataChangeBus.instance;

  final DataChangeBus _bus;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      _announce(response.requestOptions, response.data);
    }
    handler.next(response);
  }

  /// A write whose answer never arrived may still have been saved: re-reading
  /// shows what really happened.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.receiveTimeout) {
      _announce(err.requestOptions, null);
    }
    handler.next(err);
  }

  void _announce(RequestOptions options, Object? data) {
    final method = options.method.toUpperCase();
    if (method == 'GET' || method == 'HEAD' || method == 'OPTIONS') return;
    final segments = _segments(options.path);
    final topics = topicsFor(segments);
    if (topics.isEmpty) return;
    final id = method == 'POST' && data is Map ? data['id'] : null;
    _bus.publish(
      topics,
      // Only a POST to a collection ("/suppliers") creates that record.
      createdIds:
          id is String && _isCollection(segments) ? {id} : const {},
    );
  }

  static const _nestedCollections = {
    'purchases/orders',
    'expenses/categories',
    'prices/lists',
    'accounting/coa',
    'accounting/journal-entries',
    'manufacturing/boms',
    'manufacturing/production-orders',
  };

  static bool _isCollection(List<String> segments) =>
      segments.length == 1 ||
      _nestedCollections.contains(segments.join('/'));

  static List<String> _segments(String path) {
    var segments = Uri.parse(path).pathSegments.where((s) => s.isNotEmpty).toList();
    // An absolute URL carries the "/api/v1" prefix.
    if (segments.length > 2 && segments.first == 'api') {
      segments = segments.sublist(2);
    }
    return segments;
  }

  /// What a write to [segments] (the path without the API prefix) changes.
  static Set<DataTopic> topicsFor(List<String> segments) {
    if (segments.isEmpty) return const {};
    final second = segments.length > 1 ? segments[1] : null;
    final last = segments.last;
    // POSTs that only read.
    if (last == 'price-preview' ||
        last == 'preview' ||
        segments.contains('receipt-link')) {
      return const {};
    }
    const money = {DataTopic.shifts, DataTopic.cashMovements};
    const customerMoney = {DataTopic.customers, DataTopic.customerLedger};
    const supplierMoney = {
      DataTopic.suppliers,
      DataTopic.supplierLedger,
      DataTopic.purchases,
    };
    return switch (segments.first) {
      'customers' => second == 'payments' || last == 'payments'
          ? {...customerMoney, ...money}
          : customerMoney,
      'suppliers' => second == 'payments'
          ? {...supplierMoney, ...money}
          // Opening balances, manual entries and their reversal move what we
          // owe; everything else only edits the supplier.
          : second == 'entries' ||
                  last == 'opening-balance' ||
                  last == 'manual-entry'
              ? supplierMoney
              : const {DataTopic.suppliers},
      'purchases' => second == 'receipts'
          ? {...supplierMoney, ...money, DataTopic.stock, DataTopic.products}
          : const {DataTopic.purchases},
      'expenses' => second == 'categories'
          ? const {DataTopic.expenseCategories}
          : {DataTopic.expenses, ...money},
      'products' => second == 'import'
          ? const {
              DataTopic.products,
              DataTopic.categories,
              DataTopic.brands,
              DataTopic.units,
              DataTopic.priceLists,
              DataTopic.stock,
            }
          : const {DataTopic.products, DataTopic.priceLists, DataTopic.stock},
      'categories' => const {DataTopic.categories},
      'brands' => const {DataTopic.brands},
      'units' => const {DataTopic.units},
      'prices' => const {DataTopic.priceLists, DataTopic.products},
      'sales' => {
          DataTopic.sales,
          DataTopic.stock,
          DataTopic.restaurant,
          ...customerMoney,
          ...money,
        },
      'returns' => {
          DataTopic.returns,
          DataTopic.sales,
          DataTopic.stock,
          ...customerMoney,
          ...money,
        },
      'shifts' || 'registers' => money,
      'users' => const {DataTopic.users},
      'roles' => const {DataTopic.roles, DataTopic.users},
      'tax-rates' => const {DataTopic.taxRates},
      'khata' => const {DataTopic.followups},
      'settings' => const {DataTopic.taxRates},
      'receipt-layouts' => const {DataTopic.receiptLayouts},
      'adjustments' || 'stock' => const {DataTopic.stock},
      'accounting' => const {DataTopic.accounting},
      'manufacturing' => const {DataTopic.manufacturing, DataTopic.stock},
      'restaurant' => const {DataTopic.restaurant},
      _ => const {},
    };
  }
}
