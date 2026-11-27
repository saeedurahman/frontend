import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/domain/text/party_text.dart';
import 'package:frantend/features/khata/presentation/cubit/party_khata_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_segmented.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_cards.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// A party's account with its pending bills, promise and timeline: side by
/// side on a wide window, as tabs on a narrow one.
///
/// Shows only [account] to people without `khata.view`.
class PartyKhataLayout extends StatelessWidget {
  const PartyKhataLayout({
    super.key,
    required this.type,
    required this.partyId,
    required this.name,
    required this.account,
    this.branchId,
    this.repository,
    this.clock = DateTime.now,
  });

  final PartyType type;
  final String partyId;
  final String name;
  final Widget account;
  final String? branchId;
  final KhataRepository? repository;
  final DateTime Function() clock;

  /// From this content width the cards sit beside the account.
  static const wideFrom = 1100.0;
  static const panelWidth = 360.0;

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? khataRepositoryIfAny();
    if (repo == null || !hasPermission(context, Perm.khataView)) {
      return account;
    }
    return BlocProvider(
      key: ValueKey('party-khata-$partyId'),
      create: (_) => PartyKhataCubit(
        repo,
        partyType: type,
        partyId: partyId,
        branchId: branchId,
        probe: sl.isRegistered<ConnectivityProbe>()
            ? sl<ConnectivityProbe>()
            : null,
      )..load(),
      child: _Layout(
        name: name,
        branchId: branchId,
        account: account,
        clock: clock,
      ),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout({
    required this.name,
    required this.branchId,
    required this.account,
    required this.clock,
  });

  final String name;
  final String? branchId;
  final Widget account;
  final DateTime Function() clock;

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  int _tab = 0;

  /// The account keeps its scroll and page when the layout changes.
  final _accountKey = GlobalKey();

  @override
  void didUpdateWidget(_Layout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branchId != widget.branchId) {
      context.read<PartyKhataCubit>().onBranchChanged(widget.branchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = _MinHeight(
      child: KeyedSubtree(key: _accountKey, child: widget.account),
    );
    final bills = PendingBillsCard(clock: widget.clock);
    final promise = PromiseCard(name: widget.name, clock: widget.clock);
    final timeline =
        FollowupTimelineCard(name: widget.name, clock: widget.clock);

    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth >= PartyKhataLayout.wideFrom) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: account),
              const SizedBox(width: AppDimensions.spacingMd),
              SizedBox(
                width: PartyKhataLayout.panelWidth,
                child: _Scroll(
                  key: const Key('party-side-panel'),
                  children: [bills, promise, timeline],
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: KhataSegmented<int>(
                key: const Key('party-tabs'),
                maxWidth: 520,
                options: const [
                  (0, PartyText.accountTab),
                  (1, PartyText.billsTab),
                  (2, PartyText.followupsTab),
                ],
                selected: _tab,
                onChanged: (tab) => setState(() => _tab = tab),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Expanded(
              child: IndexedStack(
                index: _tab,
                sizing: StackFit.expand,
                children: [
                  account,
                  _Scroll(children: [bills]),
                  _Scroll(children: [promise, timeline]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// On a short window the account scrolls instead of squashing its table.
class _MinHeight extends StatelessWidget {
  const _MinHeight({required this.child});

  final Widget child;

  static const _height = 560.0;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) => box.maxHeight >= _height
            ? child
            : SingleChildScrollView(
                child: SizedBox(height: _height, child: child),
              ),
      );
}

class _Scroll extends StatelessWidget {
  const _Scroll({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        // Room for the card shadows.
        padding: const EdgeInsets.only(
          right: AppDimensions.spacingXs,
          bottom: AppDimensions.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: AppDimensions.spacingMd),
              children[i],
            ],
          ],
        ),
      );
}
