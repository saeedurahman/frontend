import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

/// The rows of one tab as last loaded, so switching back is instant.
class HubList {
  const HubList({
    required this.page,
    required this.rows,
    required this.offline,
    this.asOf,
    this.allBranches = false,
  });

  /// Totals and bucket figures of the latest answer.
  final HubPage page;
  final List<HubRow> rows;
  final bool offline;
  final DateTime? asOf;

  /// A branch was asked for, but these figures cover all of them.
  final bool allBranches;

  bool get hasMore => !offline && rows.length < page.total;
}

class KhataHubState {
  const KhataHubState({
    this.tab = PartyType.customer,
    this.bucket,
    this.sort = HubSort.amount,
    this.search = '',
    this.overview,
    this.list,
    this.loading = true,
    this.loadingMore = false,
    this.error,
    this.errorIsOffline = false,
    this.loadMoreFailed = false,
    this.generation = 0,
  });

  final PartyType tab;
  final AgeBucket? bucket;
  final HubSort sort;
  final String search;

  /// The two header cards (both tabs).
  final KhataData<KhataOverview>? overview;

  /// The rows for the current tab and filters; null until the first answer.
  final HubList? list;
  final bool loading;
  final bool loadingMore;

  /// Why there is nothing to show.
  final String? error;
  final bool errorIsOffline;
  final bool loadMoreFailed;

  /// Grows when the list is replaced, so rows animate in again.
  final int generation;

  bool get hasFilters => bucket != null || search.trim().isNotEmpty;

  /// A branch is picked, but a supplier figure on screen is over all of them.
  bool get supplierAllBranches =>
      (overview?.allBranches ?? false) || (list?.allBranches ?? false);

  /// Some figure on screen comes from the copy on this device.
  DateTime? get offlineAsOf {
    final l = list;
    if (l != null && l.offline) return l.asOf;
    final o = overview;
    if (o != null && o.offline) return o.asOf;
    return null;
  }

  KhataHubState copyWith({
    PartyType? tab,
    AgeBucket? bucket,
    bool allBuckets = false,
    HubSort? sort,
    String? search,
    KhataData<KhataOverview>? overview,
    bool clearOverview = false,
    HubList? list,
    bool clearList = false,
    bool? loading,
    bool? loadingMore,
    String? error,
    bool clearError = false,
    bool? errorIsOffline,
    bool? loadMoreFailed,
    int? generation,
  }) =>
      KhataHubState(
        tab: tab ?? this.tab,
        bucket: allBuckets ? null : bucket ?? this.bucket,
        sort: sort ?? this.sort,
        search: search ?? this.search,
        overview: clearOverview ? null : overview ?? this.overview,
        list: clearList ? null : list ?? this.list,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        error: clearError ? null : error ?? this.error,
        errorIsOffline: errorIsOffline ?? this.errorIsOffline,
        loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
        generation: generation ?? this.generation,
      );
}

