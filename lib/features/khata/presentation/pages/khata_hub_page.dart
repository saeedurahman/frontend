import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/khata_ui_text.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/followup_dialogs.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_actions.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_hub_row.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_message_dialog.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ui.dart';
import 'package:go_router/go_router.dart';

/// What the hub's buttons do. Tests pass their own to watch the calls.
class KhataHubActions {
  const KhataHubActions({
    required this.open,
    required this.remind,
    required this.pay,
    required this.statement,
    required this.promise,
  });

  /// The app's real dialogs and routes.
  factory KhataHubActions.app(KhataRepository repository) => KhataHubActions(
        open: (context, type, row, branchId) =>
            context.push(type.detailRoute(row.id)),
        remind: (context, type, row, branchId) => showKhataMessageDialog(
          context,
          MessageRequest(
            partyType: type,
            partyId: row.id,
            name: row.name,
            phone: row.phone,
            branchId: branchId,
            knownDue: row.balanceOwed,
          ),
          repository: repository,
        ),
        pay: (context, type, row, branchId) => showKhataPayment(
          context,
          type: type,
          id: row.id,
          name: row.name,
          phone: row.phone,
          branchId: branchId,
        ),
        statement: (context, type, row, branchId) =>
            context.push(type.statementRoute(row.id)),
        promise: (context, type, row, branchId) => showPromiseDialog(
          context,
          repository: repository,
          partyType: type,
          partyId: row.id,
          name: row.name,
          branchId: branchId,
        ),
      );

  final HubAction open;
  final HubAction remind;
  final HubAction pay;
  final HubAction statement;
  final HubAction promise;
}

typedef HubAction = void Function(
  BuildContext context,
  PartyType type,
  HubRow row,
  String? branchId,
);

/// `/khata`: who owes the business, and whom the business owes.
class KhataHubPage extends StatelessWidget {
  const KhataHubPage({
    super.key,
    this.initialTab = PartyType.customer,
    this.createCubit,
    this.actions,
    this.clock = DateTime.now,
  });

  final PartyType initialTab;
  final KhataHubCubit Function()? createCubit;
  final KhataHubActions? actions;
  final DateTime Function() clock;

  KhataHubCubit _create() => KhataHubCubit(
        sl<KhataRepository>(),
        initialTab: initialTab,
        branchId: sl.isRegistered<BranchSelectorCubit>()
            ? sl<BranchSelectorCubit>().state.selectedBranchId
            : null,
        probe: sl.isRegistered<ConnectivityProbe>()
            ? sl<ConnectivityProbe>()
            : null,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => (createCubit?.call() ?? _create())..load(),
      child: Builder(
        builder: (context) {
          final view = _HubView(
            actions: actions ??
                KhataHubActions.app(sl<KhataRepository>()),
            clock: clock,
          );
          if (!sl.isRegistered<BranchSelectorCubit>()) return view;
          return BlocListener<BranchSelectorCubit, BranchSelectorState>(
            bloc: sl<BranchSelectorCubit>(),
            listenWhen: (a, b) =>
                a.selectedBranchId != b.selectedBranchId && b.isInitialized,
            listener: (context, branch) => context
                .read<KhataHubCubit>()
                .onBranchChanged(branch.selectedBranchId),
            child: view,
          );
        },
      ),
    );
  }
}

class _HubView extends StatefulWidget {
  const _HubView({required this.actions, required this.clock});

  final KhataHubActions actions;
  final DateTime Function() clock;

  @override
  State<_HubView> createState() => _HubViewState();
}

class _HubViewState extends State<_HubView> {
  /// Below this content width rows stack and actions move into a menu.
  static const _wideRows = 900.0;

  /// Start loading the next page this far before the end.
  static const _loadAhead = 400.0;

