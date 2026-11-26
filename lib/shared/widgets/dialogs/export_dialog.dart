import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/services/export_service.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    super.key,
    required this.dataset,
    required this.title,
    this.dateFrom,
    this.dateTo,
    this.branchId,
    this.filters,
    this.fileLabel,
  });

  final String dataset;
  final String title;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? branchId;

  /// Extra export filters such as `customer_id` / `supplier_id`.
  final Map<String, String>? filters;

  /// When set, this is one person's ledger and the file is named after them:
  /// "Ali Khan ledger 2026-11-26".
  final String? fileLabel;

  static Future<void> show(
    BuildContext context, {
    required String dataset,
    required String title,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
    Map<String, String>? filters,
    String? fileLabel,
  }) async {
    debugPrint('[ExportFlow] ExportDialog.show: dataset=$dataset, title=$title');
    final format = await showDialog<String>(
      context: context,
      builder: (ctx) => ExportDialog(
        dataset: dataset,
        title: title,
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
        filters: filters,
        fileLabel: fileLabel,
      ),
    );
    debugPrint('[ExportFlow] ExportDialog.show: format returned=$format, context.mounted=${context.mounted}');
    if (format != null && context.mounted) {
      await ExportService.runExport(
        context: context,
        dataset: dataset,
        format: format,
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
        filters: filters,
        suggestedName: fileLabel == null
            ? null
            : ExportService.fileNameFor(fileLabel, 'ledger', format, on: dateTo),
      );
    }
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _selectedFormat = 'xlsx'; // 'xlsx', 'csv', or 'pdf'

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.file_download_outlined, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('Export ${widget.title}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your preferred file format to download this dataset:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: const Text('Excel Spreadsheet (.xlsx)'),
              subtitle: const Text('Formatted spreadsheet for Microsoft Excel and Google Sheets'),
              value: 'xlsx',
              groupValue: _selectedFormat,
              onChanged: (val) {
                if (val != null) setState(() => _selectedFormat = val);
              },
            ),
            RadioListTile<String>(
              title: const Text('CSV Document (.csv)'),
              subtitle: const Text('Plain text comma-separated values for data analysis'),
              value: 'csv',
              groupValue: _selectedFormat,
              onChanged: (val) {
                if (val != null) setState(() => _selectedFormat = val);
              },
            ),
            RadioListTile<String>(
              title: const Text('PDF Document (.pdf)'),
              subtitle: const Text('Formatted PDF report ready for printing, sharing or filing'),
              value: 'pdf',
              groupValue: _selectedFormat,
              onChanged: (val) {
                if (val != null) setState(() => _selectedFormat = val);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('[ExportFlow] ExportDialog cancelled by user');
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            final chosen = _selectedFormat;
            debugPrint('[ExportFlow] ExportDialog format confirmed: $chosen');
            Navigator.pop(context, chosen);
          },
          icon: const Icon(Icons.download),
          label: const Text('Export Now'),
        ),
      ],
    );
  }
}
