import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_models.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/sync/domain/sync_access.dart';
import 'package:frantend/core/utils/currency_label.dart';

/// Offline sales the server accepted but flagged (oversold, price mismatch,
/// credit limit exceeded ...), for the owner or a manager (`GET /sync/flags`),
/// and the flagged customer payments this device sent.
class FlagsPage extends StatefulWidget {
  const FlagsPage({super.key, this.api, this.allowed, this.payments});

  final SyncApi? api;
  final bool? allowed;

  /// This device's flagged customer payments (defaults to the local store).
  final Future<List<FlaggedPayment>> Function()? payments;

  @override
  State<FlagsPage> createState() => _FlagsPageState();
}

class _FlagsPageState extends State<FlagsPage> {
  late Future<List<FlaggedSale>> _future = _fetch();
  late final Future<List<FlaggedPayment>> _payments = _localPayments();

  Future<List<FlaggedSale>> _fetch() => (widget.api ?? sl<SyncApi>()).flags();

  Future<List<FlaggedPayment>> _localPayments() async {
    final load = widget.payments ??
        (sl.isRegistered<SyncStore>() ? sl<SyncStore>().flaggedPayments : null);
    if (load == null) return const [];
    // Newest first, like the sales.
    return (await load()).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final allowed = widget.allowed ??
        SyncAccess.canReviewFlags(sl<AccessCubit>().state.access);
    if (!allowed) {
      return const Center(
        child: Text('Only the owner or a manager can review flagged sales.'),
      );
    }
    return FutureBuilder<List<FlaggedPayment>>(
      future: _payments,
      builder: (context, local) => FutureBuilder<List<FlaggedSale>>(
        future: _future,
        builder: (context, snapshot) {
          final payments = local.data ?? const <FlaggedPayment>[];
          final done = snapshot.connectionState == ConnectionState.done;
          final sales = snapshot.data ?? const <FlaggedSale>[];
          final Widget? status;
          if (!done) {
            status = const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            status = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load flagged sales. Check the connection.',
                  ),
                  TextButton(
                    onPressed: () => setState(() => _future = _fetch()),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          } else if (sales.isEmpty) {
            status = const Center(
              child: Text('No sales need review.', key: Key('no-flags')),
            );
          } else {
            status = null;
          }
          if (status != null && payments.isEmpty) return status;
          final items = <Widget>[
            for (final p in payments) _FlaggedPaymentTile(payment: p),
            if (status != null) status,
            if (status == null)
              for (final sale in sales) _FlaggedTile(sale: sale),
          ];
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => items[i],
          );
        },
      ),
    );
  }
}

class _FlaggedTile extends StatelessWidget {
  const _FlaggedTile({required this.sale});
  final FlaggedSale sale;

  @override
  Widget build(BuildContext context) => _FlagCard(
        title: '${sale.saleNumber}'
            '${sale.clientReceiptNo == null ? '' : '  (receipt ${sale.clientReceiptNo})'}'
            '  -  $currencyLabel ${sale.totalAmount}',
        subtitle: 'Cashier ${sale.cashierName}',
        flags: sale.flags,
        explain: SyncErrorText.flag,
      );
}

class _FlaggedPaymentTile extends StatelessWidget {
  const _FlaggedPaymentTile({required this.payment});
  final FlaggedPayment payment;

  @override
  Widget build(BuildContext context) {
    final taken = payment.takenAt;
    return _FlagCard(
      key: Key('flagged-payment-${payment.opId}'),
      title: 'Customer payment'
          '${payment.customerName == null ? '' : ' from ${payment.customerName}'}'
          '  -  $currencyLabel ${payment.amount}',
      subtitle: taken == null
          ? 'Taken on this device'
          : 'Taken on this device, '
              '${DateFormat('d MMM yyyy, h:mm a').format(taken.toLocal())}',
      flags: payment.flags,
      explain: SyncErrorText.paymentFlag,
    );
  }
}

class _FlagCard extends StatelessWidget {
  const _FlagCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.flags,
    required this.explain,
  });

  final String title;
  final String subtitle;
  final List<String> flags;
  final String Function(String code) explain;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            for (final flag in flags)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.flag, size: 16, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (SyncErrorText.flagTitle[flag] != null)
                            Text(
                              SyncErrorText.flagTitle[flag]!,
                              key: Key('flag-title-$flag'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          Text(explain(flag), key: Key('flag-text-$flag')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
