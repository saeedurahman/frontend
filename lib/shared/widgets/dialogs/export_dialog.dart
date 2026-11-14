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
  });

  final String dataset;
  final String title;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? branchId;

  static Future<void> show(
    BuildContext context, {
    required String dataset,
    required String title,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => ExportDialog(
        dataset: dataset,
        title: title,
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
      ),
    );
  }

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  String _selectedFormat = 'xlsx'; // 'xlsx' or 'csv'

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
      content: Column(
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            ExportService.runExport(
              context: context,
              dataset: widget.dataset,
              format: _selectedFormat,
              dateFrom: widget.dateFrom,
              dateTo: widget.dateTo,
              branchId: widget.branchId,
            );
          },
          icon: const Icon(Icons.download),
          label: const Text('Export Now'),
        ),
      ],
    );
  }
}