  final _scroll = ScrollController();
  final _search = TextEditingController();
  final _searchFocus = FocusNode(debugLabel: 'khata-search');
  Timer? _typing;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _typing?.cancel();
    _scroll.dispose();
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!mounted || !_scroll.hasClients) return;
    final state = context.read<KhataHubCubit>().state;
    // After a failure the user asks again with the button.
    if (state.loadMoreFailed) return;
    if (_scroll.position.extentAfter < _loadAhead) {
      context.read<KhataHubCubit>().loadMore();
    }
  }

  void _onSearch(String value) {
    _typing?.cancel();
    _typing = Timer(const Duration(milliseconds: 300), () {
      if (mounted) context.read<KhataHubCubit>().setSearch(value);
    });
    setState(() {});
  }

  void _clearSearch() {
    _typing?.cancel();
    _search.clear();
    setState(() {});
    context.read<KhataHubCubit>().setSearch('');
  }

  void _clearFilters() {
    _typing?.cancel();
    _search.clear();
    setState(() {});
    context.read<KhataHubCubit>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true):
            _searchFocus.requestFocus,
        const SingleActivator(LogicalKeyboardKey.f5): () =>
            context.read<KhataHubCubit>().refresh(),
      },
      child: Focus(
        autofocus: true,
        skipTraversal: true,
        child: ColoredBox(
          color: AppColors.background,
          child: BlocConsumer<KhataHubCubit, KhataHubState>(
            // A tall window may show a whole page: fetch the next one.
            listenWhen: (a, b) => a.list != b.list,
            listener: (context, state) => WidgetsBinding.instance
                .addPostFrameCallback((_) => _maybeLoadMore()),
            builder: (context, state) => LayoutBuilder(
              builder: (context, box) => _body(context, state, box.maxWidth),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, KhataHubState state, double width) {
    final edge = width < 720
        ? AppDimensions.spacingMd
        : AppDimensions.spacingLg;
    // Very wide windows keep a comfortable reading width.
    final side = width > AppDimensions.maxContentWidth + edge * 2
        ? (width - AppDimensions.maxContentWidth) / 2
        : edge;
    final content = width - side * 2;
    Widget pad(Widget child) => SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: side),
          sliver: child,
        );
    Widget box(Widget child) => pad(SliverToBoxAdapter(child: child));
    const gap = SliverToBoxAdapter(
      child: SizedBox(height: AppDimensions.spacingMd),
    );

    return CustomScrollView(
      key: const Key('khata-hub-scroll'),
      controller: _scroll,
      slivers: [
        gap,
        box(_header(context, state)),
        gap,
        box(_totals(context, state, content)),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.spacingLg),
        ),
        box(_toolbar(context, state, content)),
        gap,
        ..._list(context, state, content, pad, box),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.spacingLg),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, KhataHubState state) {
    final asOf = state.offlineAsOf;
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: AppDimensions.spacing12,
            runSpacing: AppDimensions.spacingXs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                HubText.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                HubText.subtitle,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              AnimatedSwitcher(
                duration: KhataStyle.fast,
                child: asOf == null
                    ? const SizedBox.shrink()
                    : AsOfLabel(
                        key: const Key('khata-as-of'),
                        asOf: asOf,
                        now: widget.clock(),
                      ),
              ),
              if (state.supplierAllBranches)
                const Text(
                  KhataText.offlineAllBranches,
                  key: Key('khata-all-branches'),
                  style: TextStyle(color: AppColors.textSecondary),
                ),
            ],
          ),
        ),
        IconButton(
          key: const Key('khata-refresh'),
          tooltip: '${HubText.refresh} (F5)',
          onPressed: context.read<KhataHubCubit>().refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  Widget _totals(BuildContext context, KhataHubState state, double width) {
    final overview = state.overview?.value;
    Widget card(PartyType type) {
      if (overview == null) {
        // Offline with nothing kept: no figure is better than a wrong one.
        if (!state.loading) return const SizedBox.shrink();
        return const KhataTotalCardSkeleton();
      }
      return KhataTotalCard(
        key: ValueKey('khata-total-${type.apiValue}'),
        type: type,
        side: overview.side(type),
        selected: state.tab == type,
        onTap: () => context.read<KhataHubCubit>().setTab(type),
      );
    }

    if (width < 640) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          card(PartyType.customer),
          const SizedBox(height: AppDimensions.spacing12),
          card(PartyType.supplier),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: card(PartyType.customer)),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(child: card(PartyType.supplier)),
      ],
    );
  }

  Widget _toolbar(BuildContext context, KhataHubState state, double width) {
    final cubit = context.read<KhataHubCubit>();
    final buckets = state.list?.page.buckets;
    final chips = Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingSm,
      children: [
        KhataFilterPill(
          key: const ValueKey('bucket-all'),
          label: KhataUiText.allBuckets,
          value: buckets == null ? null : formatPKR(buckets.total),
          selected: state.bucket == null,
          onTap: () => cubit.setBucket(null),
        ),
        for (final b in AgeBucket.values)
          KhataFilterPill(
            key: ValueKey('bucket-${b.apiValue}'),
            label: KhataUiText.bucketLabel(b.apiValue),
            value: buckets == null ? null : formatPKR(buckets[b]),
            color: KhataStyle.agingColor(state.tab, b),
            selected: state.bucket == b,
            onTap: () => cubit.setBucket(state.bucket == b ? null : b),
          ),
      ],
    );

    final search = TextField(
      key: const Key('khata-search'),
      controller: _search,
      focusNode: _searchFocus,
      onChanged: _onSearch,
      maxLength: 100,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        hintText: HubText.searchHint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        // As tall as the sort button beside it.
        constraints: const BoxConstraints.tightFor(height: 40),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
          vertical: AppDimensions.spacingSm,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _search.text.isEmpty
            ? null
            : IconButton(
                tooltip: HubText.clearSearch,
                onPressed: _clearSearch,
                icon: const Icon(Icons.close, size: 16),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );

    const sortLabels = {
      HubSort.amount: HubText.sortAmount,
      HubSort.age: HubText.sortOldest,
      HubSort.name: HubText.sortName,
    };
    final sort = PopupMenuButton<HubSort>(
      key: const Key('khata-sort'),
      tooltip: HubText.sortLabel,
      initialValue: state.sort,
      onSelected: cubit.setSort,
      itemBuilder: (_) => [
        for (final entry in sortLabels.entries)
          CheckedPopupMenuItem<HubSort>(
            key: ValueKey('sort-${entry.key.name}'),
            value: entry.key,
            checked: state.sort == entry.key,
            child: Text(entry.value),
          ),
      ],
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert, size: 16),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              '${HubText.sortLabel}: ${sortLabels[state.sort]}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

    final tabs = KhataSegmented<PartyType>(
      selected: state.tab,
      options: const [
        (PartyType.customer, HubText.tabCustomers),
        (PartyType.supplier, HubText.tabSuppliers),
      ],
      onChanged: cubit.setTab,
    );
    final finder = Row(
      children: [
        Expanded(child: search),
        const SizedBox(width: AppDimensions.spacingSm),
        sort,
      ],
    );
    // Wide windows keep the search beside the tabs, so the chips always get
    // the full width.
    final top = width >= 1000
        ? Row(
            children: [
              Expanded(
                child: Align(alignment: Alignment.centerLeft, child: tabs),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              SizedBox(width: 440, child: finder),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(alignment: Alignment.centerLeft, child: tabs),
              const SizedBox(height: AppDimensions.spacingMd),
              finder,
            ],
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        top,
        const SizedBox(height: AppDimensions.spacing12),
        chips,
      ],
    );
  }

  List<Widget> _list(
    BuildContext context,
    KhataHubState state,
    double width,
    Widget Function(Widget sliver) pad,
    Widget Function(Widget child) box,
  ) {
    final cubit = context.read<KhataHubCubit>();
    final list = state.list;
    if (list == null) {
      if (state.loading) {
        return [box(const SkeletonRows(key: Key('khata-loading')))];
      }
      return [
        box(
          KhataEmptyState(
            key: const Key('khata-error'),
            icon: state.errorIsOffline
                ? Icons.cloud_off_outlined
                : Icons.error_outline,
            color: AppColors.warning,
            title: state.error ?? KhataUiText.somethingWrong,
            message: state.errorIsOffline ? HubText.offlineNoCopy : null,
            actionLabel: KhataUiText.retry,
            onAction: cubit.load,
          ),
        ),
      ];
    }
    if (list.rows.isEmpty) {
      final filtered = state.hasFilters;
      final customers = state.tab.isCustomer;
      return [
        box(
          KhataEmptyState(
            key: const Key('khata-empty'),
            icon: filtered
                ? Icons.search_off_outlined
                : Icons.celebration_outlined,
            title: filtered
                ? HubText.emptyFilterTitle
                : customers
                    ? HubText.emptyCustomersTitle
                    : HubText.emptySuppliersTitle,
            message: filtered
                ? HubText.emptyFilterBody
                : customers
                    ? HubText.emptyCustomersBody
                    : HubText.emptySuppliersBody,
            actionLabel: filtered ? HubText.clearFilters : null,
            onAction: filtered ? _clearFilters : null,
          ),
        ),
      ];
    }

    final narrow = width < _wideRows;
    final type = state.tab;
    final branchId = cubit.branchId;
    final actions = widget.actions;
    final now = widget.clock();
    return [
      pad(
        SliverList.builder(
          itemCount: list.rows.length,
          itemBuilder: (context, index) {
            final row = list.rows[index];
            return Padding(
              key: ValueKey('${state.generation}-${type.name}-${row.id}'),
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: StaggeredEntry(
                index: index,
                child: KhataHubRowTile(
                  key: ValueKey('hub-row-${row.id}'),
                  row: row,
                  type: type,
                  narrow: narrow,
                  now: now,
                  onOpen: () => actions.open(context, type, row, branchId),
                  actions: [
                    HubRowAction(
                      id: 'remind',
                      label: HubText.remind,
                      icon: Icons.chat_outlined,
                      permission: Perm.khataFollowupsCreate,
                      onRun: () =>
                          actions.remind(context, type, row, branchId),
                    ),
                    HubRowAction(
                      id: 'pay',
                      label: type.isCustomer
                          ? HubText.recordPayment
                          : HubText.paySupplier,
                      icon: Icons.payments_outlined,
                      permission: type.paymentPermission,
                      mutating: true,
                      onRun: () => actions.pay(context, type, row, branchId),
                    ),
                    HubRowAction(
                      id: 'statement',
                      label: HubText.statement,
                      icon: Icons.receipt_long_outlined,
                      permission: Perm.khataView,
                      onRun: () =>
                          actions.statement(context, type, row, branchId),
                    ),
                    HubRowAction(
                      id: 'promise',
                      label: HubText.addPromise,
                      icon: Icons.event_available_outlined,
                      permission: Perm.khataFollowupsCreate,
                      mutating: true,
                      onRun: () =>
                          actions.promise(context, type, row, branchId),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      box(_footer(context, state, list)),
    ];
  }

  Widget _footer(BuildContext context, KhataHubState state, HubList list) {
    if (state.loadingMore) {
      return const Column(
        key: Key('khata-loading-more'),
        children: [SkeletonRows(count: 2)],
      );
    }
    if (state.loadMoreFailed) {
      return Center(
        child: TextButton.icon(
          key: const Key('khata-load-more-retry'),
          onPressed: context.read<KhataHubCubit>().loadMore,
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text(
            '${HubText.loadMoreFailed}. ${KhataUiText.retry}',
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacingSm),
      child: Text(
        HubText.shownOf(list.rows.length, list.page.total),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
  }
}