class KhataHubCubit extends Cubit<KhataHubState>
    with AutoRefresh<KhataHubState> {
  KhataHubCubit(
    this._repository, {
    PartyType initialTab = PartyType.customer,
    String? branchId,
    ConnectivityProbe? probe,
    this.pageSize = 50,
    DataChangeBus? bus,
  })  : _branchId = branchId,
        super(KhataHubState(tab: initialTab)) {
    watchData(
      const {
        DataTopic.customers,
        DataTopic.customerLedger,
        DataTopic.suppliers,
        DataTopic.supplierLedger,
        DataTopic.followups,
      },
      refresh,
      bus: bus,
    );
    // Back online: replace the kept copy with fresh figures.
    _connectivity = probe?.status.listen((status) {
      if (status != ReachabilityStatus.offline) refresh();
    });
  }

  final KhataRepository _repository;
  final int pageSize;
  String? _branchId;
  StreamSubscription<ReachabilityStatus>? _connectivity;

  /// The largest page the server gives.
  static const _maxPage = 200;

  /// Unfiltered rows per tab, shown at once when the user comes back.
  final Map<PartyType, HubList> _seen = {};

  String? get branchId => _branchId;

  HubQuery get _query => HubQuery(
        party: state.tab,
        search: state.search,
        bucket: state.bucket,
        sort: state.sort,
        branchId: _branchId,
      );

  Future<void> load() => _reload(showSkeleton: state.list == null);

  Future<void> onBranchChanged(String? branchId) async {
    if (branchId == _branchId) return;
    _branchId = branchId;
    _seen.clear();
    emit(state.copyWith(clearList: true, clearOverview: true));
    await _reload(showSkeleton: true);
  }

  Future<void> setTab(PartyType tab) async {
    if (tab == state.tab) return;
    final seen = _seen[tab];
    final reuse = seen != null && state.search.trim().isEmpty;
    emit(
      state.copyWith(
        tab: tab,
        allBuckets: true,
        list: reuse ? seen : null,
        clearList: !reuse,
        clearError: true,
        generation: state.generation + 1,
      ),
    );
    await _reload(showSkeleton: !reuse);
  }

  Future<void> setBucket(AgeBucket? bucket) async {
    if (bucket == state.bucket) return;
    emit(state.copyWith(bucket: bucket, allBuckets: bucket == null));
    await _reload(replace: true);
  }

  Future<void> setSort(HubSort sort) async {
    if (sort == state.sort) return;
    emit(state.copyWith(sort: sort));
    await _reload(replace: true);
  }

  Future<void> setSearch(String search) async {
    if (search.trim() == state.search.trim()) return;
    emit(state.copyWith(search: search));
    await _reload(replace: true);
  }

  Future<void> clearFilters() async {
    if (!state.hasFilters) return;
    emit(state.copyWith(search: '', allBuckets: true));
    await _reload(replace: true);
  }

  /// A quiet re-read: no skeleton, and as many rows as are on screen.
  Future<void> refresh() => _reload(keepDepth: true);

  Future<void> _reload({
    bool showSkeleton = false,
    bool replace = false,
    bool keepDepth = false,
  }) async {
    final read = beginRead();
    final query = _query;
    final depth = keepDepth ? state.list?.rows.length ?? 0 : 0;
    emit(
      state.copyWith(
        loading: showSkeleton || state.list == null,
        loadingMore: false,
        loadMoreFailed: false,
      ),
    );

    final overview = _repository.overview(branchId: _branchId);
    final first = await _repository.hub(
      query,
      limit: depth > pageSize ? depth.clamp(pageSize, _maxPage) : pageSize,
    );
    final totals = await overview;
    if (isStale(read)) return;
    totals.fold((_) {}, (data) => emit(state.copyWith(overview: data)));

    await first.fold<Future<void>>(
      (failure) async => _failed(failure, keepRows: !replace),
      (data) async {
        var rows = data.value.items;
        // More rows were on screen than one request returns.
        while (!data.offline &&
            rows.length < depth &&
            rows.length < data.value.total) {
          final next = await _repository.hub(
            query,
            skip: rows.length,
            limit: _maxPage,
          );
          if (isStale(read)) return;
          final more = next.fold((_) => null, (d) => d.value.items);
          if (more == null || more.isEmpty) break;
          rows = _merge(rows, more);
        }
        final list = HubList(
          page: data.value,
          rows: rows,
          offline: data.offline,
          asOf: data.asOf,
          allBranches: data.allBranches,
        );
        if (query.isUnfiltered) _seen[query.party] = list;
        emit(
          state.copyWith(
            list: list,
            loading: false,
            clearError: true,
            errorIsOffline: false,
            generation: replace ? state.generation + 1 : state.generation,
          ),
        );
      },
    );
  }

  /// A refresh that fails keeps the rows; a new filter must not show rows
  /// that don't match it.
  void _failed(Failure failure, {required bool keepRows}) {
    final keep = keepRows && state.list != null;
    emit(
      state.copyWith(
        loading: false,
        clearList: !keep,
        error: keep ? null : failure.message,
        clearError: keep,
        errorIsOffline: failure is NetworkFailure,
      ),
    );
  }

  static List<HubRow> _merge(List<HubRow> have, List<HubRow> more) {
    final ids = {for (final r in have) r.id};
    return [...have, ...more.where((r) => !ids.contains(r.id))];
  }

  Future<void> loadMore() async {
    final list = state.list;
    if (list == null || !list.hasMore || state.loadingMore || state.loading) {
      return;
    }
    final read = beginRead();
    final query = _query;
    emit(state.copyWith(loadingMore: true, loadMoreFailed: false));
    final next = await _repository.hub(
      query,
      skip: list.rows.length,
      limit: pageSize,
    );
    if (isStale(read)) return;
    next.fold(
      (_) => emit(state.copyWith(loadingMore: false, loadMoreFailed: true)),
      (data) {
        if (data.offline) {
          // The connection dropped: the kept copy is the whole list now.
          emit(
            state.copyWith(
              loadingMore: false,
              list: HubList(
                page: data.value,
                rows: data.value.items,
                offline: true,
                asOf: data.asOf,
                allBranches: data.allBranches,
              ),
            ),
          );
          return;
        }
        final rows = _merge(list.rows, data.value.items);
        final grown = HubList(
          // A page with nothing new means the end, whatever the count says.
          page: rows.length == list.rows.length
              ? HubPage(
                  items: data.value.items,
                  total: rows.length,
                  partyCount: data.value.partyCount,
                  balanceOwed: data.value.balanceOwed,
                  buckets: data.value.buckets,
                )
              : data.value,
          rows: rows,
          offline: false,
          asOf: data.asOf,
        );
        if (query.isUnfiltered) _seen[query.party] = grown;
        emit(state.copyWith(loadingMore: false, list: grown));
      },
    );
  }

  @override
  Future<void> close() {
    unawaited(_connectivity?.cancel() ?? Future<void>.value());
    return super.close();
  }
}
