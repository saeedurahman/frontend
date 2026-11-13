import 'package:equatable/equatable.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';

/// Hand-written (no code generation): the picker reads customers from the
/// device and marks the ones the server has not accepted yet.
class CustomerPickerState extends Equatable {
  const CustomerPickerState({
    this.searchQuery = '',
    this.results = const [],
    this.unsyncedIds = const {},
    this.isSearching = false,
    this.isCreating = false,
    this.error,
    this.showCreateForm = false,
  });

  final String searchQuery;
  final List<CustomerModel> results;

  /// Customers created on this device that are still waiting to sync.
  final Set<String> unsyncedIds;
  final bool isSearching;
  final bool isCreating;
  final String? error;
  final bool showCreateForm;

  bool isUnsynced(String customerId) => unsyncedIds.contains(customerId);

  static const _keep = Object();

  /// [error] is replaced whenever it is passed, also with `null`.
  CustomerPickerState copyWith({
    String? searchQuery,
    List<CustomerModel>? results,
    Set<String>? unsyncedIds,
    bool? isSearching,
    bool? isCreating,
    Object? error = _keep,
    bool? showCreateForm,
  }) =>
      CustomerPickerState(
        searchQuery: searchQuery ?? this.searchQuery,
        results: results ?? this.results,
        unsyncedIds: unsyncedIds ?? this.unsyncedIds,
        isSearching: isSearching ?? this.isSearching,
        isCreating: isCreating ?? this.isCreating,
        error: identical(error, _keep) ? this.error : error as String?,
        showCreateForm: showCreateForm ?? this.showCreateForm,
      );

  @override
  List<Object?> get props => [
        searchQuery,
        results,
        unsyncedIds,
        isSearching,
        isCreating,
        error,
        showCreateForm,
      ];
}
