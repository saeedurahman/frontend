import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/features/sync/domain/sync_access.dart';

/// Offline sales the server accepted but flagged (oversold, price mismatch,
/// credit limit exceeded ...), for the owner or a manager (`GET /sync/flags`).
class FlagsPage extends StatefulWidget {
  const FlagsPage({super.key, this.api, this.allowed});

  final SyncApi? api;
  final bool? allowed;

  @override
  State<FlagsPage> createState() => _FlagsPageState();
}

class _FlagsPageState extends State<FlagsPage> {
  late Future<List<FlaggedSale>> _future = _fetch();

  Future<List<FlaggedSale>> _fetch() => (widget.api ?? sl<SyncApi>()).flags();

  @override
  Widget build(BuildContext context) {
    final allowed = widget.allowed ??
        SyncAccess.canReviewFlags(sl<AccessCubit>().state.access);
    if (!allowed) {
      return const Center(
        child: Text('Only the owner or a manager can review flagged sales.'),
      );
    }
    return FutureBuilder<List<FlaggedSale>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load flagged sales. Check the connection.'),
                TextButton(
                  onPressed: () => setState(() => _future = _fetch()),
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }
        final sales = snapshot.data ?? const [];
        if (sales.isEmpty) {
          return const Center(
            child: Text('No sales need review.', key: Key('no-flags')),
          );
        }
        return ListView.separated(
          itemCount: sales.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _FlaggedTile(sale: sales[i]),
        );
      },
    );
  }
}

class _FlaggedTile extends StatelessWidget {
  const _FlaggedTile({required this.sale});
  final FlaggedSale sale;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${sale.saleNumber}'
              '${sale.clientReceiptNo == null ? '' : '  (receipt ${sale.clientReceiptNo})'}'
              '  -  Rs ${sale.totalAmount}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'Cashier ${sale.cashierName}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            for (final flag in sale.flags)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flag, size: 16, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Expanded(child: Text(SyncErrorText.flag(flag))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
