import 'dart:async';

/// What a write changed. A screen watches the topics its data comes from.
enum DataTopic {
  customers,
  customerLedger,
  suppliers,
  supplierLedger,
  expenses,
  expenseCategories,
  purchases,
  products,
  categories,
  brands,
  units,
  priceLists,
  users,
  roles,
  taxRates,
  shifts,
  cashMovements,
  returns,
  sales,
  stock,
  receiptLayouts,
  accounting,
  manufacturing,
  restaurant,
}

class DataChange {
  const DataChange(this.topics, {this.createdIds = const {}});

  final Set<DataTopic> topics;

  /// Ids of records this change created, so a list can keep them in sight.
  final Set<String> createdIds;

  @override
  String toString() => 'DataChange($topics, created: $createdIds)';
}

/// The one place writes are announced.
///
/// There are two writers and both publish here, so no form has to remember to
/// tell a list:
/// * the server (every accepted non-GET request, see `DataChangeInterceptor`);
/// * the device (`SyncStore`: queued actions, sync results and pulled rows).
///
/// Screens listen with the `AutoRefresh` mixin.
class DataChangeBus {
  DataChangeBus();

  /// The app's bus.
  static final DataChangeBus instance = DataChangeBus();

  final StreamController<DataChange> _changes =
      StreamController<DataChange>.broadcast();

  Stream<DataChange> get changes => _changes.stream;

  void publish(Set<DataTopic> topics, {Set<String> createdIds = const {}}) {
    if (topics.isEmpty || _changes.isClosed) return;
    _changes.add(DataChange(topics, createdIds: createdIds));
  }
}
