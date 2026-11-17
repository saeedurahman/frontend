import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/inventory/data/expiry_report.dart';
import 'package:frantend/features/inventory/domain/batch_picker.dart';
import 'package:frantend/features/inventory/presentation/widgets/batch_chip.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart' show ReceiptApiException;
import 'package:frantend/shared/widgets/dialogs/export_dialog.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';

/// Stock that has expired or is about to, with its value, and an export.
class ExpiryReportPage extends StatefulWidget {
  const ExpiryReportPage({super.key, this.loader, this.branchId, this.initialDays = 30});

  /// Test seam; defaults to the server report.
  final ExpiryReportLoader? loader;
  final String? branchId;
  final int initialDays;

  @override
  State<ExpiryReportPage> createState() => _ExpiryReportPageState();
}

class _ExpiryReportPageState extends State<ExpiryReportPage> {
  static const windows = [30, 60, 90];

  late int _days = widget.initialDays;
  ExpiryReport? _report;
  String? _error;
  bool _offline = false;
  bool _loading = true;

  String? get _branchId {
    if (widget.branchId != null) return widget.branchId;
    try {
      return sl<BranchSelectorCubit>().state.selectedBranchId;
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _offline = false;
    });
    try {
      final loader = widget.loader ?? sl<ExpiryReportApi>().load;
      final report = await loader(withinDays: _days, branchId: _branchId);
      if (!mounted) return;
      setState(() {
        _report = report;
        _loading = false;
      });
    } on ReceiptApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _offline = e.offline;
        _error = e.offline
            ? 'You are offline. The expiry report needs the internet; try again when you are connected.'
            : e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Expiry report'),
        actions: [
          PermissionGate(
            permission: Perm.reportsExport,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: OutlinedButton.icon(
                key: const Key('expiry-export'),
                onPressed: () => ExportDialog.show(
                  context,
                  dataset: 'expiry',
                  title: 'Expiry report',
                  branchId: _branchId,
                ),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Export'),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_offline ? Icons.cloud_off : Icons.error_outline, size: 40),
                        const SizedBox(height: 12),
                        Text(_error!, key: const Key('expiry-error'), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        OutlinedButton(onPressed: _load, child: const Text('Try again')),
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        Text('Show stock expiring within', style: AppTextStyles.bodyMedium),
                        const SizedBox(width: 12),
                        SegmentedButton<int>(
                          key: const Key('expiry-window'),
                          showSelectedIcon: false,
                          segments: [
                            for (final d in windows)
                              ButtonSegment(value: d, label: Text('$d days')),
                          ],
                          selected: {_days},
                          onSelectionChanged: (s) {
                            setState(() => _days = s.first);
                            _load();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (report != null) ...[
                      _Totals(report: report),
                      const SizedBox(height: 16),
                      if (report.isEmpty)
                        const Card(
                          key: Key('expiry-empty'),
                          child: ListTile(
                            leading: Icon(Icons.check_circle_outline, color: Colors.green),
                            title: Text('Nothing is expired or close to expiry.'),
                          ),
                        ),
                      if (report.expired.isNotEmpty)
                        _Section(
                          key: const Key('expiry-expired'),
                          title: 'Expired',
                          rows: report.expired,
                          status: ExpiryStatus.expired,
                        ),
                      if (report.nearExpiry.isNotEmpty)
                        _Section(
                          key: const Key('expiry-near'),
                          title: 'Expiring in the next ${report.withinDays} days',
                          rows: report.nearExpiry,
                          status: ExpiryStatus.near,
                        ),
                    ],
                  ],
                ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.report});

  final ExpiryReport report;

  @override
  Widget build(BuildContext context) {
    Widget card(String key, String title, String qty, String value, ExpiryStatus s) {
      final colors = expiryColors(s);
      return Expanded(
        child: Card(
          key: Key(key),
          color: colors.bg,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: colors.fg, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Rs $value', style: AppTextStyles.titleMedium.copyWith(color: colors.fg)),
                Text('$qty units', style: TextStyle(color: colors.fg)),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        card('expiry-total-expired', 'Expired', report.totals.expiredQty,
            report.totals.expiredValue, ExpiryStatus.expired),
        card('expiry-total-near', 'Near expiry', report.totals.nearExpiryQty,
            report.totals.nearExpiryValue, ExpiryStatus.near),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({super.key, required this.title, required this.rows, required this.status});

  final String title;
  final List<ExpiryRow> rows;
  final ExpiryStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = expiryColors(status);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.titleMedium.copyWith(color: colors.fg)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Batch')),
                  DataColumn(label: Text('Expiry')),
                  DataColumn(label: Text('Days')),
                  DataColumn(label: Text('Qty'), numeric: true),
                  DataColumn(label: Text('Value (Rs)'), numeric: true),
                ],
                rows: [
                  for (final r in rows)
                    DataRow(cells: [
                      DataCell(Text(
                        r.variation == null ? r.product : '${r.product} (${r.variation})',
                      )),
                      DataCell(Text(r.batchNo ?? '—')),
                      DataCell(Text(r.expiryDate)),
                      DataCell(Text(
                        r.expired ? '${-r.daysToExpiry} ago' : '${r.daysToExpiry}',
                        style: TextStyle(color: colors.fg, fontWeight: FontWeight.w600),
                      )),
                      DataCell(Text(r.qty)),
                      DataCell(Text(r.value)),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
